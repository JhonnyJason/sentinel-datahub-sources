############################################################
#region debug
import { createLogFunctions } from "thingy-debug"
{log, olog} = createLogFunctions("commoditydatamodule")
#endregion

############################################################
import * as store from "./storagemodule.js"
import * as bs from "./bugsnitch.js"

############################################################
import { request } from "./marketstackrequest.js"

############################################################
import * as dateUtl from "./dateutilsmodule.js"
import * as idUtl from "./idutils.js"

############################################################
accessKey = ""
baseURL = ""

############################################################
commoditySymbols = []

############################################################
heartbeatMS = 144_000_000 # ~40h

############################################################
thresholdDays = 6
thresholdMS = 86_400_000 * thresholdDays

############################################################
maxYearsBack = 15

############################################################
waitMS = (ms) -> new Promise((res) -> setTimeout(res, ms))


############################################################
export initialize = (c) ->
    log "initialize"
    if c.mrktStackSecret? then accessKey = c.mrktStackSecret
    if c.commoditySymbols? then commoditySymbols = [...c.commoditySymbols]
    if c.checkCommoditiesMS? then heartbeatMS = c.checkCommoditiesMS
    if c.urlMrktStack? then baseURL = c.urlMrktStack
    return

############################################################
export startCommodityDataHeartbeat = ->
    log "startForexDataHeartbeat"
    setInterval(heartbeat, heartbeatMS)
    heartbeat() ## just for testing... no need to start it immediately
    return

############################################################
heartbeat = ->
    log "heartbeat"
    for symbol in commoditySymbols
        try await ensureSymbolIsUpToDate(symbol)
        catch err then bs.report("@commoditydatamodule.heartbeat: ensureSymbolIsUpToDate(#{symbol}) failed: #{err.messsage}")
        return
        await waitMS(12000)

    return


############################################################
retrieveAllHistory = (symbol) ->
    log "retrieveAllHistory"
    today = new Date()

    startDate = new Date(today)
    startDate.setFullYear(today.getFullYear() - maxYearsBack)
    
    endDate = new Date(startDate)
    endDate.setFullYear(startDate.getFullYear() + 1)

    dateToPrice = Object.create(null)

    metaData = Object.create(null)
    data = []

    while endDate.getTime() <= today.getTime()
        url = getPriceQueryURL(symbol, startDate, endDate)
        log url
        ## TODO send request toget Data
        response = await request(url)
        if !response.data? or !response.data[0]? or !response.data[0].commodity_prices?
            throw new Error("Could not retrieve data for #{symbol} from: #{startDate.toISOString().slice(0,10)} to: #{endDate.toISOString().slice(0, 10)}")
        # olog response.data
        return
        prices = response.data[0].commodity_prices
        for price in prices
            dateToPrice[price.date] = price.commodity_price
        
        startDate = endDate
        endDate = new Date(startDate)
        endDate.setFullYear(startDate.getFullYear() + 1)

    ## TODO test... (requires professional marketstack subscription)

    dates = Object.keys(dateToPrice)
    dates.sort() ##  should sort ascending so dates[0] should be earliest date
    metaData.startDate = dates[0]
    metaData.endDate = dates[dates.length - 1]
    metaData.interval = "1d"
    metaData.splitFactors = [{f:1, applied:true}]
    metaData.version = 1
    metaData.historyComplete = true

    date = date[0]
    lastPrice = dateToPrice[date]
    if !lastPrice? then throw new Error("commodityDatamodule.retrieveAllHistory: retrieved StartDate did not have a price!")

    while date <= metaData.endDate
        price = dateToPrice[date]
        if !price? then price = lastPrice
        else lastPrice = price
        data.push(price)
        date = dateUtl.nextDay(date)

    log "finished retrieveing all History..."
    return { metaData, data }

addNewHistory = (symbol, storeObj) ->
    log "addNewHistory"
    dateToPrice = Object.create(null)
    
    missingDates = getMissingDates(storeObj.metaData.endDate)

    startDate = missingDates[0]
    endDate = missingDates[missingDates.length  - 1]

    url = getPriceQueryURL(symbol, startDate, endDate)
    log url
    
    response = await request(url)
    if !response.data? or !response.data[0]? or !response.data[0].commodity_prices?
        throw new Error("Could not retrieve data for #{symbol} from: #{startDate.toISOString().slice(0,10)} to: #{endDate.toISOString().slice(0, 10)}")
    
    olog response.data
    ## TODO test... (requires professional marketstack subscription)
    prices = response.data[0].commodity_prices
    for price in prices
        dateToPrice[price.date] = price.commodity_price
        
    lastPrice = storeObj.data[storeObj.data.length - 1]
    for date in missingDates
        price = dateToPrice[date]
        if !price? then price = lastPrice
        else lastPrice = price
        storeObj.data.push([price])

    storeObj.metaData.endDate = endDate

    return storeObj

############################################################
getMissingDates = (lastDate) ->
    dayMS = 86_400_000
    endMS = (new Date((new Date()).toISOString().slice(0,10))).getTime()
    dateMS = (new Date(lastDate)).getTime() + dayMS
    dates = []
    while dateMS < endMS
        dates.push((new Date(dateMS)).toISOString().slice(0, 10))
        dateMS += dayMS
    return dates

############################################################
isRecent = (date) ->
    date = new Date(date)
    today = new Date()
    deltaMS = today.getTime() - date.getTime()

    return deltaMS < thresholdMS


############################################################
ensureSymbolIsUpToDate = (symbol) ->
    log "ensureSymbolIsUpToDate"
    id = idUtl.idForCommodity(symbol)
    storeObj = store.load(id)
    
    if !storeObj? or !storeObj.metaData? or !storeObj.metaData.endDate?
        log "Yet, no history available for #{symbol}"
        try storeObj = await retrieveAllHistory(symbol)
        catch err
            bs.report("@ensureSymbolIsUpToDate(#{symbol}) no History for and failed to retrieveAllHistory! #{err.message}")
            return    
        store.save(id, storeObj)
    else if !isRecent(storeObj.metaData.endDate)
        try storeObj = await addNewHistory(symbol, storeObj)
        catch err
            bs.report("@ensureSymbolIsUpToDate(#{symbol}) failed to addNewHistory! #{err.message}")
            return    
        store.save(id, storeObj)
    else log "@ensureSymbolIsUpToDate(#{symbol}) nothing to do :-)"
    await waitMS(500)
    return

    # endDate = storeObj.metaData.endDate

    # missingDates = getMissingDates(endDate)
    # results = []
    # for date in missingDates
    #     try results.push(await requestDailyData(symbol, date))
    #     catch err
    #         bs.report("@ensureSymbolIsUpToDate: requestDailyData failed: #{err.message}")
    #         results.push(null)
    #     await waitMS(500)

    # # missingDates = [ "2026-05-21" ]
    # # results = [[ 0.9852962562, 0.9801044071, 0.9827207872 ]]
    # olog { missingDates, results }

    # idx = results.length
    # while --idx ## cut off trailing nulls
    #     if !Array.isArray(results[idx]) 
    #         results.pop()
    #         missingDates.pop()
    #     else break
    
    # lastDataPoint = storeObj.data[storeObj.data.length - 1]
    # lastClose = lastDataPoint[lastDataPoint.length - 1]

    # for hlc in results
    #     if !Array.isArray(hlc) then hlc = [lastClose]
    #     else lastClose = hlc[hlc.length - 1]
    #     storeObj.data.push(hlc)

    # storeObj.metaData.endDate = missingDates[missingDates.length - 1]
    # store.save(id, storeObj)
    # return

############################################################


############################################################
getPriceQueryURL = (symbol, startDate, endDate) ->
    if typeof startDate == "object" then startDate = startDate.toISOString().slice(0,10)
    if typeof endDate == "object" then endDate = endDate.toISOString().slice(0, 10)

    url = baseURL+"/commoditieshistory" 
    params = new URLSearchParams()

    params.set("access_key", accessKey)
    params.set("commodity_name", symbol)
    params.set("date_from", startDate)
    params.set("date_to", endDate)
    params.set("frequency", "daily")
    return url+"?"+params.toString()
