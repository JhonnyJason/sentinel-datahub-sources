############################################################
#region debug
import { createLogFunctions } from "thingy-debug"
{log, olog} = createLogFunctions("datamodule")
#endregion

############################################################
import * as mrktStack from "./marketstackmodule.js"
import * as store from "./storagemodule.js"
import * as symbols from "./symbolsmodule.js"
import { nextDay, daysBetween } from "./dateutilsmodule.js"

############################################################
# TODO: check if this is a good idea
toStorageId = (name) -> return "did:#{name.replace(".", "-")}"

############################################################
freshnessThreshold = 5

############################################################
export initialize = (cfg) ->
    log "initialize"
    if cfg.freshnessThreshold? then freshnessThreshold = cfg.freshnessThreshold

    return



############################################################
export executeSpecialMission = ->
    log "executeSpecialMission"
    # symbol = "TSM"
    # symbol = "ASML"
    # symbol = "MSFT"
    symbol = "AAPL"
    start = performance.now()
    result = await getData(symbol)
    log "full data retrieval took #{performance.now() - start}ms"

    length = result.data.length
    olog result.meta
    log length
    olog result.data[0]
    olog result.data[length - 1]
    return

############################################################
export getData = (name, yearsBack) ->
    log "getData #{name}, yearsBack: #{yearsBack}"
    if isCommodityName(name) then dataSet = getCommodityData(name)
    else if isForexPair(name) then dataSet = getForexPairData(name)
    else dataSet = await getStockData(name)

    return sliceByYears(dataSet, yearsBack)

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
        }
        data: dataSet.data.slice(sliceIndex)
    }

############################################################
isCommodityName = (name) ->
    log "isCommodityName"
    # return symbols.isCommodityName(name) # TODO: implement
    return false

isForexPair = (name) ->
    log "isForexPair"
    # return symbols.isForexPair(name) # TODO: implement
    return false

############################################################
getStockData = (symbol) ->
    log "getStockData #{symbol}"
    id = toStorageId(symbol)
    dataSet = store.load(id) # returns {} if no data exists

    # No data? -> fetch all history
    if !dataSet.data?
        dataSet = await mrktStack.getStockAllHistory(symbol)
        if dataSet? then store.save(id, dataSet)
        return dataSet

    # Is history incomplete? -> try to get older data
    if !dataSet.meta.historyComplete
        olderData = await mrktStack.getStockOlderHistory(symbol, dataSet.meta.startDate)
        if olderData?
            dataSet = prependDataSet(olderData, dataSet)
            store.save(id, dataSet)

    # Is data fresh enough? -> top-up with newer data
    if !isFresh(dataSet)
        newerData = await mrktStack.getStockNewerHistory(symbol, dataSet.meta.endDate)
        if newerData?
            dataSet = appendDataSet(dataSet, newerData)
            store.save(id, dataSet)

    return dataSet

############################################################
isFresh = (dataSet) ->
    if !dataSet?.meta?.endDate? then return false
    endDate = new Date(dataSet.meta.endDate + "T00:00:00Z")
    now = new Date()
    daysDiff = Math.floor((now - endDate) / (1000 * 60 * 60 * 24))
    return daysDiff <= freshnessThreshold

############################################################
# Prepend older data to existing dataset (with gap detection/fill)
prependDataSet = (older, existing) ->
    gapFill = []
    expectedNext = nextDay(older.meta.endDate)
    gapSize = daysBetween(expectedNext, existing.meta.startDate) # should be 0 

    if gapSize > 0
        log "WARNING: gap detected between #{older.meta.endDate} and #{existing.meta.startDate}"
        lastClose = older.data[older.data.length - 1][2]
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
        lastClose = existing.data[existing.data.length - 1][2]
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
        }
        data: [...existing.data, ...gapFill, ...newer.data]
    }

############################################################
# Generate gap-fill array with latest closeValue
fillGap = (gapSize, closeValue) -> Array(gapSize).fill([closeValue, closeValue, closeValue])

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


