############################################################
#region debug
import { createLogFunctions } from "thingy-debug"
{log, olog} = createLogFunctions("marketstackmodule")
#endregion

############################################################
import fs from "node:fs"
import path from "node:path"
import { nextDay, prevDay, generateDateRange, isTradingHour,
    isPreTradingHour, isPostTradingHour, isTradingDay } from "./dateutilsmodule.js"

import * as dataM from "./datamodule.js"
import * as liveFeed from "./livefeedmodule.js"


############################################################
accessToken = null
apiURL = null


############################################################
symbolsDataPath = path.resolve(".", "symbols.json")
currenciesDataPath = path.resolve(".", "currencies.json")
symbolsData = []
currenciesData = []

############################################################
liveDataSymbols = []
liveDataHeartbeatMS = 300_000 # 5min non-pro subscribtions cannot be faster
liveDataEODRefreshMS = 3_600_000 # 1h probably enough

############################################################
# EOD refresh limiter — shared across pre-trading and trading hours
# max attempts per day to avoid wasting API calls on holidays
eodRefreshMaxAttempts = 3 #{}
eodRefreshAttempts = 0
eodLastRefreshDate = null
postTradeRefresh = false
preTradeRefresh = false

############################################################
export initialize = (c) ->
    log "initialize"
    if c.mrktStackSecret? then accessToken = c.mrktStackSecret
    if c.urlMrktStack? then apiURL = c.urlMrktStack
    if c.liveDataSymbols? then liveDataSymbols.push(...c.liveDataSymbols)
    if c.liveDataHeartbeatMS? then liveDataHeartbeatMS = c.liveDataHeartbeatMS
    if c.liveDataEODRefreshMS? then liveDataEODRefreshMS = c.liveDataEODRefreshMS
    if c.eodRefreshMaxAttempts? then eodRefreshMaxAttempts = c.eodRefreshMaxAttempts
    return
    
############################################################
#region "live" data retrieval
liveDataHeartbeat = ->
    log "realTimeHeartbeat"
    dateNow = new Date()
    return unless isTradingDay(dateNow)
    log "Today is a trading-day - let's see what's up..."

    if  isTradingHour(dateNow)
        log "isTradingHour: true"        
        # Live intraday prices
        return unless accessToken? and apiURL?
        return if liveDataSymbols.length == 0

        try
            apiSymbols = liveDataSymbols
                .map((symbol) -> symbol.replace(/\./g, "-"))
                .join(",")

            params = new URLSearchParams({
                access_key: accessToken
                symbols: apiSymbols
            })

            url = "#{apiURL}/intraday/latest?#{params.toString()}"
            body = await requestQueue(url)

            if body.error?
                log "liveData API error: #{body.error.code}: #{body.error.message}"
                return

            latestPrices = Object.create(null)
            for row in (body.data ? [])
                continue unless row.symbol?
                symbol = row.symbol.replace(/-/g, ".")
                latestPrices[symbol] = row.last ? row.lastPrice ? row.close

            try liveFeed.updatePrices(latestPrices)
            catch err then log "error in liveFeed.updatePrices! #{err.message}"

        catch err then log "liveData retrieval error: #{err.message}"

    else log "It's not an interesting time - we do nothing here :-)"
    return


############################################################
liveDataEODRefresh = ->
    dateNow = new Date()
    todayStr = dateNow.toISOString().substring(0, 10)
    tradingDay = isTradingDay(dateNow)
    
    includeToday = tradingDay and isPostTradingHour(dateNow)

    #region additional Refresh
    if tradingDay and isTradingHour(dateNow) # assure that reset states are cleared
        postTradeRefresh = false
        preTradeRefresh = false
    
    else if tradingDay and isPreTradingHour(dateNow) # preTrading Refresh
        postTradeRefresh = false

        if !preTradeRefresh and eodRefreshAttempts == eodRefreshMaxAttempts
            preTradeRefresh = true
            eodRefreshAttempts = eodRefreshMaxAttempts - 1

    else if tradingDay and isPostTradingHour(dateNow) # postTrading Refresh
        preTradeRefresh = false

        if !postTradeRefresh # only once
            postTradeRefresh = true
            eodRefreshAttempts = 0

    #endregion
        

    if eodLastRefreshDate != todayStr # start new attempts on new day
        eodLastRefreshDate = todayStr
        eodRefreshAttempts = 0
    
    if eodRefreshAttempts >= eodRefreshMaxAttempts # maxxed out
        log "EOD refresh attempt limit reached (#{eodRefreshMaxAttempts}) - skipping"
        return

    eodRefreshAttempts++
    log "EOD top-up attempt #{eodRefreshAttempts}/#{eodRefreshMaxAttempts}"
    
    # Force Refresh for all our liveData Symbols
    for symbol in liveDataSymbols
        dataM.forceLoadNewestStockData(symbol, includeToday)
    return



############################################################
export startLiveDataHeartbeat = ->
    log "startLiveDataHeartbeat"
    # for live data retrieval
    liveDataHeartbeat()
    setInterval(liveDataHeartbeat, liveDataHeartbeatMS)

    # best Effort keeping EOD data up to date :-)
    liveDataEODRefresh()
    setInterval(liveDataEODRefresh, liveDataEODRefreshMS)
    return

#endregion


############################################################
#region Stock EOD API - Pull Model

############################################################
# Main export: Get all available history for a ticker
# Returns: DataSet with meta.historyComplete flag, or null on error/no data
export getStockAllHistory = (ticker) ->
    log "getStockAllHistory: #{ticker}"

    fetchResult = await fetchAllEodPages(ticker)
    return null unless fetchResult?

    if fetchResult.error?
        err = fetchResult.error
        if isPlanLimitError(err) then log "Plan limit reached: #{err.code}"
        else log "API error: #{err.code}: #{err.message}"

    if fetchResult.data.length == 0
        log "No data received"
        return null

    dataSet = normalizeEodResponse(fetchResult.data, ticker)
    dataSet = gapFillDataSet(dataSet)
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
export getStockNewerHistory = (ticker, newerThan, startFactor = 1.0) ->
    log "getStockNewerHistory: #{ticker} newerThan=#{newerThan} startFactor=#{startFactor}"

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

    dataSet = normalizeEodResponse(fetchResult.data, ticker, startFactor)
    dataSet = gapFillDataSet(dataSet)

    log "Returning #{dataSet.data.length} newer data points"
    return dataSet


############################################################
# Fetch all EOD pages for a ticker (handles pagination)
# Optional dateOptions: { date_from, date_to } for bounded queries
fetchAllEodPages = (ticker, dateOptions = {}) ->
    log "fetchAllEodPages: #{ticker}"
    allData = []
    offset = 0
    limit = 1000

    try
        loop
            pageResult = await fetchEodPage(ticker, { offset, limit, ...dateOptions })

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

    catch err then log err

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
        body = await requestQueue(url)
    catch err
        log "Network/parse error: #{err.message}"
        return { error: { code: "network_error", message: err.message } }

    if body.error?
        return { error: body.error }

    return { data: body.data, pagination: body.pagination }


############################################################
# Normalize API response to DataSet format
# Input: array of EOD records from API
# Output: { meta: { startDate, endDate, interval }, data: [[h,l,c], ...] }
normalizeEodResponse = (apiData, ticker, startFactor = 1.0) ->
    log "normalizeEodResponse: #{apiData.length} records, startFactor=#{startFactor}"

    if apiData.length == 0
        return null

    # API data is sorted ASC (oldest first) - verify and extract
    # Each record: { date, symbol, open, high, low, close, volume, exchange, price_currency }

    # Extract dates and price data, track split factor history
    factor = startFactor
    dataPoints = []
    splitFactors = [ { f: factor, applied: true } ] # is applied: true always good here?
    prevRecord = null

    shouldApply = false

    for record,i in apiData
        date = record.date.substring(0, 10)

        if record.split_factor? and record.split_factor != 1 and prevRecord?
            # Detect if raw data is already split-adjusted
            # Use adj_close ratio to isolate the real price change,
            # then check if closeRaw moved similarly (pre-adjusted)
            # or jumped by ~split_factor (needs adjustment)
            adjChange = record.adj_close / prevRecord.adj_close
            rawChange = record.close / prevRecord.close
            newFactor = record.split_factor

            # should be true only if we are adjusted already
            rawChangeLikelyAdj = likelyAdjusted(rawChange, newFactor)  
            # # might be false if we have a data bug
            adjChangeLikelyAdj = likelyAdjusted(adjChange, newFactor)
            # # If we are in sync with the data 
            # likelyAdjusted = Math.abs(rawChange - adjChange) < 0.01
            
            # only if all indications point to likely adjusted data we set isPreAdjusted to true
            # isPreAdjusted = likelyAdjusted and rawChangeLikelyAdj and adjChangeLikelyAdj
            
            # Only go with the most reiable indication :)
            isPreAdjusted = rawChangeLikelyAdj

            # Factor was Applied 
            shouldApply = shouldApply or !isPreAdjusted
            
            # confirm if split-factor fits
            splitFactorFits = Math.abs(rawChange*record.split_factor - adjChange) < 0.01
            if(!isPreAdjusted and !splitFactorFits) then log "We were not within the range to detect preAdjusted data. Neither was the split-factor making this difference! (adjChangeLikelyAdj: #{adjChangeLikelyAdj})"

            # set endDate to previous factor
            prevSplit = splitFactors[splitFactors.length - 1]
            if prevSplit? then prevSplit.end = prevDay(date)

            closeRM2 = apiData[i-2]?.close
            adjCloseRM2 = apiData[i-2]?.adj_close
            closeRM1 = prevRecord.close
            adjCloseRM1 = prevRecord.adj_close
            closeRN =  record.close
            adjCloseRN =  record.adj_close
            closeRP1 = apiData[i+1]?.close
            adjCloseRP1 = apiData[i+1]?.adj_close
            closeRP2 = apiData[i+2]?.close
            adjCloseRP2 = apiData[i+2]?.adj_close

            olog { 
                factor, 
                split_factor: record.split_factor 
                rawChange, 
                adjChange, 
                absDelta: Math.abs(rawChange - adjChange), 
                isPreAdjusted,
                shouldApply,
                closeRM2,
                adjCloseRM2,
                adjCloseRM1,
                closeRN,
                adjCloseRN,
                closeRP1,
                adjCloseRP1,
                closeRP2
                adjCloseRP2
            }
            
            
            # Add new factor period
            factor *= record.split_factor
            splitFactors.push({f: factor, applied: shouldApply})

        if shouldApply # adjust to carry factor
            high = record.high * factor
            low = record.low * factor
            close = record.close * factor
        else
            high = record.high
            low = record.low
            close = record.close

        dataPoints.push({ date, high, low, close })
        prevRecord = record

    # Build DataSet
    startDate = dataPoints[0].date
    endDate = dataPoints[dataPoints.length - 1].date

    # Convert to array format [high, low, close]
    data = dataPoints.map((p) -> [p.high, p.low, p.close])

    return {
        meta: { startDate, endDate, interval: "1d", splitFactors }
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

############################################################
# check if a price change around a split is likely adjusted/natural
likelyAdjusted = (change, factor) ->
    # if factor fits the change then the corrected should be ~1 (non-adjusted)
    # if it was already adjusted (~1) then the corrected should be ~factor
    corrected = change * factor

    deltaOne = Math.abs(corrected - 1)
    deltaFactor = Math.abs(corrected - factor)

    # if the corrected value is closer to the factor than to 1 it is likely adjusted already
    return deltaFactor < deltaOne

#endregion

############################################################
#region Throttled Request Queue
# MarketStack rate limit: 5 requests/second
# Strategy: allow bursts of 5, only wait if the burst was faster than 1s
# Deduplication: identical URLs are coalesced — fetched once, result shared

queue = []
pending = new Map()  # url → [{resolve, reject}, ...]
processing = false
windowStart = 0
windowCount = 0
maxPerWindow = 5
windowMS = 1001  # 1s + 1ms safety margin

requestQueue = (url) ->
    new Promise (resolve, reject) ->
        if pending.has(url)
            pending.get(url).push({ resolve, reject })
            return
        pending.set(url, [{ resolve, reject }])
        queue.push(url)
        processQueue() unless processing

processQueue = ->
    return if processing or queue.length == 0
    processing = true

    while queue.length > 0
        # Start new measurement window
        if windowCount == 0
            windowStart = performance.now()

        windowCount++
        url = queue.shift()
        waiters = pending.get(url)

        try
            response = await fetch(url)
            unless response.ok
                text = await response.text()
                throw new Error("HTTP #{response.status}: #{text.slice(0, 200)}")
            body = await response.json()
            pending.delete(url)
            w.resolve(body) for w in waiters
        catch err
            pending.delete(url)
            w.reject(err) for w in waiters

        # After 5 requests, check if we need to slow down
        if windowCount >= maxPerWindow
            elapsed = performance.now() - windowStart
            remaining = windowMS - elapsed
            if remaining > 0 then await waitMS(remaining)
            windowCount = 0

    processing = false
    return

#endregion

############################################################
waitMS = (ms) -> new Promise((res) -> setTimeout(res, ms))
