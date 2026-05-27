############################################################
#region debug
import { createLogFunctions } from "thingy-debug"
{log, olog} = createLogFunctions("forexapimodule")
#endregion

############################################################
import * as store from "./storagemodule.js"
import * as bs from "./bugsnitch.js"

############################################################
baseURL = ""

############################################################
apiKey = ""
forexSymbols = []

############################################################
heartbeatMS = 36_000_000 # ~10h

############################################################
waitMS = (ms) -> new Promise((res) -> setTimeout(res, ms))
toStorageId = (name) -> return "did:#{name.replace(".", "-")}"


############################################################
export initialize = (c) ->
    log "initialize"
    if c.forexapiKey? then apiKey = c.forexapiKey
    if c.forexSymbols? then forexSymbols = [...c.forexSymbols]
    if c.checkForexMS? then heartbeatMS = c.checkForexMS
    if c.urlForexAPI? then baseURL = c.urlForexAPI
    return


############################################################
export startForexDataHeartbeat = ->
    log "startForexDataHeartbeat"
    setInterval(heartbeat, heartbeatMS)
    # heartbeat() ## just for testing... no need to start it immediately
    return


############################################################
heartbeat = ->
    log "heartbeat"
    for symbol in forexSymbols
        try await ensureSymbolIsUpToDate(symbol)
        catch err then bs.report("@forexapimodule.heartbeat: ensureSymbolIsUpToDate(#{symbol}) failed: #{err.messsage}")
        await waitMS(12000)

    return

############################################################
digestResponse = (obj) ->
    log "digestResponse"
    if !obj.success then throw new Error("Eequest unsuccessful: " + obj.error)
    ## Sample
    # {
    #     "success": true,
    #     "base": "XAU",
    #     "quote": "USD",
    #     "timestamp": 1738108799,
    #     "rate": {
    #         "close": 2742.2233288617,
    #         "high": 2764.9591200794,
    #         "low": 2735.1078165826,
    #         "open": 2741.9706872366
    #     }
    # }

    olog obj

    return [ obj.rate.high, obj.rate.low, obj.rate.close ]

############################################################
requestDailyData = (symbol, date) ->
    base = symbol.slice(0,3)
    currency = symbol.slice(3)
    olog { base, currency }

    url = getOHLCQueryURL(base, currency, date)
    log url
    # return

    response = await fetch(url)
    if !response.ok
        text = await response.text()
        throw new Error("HTTP #{response.status}: #{text.slice(0, 200)}")
    
    body = await response.json()
    return digestResponse(body)

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
ensureSymbolIsUpToDate = (symbol) ->
    log "ensureSymbolIsUpToDate"
    id = toStorageId(symbol)
    storeObj = store.load(id)
    
    if !storeObj? or !storeObj.metaData?
        bs.report("@ensureSymbolIsUpToDate: no History for #{symbol}!")
        return

    endDate = storeObj.metaData.endDate

    missingDates = getMissingDates(endDate)
    results = []
    for date in missingDates
        try results.push(await requestDailyData(symbol, date))
        catch err
            bs.report("@ensureSymbolIsUpToDate: requestDailyData failed: #{err.message}")
            results.push(null)
        await waitMS(500)

    # missingDates = [ "2026-05-21" ]
    # results = [[ 0.9852962562, 0.9801044071, 0.9827207872 ]]
    olog { missingDates, results }

    idx = results.length
    while --idx ## cut off trailing nulls
        if !Array.isArray(results[idx]) 
            results.pop()
            missingDates.pop()
        else break
    
    lastDataPoint = storeObj.data[storeObj.data.length - 1]
    lastClose = lastDataPoint[lastDataPoint.length - 1]

    for hlc in results
        if !Array.isArray(hlc) then hlc = [lastClose]
        else lastClose = hlc[hlc.length - 1]
        storeObj.data.push(hlc)

    storeObj.metaData.endDate = missingDates[missingDates.length - 1]
    store.save(id, storeObj)
    return


############################################################
getOHLCQueryURL = (base, currency, date) ->
    url = baseURL+"/ohlc" 
    params = new URLSearchParams()
    if typeof date == "object" then date = date.toISOString().slice(0,10)

    params.set("api_key", apiKey)
    params.set("base", base)
    params.set("currency", currency)
    params.set("date", date)
    return url+"?"+params.toString()
