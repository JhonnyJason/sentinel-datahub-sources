############################################################
#region debug
import { createLogFunctions } from "thingy-debug"
{log, olog} = createLogFunctions("marketstackmodule")
#endregion

############################################################
import fs from "node:fs"
import path from "node:path"
import { nextDay, prevDay, generateDateRange } from "./dateutilsmodule.js"

############################################################
accessToken = null
apiURL = null


############################################################
symbolsDataPath = path.resolve(".", "symbols.json")
currenciesDataPath = path.resolve(".", "currencies.json")
symbolsData = []
currenciesData = []

############################################################
# to protect a general rate limit - we need to block the API
apiBlocked = false 

############################################################
export initialize = (c) ->
    log "initialize"
    if c.mrktStackSecret? then accessToken = c.mrktStackSecret
    if c.urlMrktStack? then apiURL = c.urlMrktStack
    return


############################################################
#region Stock EOD API - Pull Model

############################################################
# Main export: Get all available history for a ticker
# Returns: DataSet with meta.historyComplete flag, or null on error/no data
export getStockAllHistory = (ticker) ->
    log "getStockAllHistory: #{ticker}"

    # Fetch all pages
    fetchResult = await fetchAllEodPages(ticker)
    return null unless fetchResult?  # API blocked

    # Log errors but continue processing any data we got
    if fetchResult.error?
        err = fetchResult.error
        if isPlanLimitError(err) then log "Plan limit reached: #{err.code}"
        else log "API error: #{err.code}: #{err.message}"

    # No data to process
    if fetchResult.data.length == 0
        log "No data received"
        return null

    # Normalize to DataSet format
    dataSet = normalizeEodResponse(fetchResult.data, ticker)

    # Gap-fill missing days
    dataSet = gapFillDataSet(dataSet)

    # Mark if we got complete history (no errors during fetch)
    dataSet.meta.historyComplete = !fetchResult.error?

    log "Returning #{dataSet.data.length} data points, historyComplete: #{dataSet.meta.historyComplete}"
    return dataSet


############################################################
# Get history older than a given date (oldest available → olderThan-1day)
# Returns: DataSet or null
export getStockOlderHistory = (ticker, olderThan) ->
    log "getStockOlderHistory: #{ticker} olderThan=#{olderThan}"

    date_to = prevDay(olderThan)
    fetchResult = await fetchAllEodPages(ticker, { date_to })
    return null unless fetchResult?

    if fetchResult.error?
        err = fetchResult.error
        if isPlanLimitError(err) then log "Plan limit reached: #{err.code}"
        else log "API error: #{err.code}: #{err.message}"

    if fetchResult.data.length == 0
        log "No older data available"
        return null

    dataSet = normalizeEodResponse(fetchResult.data, ticker)
    dataSet = gapFillDataSet(dataSet)
    dataSet.meta.historyComplete = !fetchResult.error?

    log "Returning #{dataSet.data.length} older data points"
    return dataSet


############################################################
# Get history newer than a given date (newerThan+1day → today)
# Returns: DataSet or null
export getStockNewerHistory = (ticker, newerThan) ->
    log "getStockNewerHistory: #{ticker} newerThan=#{newerThan}"

    date_from = nextDay(newerThan)
    fetchResult = await fetchAllEodPages(ticker, { date_from })
    return null unless fetchResult?

    if fetchResult.error?
        err = fetchResult.error
        if isPlanLimitError(err) then log "Plan limit reached: #{err.code}"
        else log "API error: #{err.code}: #{err.message}"

    if fetchResult.data.length == 0
        log "No newer data available"
        return null

    dataSet = normalizeEodResponse(fetchResult.data, ticker)
    dataSet = gapFillDataSet(dataSet)

    log "Returning #{dataSet.data.length} newer data points"
    return dataSet


############################################################
# Fetch all EOD pages for a ticker (handles pagination)
# Optional dateOptions: { date_from, date_to } for bounded queries
fetchAllEodPages = (ticker, dateOptions = {}) ->
    log "fetchAllEodPages: #{ticker}"
    if apiBlocked then return null
    try
        apiBlocked = true

        allData = []
        offset = 0
        limit = 1000

        startMS = performance.now()
        counter = 0

        loop
            pageResult = await fetchEodPage(ticker, { offset, limit, ...dateOptions })
            counter++

            # Check for errors
            err = pageResult.error 
            if err? then return { error: err, data: allData }

            # Accumulate data
            allData.push(...pageResult.data)

            # Check if we have all data
            pagination = pageResult.pagination
            if allData.length >= pagination.total then return {data: allData}

            # Prepare next page
            offset += limit

            # check timing and wait if we run the risk of exceeding the rate-limit
            # the general rate limit is 5 API calls /s - check timing every 5th call
            # if we are below 1s wait until the second has ended - then reset.
            # This way we may run
            if counter % 5 == 0
                timeMS = performance.now() - startMS
                # make it 1001ms to combat if our clock is 1promille faster
                missingPeriodMS =  1001 - timeMS 
                if missingPeriodMS > 0 then await waitMS(missingPeriodMS)
                log "counter: #{counter} => missingPerdiodMS: #{missingPeriodMS}"
                startMS = performance.now()

    catch err then log err
    finally apiBlocked = false

############################################################
# Fetch single EOD page
# Optional date_from/date_to for bounded queries
fetchEodPage = (ticker, { offset, limit, date_from, date_to }) ->
    log "fetchEodPage: #{ticker} offset=#{offset}"

    # Normalize ticker (BRK.B → BRK-B)
    apiTicker = ticker.replace(/\./g, "-")

    params = new URLSearchParams({
        access_key: accessToken
        symbols: apiTicker
        sort: "ASC"  # Chronological order (oldest first)
        limit: limit.toString()
        offset: offset.toString()
    })
    if date_from? then params.set("date_from", date_from)
    if date_to? then params.set("date_to", date_to)

    url = "#{apiURL}/eod?#{params.toString()}"

    try
        response = await fetch(url)
    catch err
        log "Network error: #{err.message}"
        return { error: { code: "network_error", message: err.message } }

    try
        body = await response.json()

        if body.error?
            return { error: body.error }

        return { data: body.data, pagination: body.pagination }
    catch err
        log "Parse error: #{err.message}"
        return { error: { code: "parse_error", message: err.message } }


############################################################
# Normalize API response to DataSet format
# Input: array of EOD records from API
# Output: { meta: { startDate, endDate, interval }, data: [[h,l,c], ...] }
normalizeEodResponse = (apiData, ticker) ->
    log "normalizeEodResponse: #{apiData.length} records"

    if apiData.length == 0
        return null

    # API data is sorted ASC (oldest first) - verify and extract
    # Each record: { date, symbol, open, high, low, close, volume, exchange, price_currency }

    # Extract dates and price data
    dataPoints = []
    for record in apiData
        # Extract just the date part (YYYY-MM-DD) from potential ISO timestamp
        dateStr = record.date.substring(0, 10)
        dataPoints.push({
            date: dateStr
            high: record.high
            low: record.low
            close: record.close
        })

    # Build DataSet
    startDate = dataPoints[0].date
    endDate = dataPoints[dataPoints.length - 1].date

    # Convert to array format [high, low, close]
    data = dataPoints.map((p) -> [p.high, p.low, p.close])

    return {
        meta: { startDate, endDate, interval: "1d" }
        data: data
        # Keep raw dates for gap-filling (will be removed after)
        _dates: dataPoints.map((p) -> p.date)
    }


############################################################
# Fill gaps in data (missing trading days)
# Missing days get [lastClose, lastClose, lastClose]
gapFillDataSet = (dataSet) ->
    log "gapFillDataSet"

    if !dataSet? or dataSet.data.length == 0
        return dataSet

    { meta, data, _dates } = dataSet

    # Build date → dataPoint map
    dateMap = {}
    for i in [0..._dates.length]
        dateMap[_dates[i]] = data[i]

    # Generate all dates in range
    allDates = generateDateRange(meta.startDate, meta.endDate)

    # Fill gaps
    filledData = []
    lastClose = data[0][2]  # Initial close value

    for date in allDates
        if dateMap[date]?
            filledData.push(dateMap[date])
            lastClose = dateMap[date][2]
        else
            # Gap: use last close for all values
            filledData.push([lastClose, lastClose, lastClose])

    return {
        meta: meta
        data: filledData
    }


############################################################
# Check if error indicates plan limit restriction
isPlanLimitError = (error) ->
    # MarketStack returns specific error codes for plan limits
    # Common codes: "function_access_restricted", "https_access_restricted"
    planLimitCodes = ["function_access_restricted", "https_access_restricted", "usage_limit_reached"]
    return error.code in planLimitCodes

#endregion

############################################################
waitMS = (ms) -> new Promise((res) -> setTimeout(res, ms))

############################################################
#region deprecated code

############################################################
export executeSpecialMission = ->
    log "executeSpecialMission"
    # await storeRelevantSymbols()
    # await storeRelevantCurrencies()
    log "sepcialMission ended... bye!"
    return

############################################################
storeRelevantSymbols = ->
    log "storeRelevantSymbols"
    results = await getAllSymbols()
    # log "results retrieved: #{results.length}"
    # olog results[0]
    for tick in results when tick.has_eod then symbolsData.push(tick)
    dataString = JSON.stringify(symbolsData, null, 4)
    fs.writeFileSync(symbolsDataPath, dataString)
    return

storeRelevantCurrencies = ->
    log "storeRelevantCurrencies"
    results = await getAllCurrencies()
    log "results retrieved: #{results.length}"
    olog results[0]
    currenciesData.push(el) for el in results
    dataString = JSON.stringify(currenciesData, null, 4)
    fs.writeFileSync(currenciesDataPath, dataString)
    return


############################################################
getAllCurrencies = ->
    log "getAllCurrencies"
    access_key = accessToken
    limit = 1000
    offset = 0

    options = { access_key, limit, offset }
    params = new URLSearchParams(options)
    url = apiURL + "/currencies?" + params.toString()

    allData = []

    try response = await fetch(url)
    catch err then console.error(err)
    
    try
        if response.ok
            result = await response.json()
            if result.error? then throw new Error(result.error.code+": "+result.error.message)
            log "retrieved result!"
            olog result.pagination
            olog result.data[0]
            allData.push(...result.data)
       
            if result.pagination.limit != limit then console.error("Pagination Limit did not match our provided Limit! #{result.pagination.limit} vs #{limit}")
            if result.pagination.offset != offset then console.error("Pagination Offset did not match our offset! #{result.pagination.offset} vs #{offset}")
            return allData

        # log "Response was not OK :("+response.status+")"
        console.error("status: "+response.status)
        text = await response.text()
        console.error(text)
    catch err then console.error(err)
    return allData

############################################################
getAllSymbols = ->
    log "getAllSymbols"
    access_key = accessToken
    limit = 1000
    offset = 0

    options = { access_key, limit, offset }
    params = new URLSearchParams(options)
    url = apiURL + "/tickerslist?" + params.toString()

    allData = []

    dataOutstanding = true
    while(dataOutstanding)
        error = true
        log "requestion offset #{offset}"
        await waitMS(220)
        try response = await fetch(url)
        catch err then console.error(err)

        try
            # log "checking response"
            if response.ok
                result = await response.json()
                if result.error? then throw new Error(result.error.code+": "+result.error.message)
                # log "retrieved result!"
                # olog result.pagination
                # olog result.data[0]
                allData.push(...result.data)
                # log "allDataLength: #{allData.length}"

                if result.pagination.limit != limit then console.error("Pagination Limit did not match our provided Limit! #{result.pagination.limit} vs #{limit}")
                if result.pagination.offset != offset then console.error("Pagination Offset did not match our offset! #{result.pagination.offset} vs #{offset}")
                
                if result.pagination.total <= allData.length then dataOutstanding = false
                else # prepare next request url
                    offset += limit
                    options = { access_key, limit, offset }
                    params = new URLSearchParams(options)
                    url = apiURL + "/tickerslist?" + params.toString()
                
                error = false # all success full
                continue

            # log "Response was not OK :("+response.status+")"
            console.error("status: "+response.status)
            text = await response.text()
            console.error(text)
        catch err then console.error(err)
        if error then break

    return allData

#endregion