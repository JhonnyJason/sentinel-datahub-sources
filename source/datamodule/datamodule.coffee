############################################################
#region debug
import { createLogFunctions } from "thingy-debug"
{log, olog} = createLogFunctions("datamodule")
#endregion

############################################################
import * as bs from "./bugsnitch.js"

############################################################
import * as mrktStack from "./marketstackmodule.js"
import * as store from "./storagemodule.js"
import * as symbols from "./symbolsmodule.js"
import { nextDay, daysBetween, lastTradingDay } from "./dateutilsmodule.js"

############################################################
# TODO: check if this is a good idea
toStorageId = (name) -> return "did:#{name.replace(".", "-")}"

############################################################
freshnessThreshold = 5

############################################################
export initialize = (c) ->
    log "initialize"
    if c.freshnessThreshold? then freshnessThreshold = c.freshnessThreshold    
    return

############################################################
#region Local Functions

############################################################
weSplitInLastXDays = (splits, cnt) ->
    # no split happened
    if splits.length < 2 then return false

    # we had a split before
    current = splits[splits.length - 1]
    splitBefore = splits[splits.length - 2]

    # check if that happened wihin the range of the last cnt days
    checkStartDate = new Date()
    checkStartDate.setDate(checkStartDate.getDate() - cnt)
    # YYYYMMDD is actually YYYY-MM-DD -> 10 chars
    checkYYYYMMDD = checkStartDate.toISOString().slice(0, 10)
    # end date is already in format YYYY-MM-DD
    return splitBefore.end > checkYYYYMMDD 


############################################################
correctZeroAndNullValues = (dataSet) ->
    log "correctZeroValues"
    corrected = false


    for dP,i in dataSet.data

        if i > 0 then prDP = dataSet.data[i - 1]
        else prDP = null
        if prDP? then prevClose = prDP[prDP.length - 1]
        else prevClose = null

        # Fix null
        if !dP? and prevClose?
            dataSet.data[i] = [prevClose]
            corrected = true
            continue
        if !dP? and !prevClose? 
            bs.report("@correctZeroAndNullValues: null datapoint impossible to fix here!")
            continue

        # Fix C=0
        close = dP[dP.length - 1]
        
        if close == 0 or (typeof close != "number") or isNaN(close)
            corrected = true
            # regular close is 0 get fake Close from High and Low
            if dP.length == 3 then dP[2] = fakeClose(dP[0], dP[1])
            # non-trading Day close is 0 get close from prev datapoint
            if dP.length == 1 and prevClose? then dP[0] = prevClose
            if dP.length == 1 and (!prevClose? or  prevClose == 0)
                bs.report("@correctZeroAndNullValues: 0 close impossible to fix here 1!")
                continue
            # high, low and close being 0 - so also fakeClose resulted in 0 
            # -> turn to non-trading day and use close from prev datapoint
            if dP.length == 3 and dP[2] == 0 and prevClose?
                dP.length = 1
                dP[0] = prevClose
                continue
            # high, low and close being 0 - so also fakeClose resulted in 0 
            # also prev datapoint cannot help us out...
            if (dP.length == 3 and dP[2] == 0) and (!prevClose? or  prevClose == 0)
                bs.report("@correctZeroAndNullValues: 0 close impossible to fix here 2!")
                continue
        
    return corrected

############################################################
smoothenData = (dataSet) ->
    log "smoothenData"
    # first always correct Zero values!
    corrected = correctZeroAndNullValues(dataSet)

    splits = dataSet.meta.splitFactors
    return corrected unless splits.length > 0

    daysBack = Math.min(60, dataSet.data.length - 1)
    return corrected unless daysBack > 0

    lastSplit = splits[splits.length - 1]
    f = lastSplit.f
    if typeof f != "number" or isNaN(f) then f = 1
    if f == 1 then return corrected

    ## We need to adjust logic in the special case having had a split just within the last 60 days...
    weSplit = weSplitInLastXDays(splits, daysBack)
    if weSplit then bs.report("@smoothenData: we had a split within the last 60 days! We donot handle this case yet!")

    # now we want to check if any of the new values were not adjusted for the split factor
    # therefore we start from the oldest relevant to the newest datapoint
    # we assume that the 60 days old datapoints are adjusted 
    # only the most recent ones might not be adjusted
    for i in [daysBack..1] # range: daysBack to 1 
        # log "checking index #{i}..."
        dP = dataSet.data[dataSet.data.length - i]
        prDP = dataSet.data[dataSet.data.length - (i + 1)]
        
        # log dP # check dataPoint
        # log prDP # check previousDataPoint
        close = dP[dP.length - 1]
        prevClose = prDP[prDP.length - 1]

        if typeof close != "number" or isNaN(close) then close = 0
        if typeof prevClose != "number" or isNaN(prevClose) then prevClose = 0

        # price difference between corrected current and previous price
        deltaCorrected = Math.abs((close * f) - prevClose) 
        # price difference between current and previous price
        deltaCurrent = Math.abs(close - prevClose) 

        # if the corrected dP was closer to the previous price than the current dP
        # then probably the split factor was missing and we should correct it 
        if deltaCorrected < deltaCurrent 
            # correct all values for the dataPoint
            ( dP[j] = val * f ) for val,j in dP
            corrected = true # we still have to correct all newer dataPoints
            
        # log dP

    # corrected is only false if there was no single dataPoint to be corrected
    return corrected

############################################################
fakeClose = (high, low) ->
    log "fakeClose"
    if typeof high != "number" or isNaN(high) then high = 0
    if typeof low != "number" or isNaN(low) then low = 0

    sum = high + low
    div = 0

    if high > 0 then div++
    if low > 0 then div++
    if div == 0 then return 0

    return sum / div


############################################################
#region Helper Functions
isCommodityName = (name) ->
    log "isCommodityName"
    # return symbols.isCommodityName(name) # TODO: implement
    return false

isForexPair = (name) ->
    log "isForexPair"
    # return symbols.isForexPair(name) # TODO: implement
    return false

############################################################
isFresh = (dataSet, threshold) ->
    if !dataSet?.meta?.endDate? then return false
    endDate = new Date(dataSet.meta.endDate + "T00:00:00Z")
    now = new Date()
    daysDiff = Math.floor((now - endDate) / (1000 * 60 * 60 * 24))
    return daysDiff <= threshold


############################################################
# Get the current cumulative split factor from a DataSet
getCumulativeFactor = (dataSet) ->
    sf = dataSet.meta?.splitFactors
    return 1.0 unless sf? and sf.length > 0
    last = sf[sf.length - 1]
    return 1.0 if last.applied == false # pre-adjusted data: source handles splits
    return last.f

getSplitFactorState = (dataSet) ->
    factor = 1.0
    applied = true

    sf = dataSet.meta?.splitFactors
    if !sf? or sf.length == 0 then return { factor, applied }

    last = sf[sf.length - 1]
    factor = last.f
    applied = last.applied
    return { factor, applied }
    
############################################################
# Merge split factor arrays on append (existing + newer)
mergeSplitFactors = (existingFactors, newerFactors) ->
    return newerFactors unless existingFactors?
    return existingFactors unless newerFactors?
    return [...existingFactors.slice(0, -1), ...newerFactors]

############################################################
# Prepend older data to existing dataset (with gap detection/fill)
prependDataSet = (older, existing) ->
    gapFill = []
    expectedNext = nextDay(older.meta.endDate)
    gapSize = daysBetween(expectedNext, existing.meta.startDate) # should be 0 

    if gapSize > 0
        log "WARNING: gap detected between #{older.meta.endDate} and #{existing.meta.startDate}"
        lastDP = older.data[older.data.length - 1]
        lastClose = lastDP[lastDP.length - 1]
        gapFill = fillGap(gapSize, lastClose)
    if gapSize < 0 
        log "WARNING: gap was negative! This should NEVER happen!"
        # cut down older data as they are likely the smaller array
        older.data = older.data.slice(0, gapSize) 

    return {
        meta: {
            startDate: older.meta.startDate
            endDate: existing.meta.endDate
            interval: existing.meta.interval
            historyComplete: older.meta.historyComplete
            splitFactors: mergeSplitFactors(older.meta.splitFactors, existing.meta.splitFactors)
            version: older.meta.version
        }
        data: [...older.data, ...gapFill, ...existing.data]
    }

############################################################
# Append newer data to existing dataset (with gap detection/fill)
appendDataSet = (existing, newer) ->
    gapFill = []
    expectedNext = nextDay(existing.meta.endDate)
    gapSize = daysBetween(expectedNext, newer.meta.startDate) # should be 0
        
    if gapSize > 0
        log "WARNING: gap detected between #{existing.meta.endDate} and #{newer.meta.startDate}"
        lastDP = existing.data[existing.data.length - 1]
        lastClose = lastDP[lastDP.length - 1]
        gapFill = fillGap(gapSize, lastClose)
    if gapSize < 0 
        log "WARNING: gap was negative! This should NEVER happen!"
        # cut out from newer data as they are likely the smaller array
        newer.data = newer.data.slice((Math.abs(gapSize)))

    return {
        meta: {
            startDate: existing.meta.startDate
            endDate: newer.meta.endDate
            interval: existing.meta.interval
            historyComplete: existing.meta.historyComplete
            splitFactors: mergeSplitFactors(existing.meta.splitFactors, newer.meta.splitFactors)
            version: newer.meta.version
        }
        data: [...existing.data, ...gapFill, ...newer.data]
    }

############################################################
# Generate gap-fill array with latest closeValue
fillGap = (gapSize, closeValue) -> Array(gapSize).fill([closeValue])

############################################################
sliceByYears = (dataSet, yearsBack) ->
    return dataSet unless yearsBack? and dataSet?.data?

    # Calculate cutoff date (yearsBack years ago from today)
    now = new Date()
    cutoffDate = new Date(Date.UTC(now.getUTCFullYear() - yearsBack, now.getUTCMonth(), now.getUTCDate()))
    startDate = new Date(dataSet.meta.startDate + "T00:00:00Z")

    # If cutoff is before our data starts, return full dataset
    return dataSet if cutoffDate <= startDate

    # Calculate index to slice from
    sliceIndex = daysBetween(dataSet.meta.startDate, cutoffDate.toISOString().slice(0, 10))
    return dataSet if sliceIndex <= 0

    # Slice and return new dataset
    return {
        meta: {
            startDate: cutoffDate.toISOString().slice(0, 10)
            endDate: dataSet.meta.endDate
            interval: dataSet.meta.interval
            historyComplete: false  # sliced data is not complete
            splitFactors: dataSet.meta.splitFactors
            version: dataSet.meta.version
        }
        data: dataSet.data.slice(sliceIndex)
    }

#endregion

############################################################
getStockData = (symbol) ->
    console.log "getStockData #{symbol}"
    log "getStockData #{symbol}"
    id = toStorageId(symbol)
    dataSet = store.load(id) # returns {} if no data exists

    # No data? -> fetch all history
    if !dataSet.data?
        console.log("We donot have a dataset for #{symbol}")
        dataSet = await mrktStack.getStockAllHistory(symbol)
        if dataSet? then store.save(id, dataSet)
        return dataSet

    # Legacy data? -> full re-fetch with proper normalization
    unless dataSet.meta?.version  >= mrktStack.dataStructureVersion
        console.log "Legacy data detected for #{symbol} — recorrecting"
        log "Legacy data detected for #{symbol} — recorrecting"
        return recorrectData(symbol)

    # Is history incomplete? -> try to get older data
    ## TODO remove historyComplete flag as it is not reliably identifiable
    if !dataSet.meta.historyComplete
        log "incomplete History -> get older Data"
        olderData = await mrktStack.getStockOlderHistory(symbol, dataSet.meta.startDate)
        if olderData?
            dataSet = prependDataSet(olderData, dataSet)
            store.save(id, dataSet)

    # Is data fresh enough? -> top-up with newer data
    if !isFresh(dataSet, freshnessThreshold)
        log "data not Fresh -> get newer Data"
        { factor, applied } = getSplitFactorState(dataSet)
        olog { factor, applied }
        newerData = await mrktStack.getStockNewerHistory(symbol, dataSet.meta.endDate, factor, applied)
        # olog newerData
        if newerData?
            dataSet = appendDataSet(dataSet, newerData)
            store.save(id, dataSet)

    ## TODO remove after we finished allData Updates
    try
        wasDamaged = smoothenData(dataSet)
        console.log("#{symbol} was damaged: #{wasDamaged}")
        if wasDamaged then store.save(id, dataSet)
    catch err
        bs.report("@getStockData #{err.message}")
        dataSet = await mrktStack.getStockAllHistory(symbol)
        if dataSet? then store.save(id, dataSet)
        return dataSet

    return dataSet

############################################################
getCommodityData = (name) ->
    log "getCommodityData"
    id = toStorageId(name)
    return store.load(id)

############################################################
getForexPairData = (name) ->
    log "getForexPairData"
    id = toStorageId(name)
    # dataSet = store.load(id)
    ## TODO implement
    return {}

#endregion

############################################################
#region Exported functions

############################################################
# Re-fetch and re-normalize all data for a symbol
# Fixes legacy data without splitFactors and any accumulated factor errors
export recorrectData = (symbol) ->
    log "recorrectData #{symbol}"
    id = toStorageId(symbol)
    dataSet = await mrktStack.getStockAllHistory(symbol)
    if dataSet?
        store.save(id, dataSet)
        log "recorrectData complete: #{dataSet.data.length} points, splitFactors: #{JSON.stringify(dataSet.meta.splitFactors)}"
    else
        log "recorrectData failed: no data returned"
    return dataSet

############################################################
export forceLoadNewestStockData = (symbol, includeToday = false) ->
    id = toStorageId(symbol)
    dataSet = store.load(id) # returns {} if no data exists

    # No data? -> fetch all history
    if !dataSet.data?
        dataSet = await mrktStack.getStockAllHistory(symbol)
        if dataSet? then store.save(id, dataSet)
        return dataSet

    # Outdated data structure version? -> full re-fetch with proper normalization
    unless dataSet.meta?.version >= mrktStack.dataStructureVersion
        log "Legacy data detected for #{symbol} — recorrecting"
        await recorrectData(symbol)
        return

    # includeToday: after market close, today's EOD data is available
    # pre-trading: today's data doesn't exist yet, compare against yesterday
    now = new Date()
    if includeToday
        expectedEnd = lastTradingDay(now)
    else
        yesterday = new Date(Date.UTC(now.getUTCFullYear(), now.getUTCMonth(), now.getUTCDate() - 1))
        expectedEnd = lastTradingDay(yesterday)

    if dataSet.meta.endDate < expectedEnd
        # cf = getCumulativeFactor(dataSet)
        { factor, applied } =  getSplitFactorState(dataSet)
        newerData = await mrktStack.getStockNewerHistory(symbol, dataSet.meta.endDate, factor, applied)
        if newerData?
            dataSet = appendDataSet(dataSet, newerData)
            store.save(id, dataSet)

    if dataSet.meta.endDate >= expectedEnd
        log "Data is up to date (ends: #{dataSet.meta.endDate}, expected: #{expectedEnd})"
    else
        log "Data still behind expected (ends: #{dataSet.meta.endDate}, expected: #{expectedEnd})"
    return

############################################################
export getData = (name, yearsBack) ->
    log "getData #{name}, yearsBack: #{yearsBack}"
    if isCommodityName(name) then dataSet = getCommodityData(name)
    else if isForexPair(name) then dataSet = getForexPairData(name)
    else dataSet = await getStockData(name)

    return sliceByYears(dataSet, yearsBack)

#endregion
