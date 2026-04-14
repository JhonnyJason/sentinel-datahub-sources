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

############################################################
import * as dataM from "./datamodule.js"
import * as liveFeed from "./livefeedmodule.js"
import { request } from "./marketstackrequest.js"

############################################################
export dataStructureVersion = 1

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
                # .map((symbol) -> symbol.replace(/\./g, "-"))
                .join(",")

            params = new URLSearchParams({
                access_key: accessToken
                symbols: apiSymbols
            })

            url = "#{apiURL}/intraday/latest?#{params.toString()}"
            body = await request(url)

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
# Get all available history for a ticker
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
export getStockNewerHistory = (ticker, newerThan, startFactor = 1.0, applied = true) ->
    log "getStockNewerHistory: #{ticker} newerThan:#{newerThan} startFactor:#{startFactor} applied:#{applied}"

    date_from = nextDay(newerThan)
    fetchResult = await fetchAllEodPages(ticker, { date_from })
    return null unless fetchResult?
    # olog fetchResult

    if fetchResult.error?
        err = fetchResult.error
        if isPlanLimitError(err) then log "Plan limit reached: #{err.code}"
        else log "API error: #{err.code}: #{err.message}"
        # Do something on error case?
        return null

    data  = fetchResult.data
    # olog data
    if !data or data.length == 0
        log "No newer data available"
        return null

    dataSet = normalizeEodResponse(data, ticker, startFactor, applied)
    dataSet = gapFillDataSet(dataSet)
    # olog dataSet

    log "Returning #{data.length} newer data points"
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
    # apiTicker = ticker.replace(/\./g, "-")
    apiTicker = ticker # Normalization only for intraday endpoint...

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
        body = await request(url)
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
normalizeEodResponse = (apiData, ticker, startFactor = 1.0, applied = true) ->
    log "normalizeEodResponse: #{apiData.length} records; startFactor:#{startFactor} applied:#{applied}"

    if apiData.length == 0
        return null

    # API data is sorted ASC (oldest first) - verify and extract
    # Each record: { date, symbol, open, high, low, close, volume, exchange, price_currency }

    # Extract dates and price data, track split factor history
    factor = startFactor
    dataPoints = []
    splitFactors = [ { f: factor, applied } ]
    prevRecord = null

    shouldApply = applied # set to initial apply state

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

            # Add new factor period
            factor *= record.split_factor
            splitFactors.push({f: factor, applied: shouldApply})

        if shouldApply # adjust to carry factor
            # log "shouldApply -> #{record.close} * #{factor} = #{record.close * factor}"
            high = record.high * factor
            low = record.low * factor
            close = record.close * factor
        else
            # log "no Application of factor!"
            high = record.high
            low = record.low
            close = record.close

        if close == 0 then close = fakeClose(high, low)

        dataPoints.push({ date, high, low, close })
        prevRecord = record

    # Build DataSet
    startDate = dataPoints[0].date
    endDate = dataPoints[dataPoints.length - 1].date
    version = dataStructureVersion

    # Convert to array format [high, low, close]
    data = dataPoints.map((p) -> [p.high, p.low, p.close])

    return {
        meta: { startDate, endDate, interval: "1d", splitFactors, version }
        data: data
        # Keep raw dates for gap-filling (will be removed after)
        _dates: dataPoints.map((p) -> p.date)
    }


############################################################
# Fill gaps in data (missing trading days)
# Missing days get [lastClose] (single element, distinguishable by length)
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
            # Gap: use last close as the one value
            filledData.push([lastClose])

    return {
        meta: meta
        data: filledData
    }


############################################################
# Sometimes the Close is 0, and usually we mostly value the close
# This is a data problem from Upstream
# Only reasonable workaroung is this "fakeClose" averaging the high and low
# + Resilience when either high or low is 0 as well
fakeClose = (high, low) ->
    log "fakeClose"
    sum = high + low
    div = 0

    if high > 0 then div++
    if low > 0 then div++

    return sum / div

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

