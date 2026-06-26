############################################################
#region debug
import { createLogFunctions } from "thingy-debug"
{log, olog} = createLogFunctions("forexapimodule")
#endregion

############################################################
import * as store from "./storagemodule.js"
import * as bs from "./bugsnitch.js"
import * as liveFeed from "./livefeedmodule.js"

############################################################
baseURL = ""

############################################################
apiKey = ""
forexSymbols = []
forexCurrencies = new Set()
############################################################
# heartbeatMS = 36_000_000 # ~10h
heartbeatMS = 2_160_000 # ~36m

############################################################
heartbeatRunning = false


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
    
    for sym in forexSymbols when sym.length == 6
        forexCurrencies.add(sym.slice(0, 3)) # add base currency
        forexCurrencies.add(sym.slice(3)) # add quote currency

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

    try await retrieveAllLiveData()
    catch err then bs.report("@forexapimodule.heartbeat: retrieveAllLiveData() failed: #{err.messsage}")

    if heartbeatRunning then return
    heartbeatRunning = true

    for symbol in forexSymbols
        await waitMS(32000)
        try await ensureSymbolIsUpToDate(symbol)
        catch err then bs.report("@forexapimodule.heartbeat: ensureSymbolIsUpToDate(#{symbol}) failed: #{err.messsage}")
    
    heartbeatRunning = false
    log "heartbeat finished!"
    return

############################################################
retrieveAllLiveData = ->
    log "retrieveAllLiveData"
    allCurrencies = [...forexCurrencies].join(",")

    try await updateLiveData(allCurrencies)
    catch err then bs.report("@retrieveAllLiveData: updateLiveData failed: #{err.message}")
    return


############################################################
digestLiveDataResponse = (obj) ->
    # log "digestLiveDataResponse"
    if !obj.success then throw new Error("Request unsuccessful: " + obj.error)
    if obj.base != "USD" then throw new Error("Unexpected base currency (#{obj.base}) in response!")
    if typeof obj.rates != "object" then throw new Error("response.rates was not an object!")

    # olog obj

    allRates = Object.create(null)
    for quote,rate of obj.rates when quote != "USD"
        pairForward = obj.base+quote
        allRates[pairForward] = rate
        pairBackward = quote+obj.base
        allRates[pairBackward] = 1.0 / rate

    # olog allRates

    livePrices = Object.create(null)
    
    for sym in forexSymbols
        if allRates[sym]? then livePrices[sym] = allRates[sym]
        else
            base = sym.slice(0,3)
            quote = sym.slice(3)
            usdrefBase = allRates["USD#{base}"]
            usdrefQuote = allRates["USD#{quote}"]
            livePrices[sym] = usdrefQuote / usdrefBase

    # olog livePrices
    liveFeed.updatePrices(livePrices)
    return

############################################################
updateLiveData = (currencies) ->
    url = getLiveDataQueryURL(currencies)
    # log url
    # return

    response = await fetch(url)
    if !response.ok
        text = await response.text()
        throw new Error("HTTP #{response.status}: #{text.slice(0, 200)}")
    
    body = await response.json()
    return digestLiveDataResponse(body)

############################################################
digestResponse = (obj) ->
    # log "digestResponse"
    if !obj.success then throw new Error("Request unsuccessful: " + obj.error)
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

    # olog obj
    # tsDate = new Date(obj.timestamp * 1000)
    # log tsDate.toISOString()
    return [ obj.rate.high, obj.rate.low, obj.rate.close ]

############################################################
requestDailyData = (symbol, date) ->
    base = symbol.slice(0,3)
    currency = symbol.slice(3)
    # olog { base, currency }

    url = getOHLCQueryURL(base, currency, date)
    # log url
    # return

    response = await fetch(url)
    if !response.ok
        text = await response.text()
        throw new Error("HTTP #{response.status}: #{text.slice(0, 200)}")
    
    body = await response.json()
    return digestResponse(body)



############################################################
getMissingDates = (lastDate) ->
    dayMS = 86_400_000 # 24 hours

    endDate = (new Date()).toISOString().slice(0, 10) # date now in UTC
    ## Expected time when date for the previous day should've been published
    endMS = new Date(endDate+"T00:05:30.000Z").getTime()

    # dateMS is representing the potential missing dates -> start with lastDate + 1 Day
    # setting dateMS 00:06:00 while endMS was set to 00:05:30 ensures 
    # that (dateMS < endMS) only for full days before the endDate -> end with endDate - 1 Day
    dateMS = (new Date(lastDate+"T00:06:00.000Z")).getTime() + dayMS 
    
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
    
    if !storeObj? or !storeObj.meta?
        bs.report("@ensureSymbolIsUpToDate: no History for #{symbol}!")
        return

    endDate = storeObj.meta.endDate

    missingDates = getMissingDates(endDate)
    # log missingDates

    results = []
    for date in missingDates
        log "requesting Daily Data @#{(new Date()).toISOString()}"
        try results.push(await requestDailyData(symbol, date))
        catch err
            bs.report("@ensureSymbolIsUpToDate: requestDailyData failed: #{err.message}")
            results.push(null)
        await waitMS(1700)

    # missingDates = [ "2026-05-21" ]
    # results = [[ 0.9852962562, 0.9801044071, 0.9827207872 ]]
    # olog { missingDates, results }

    idx = results.length
    while --idx ## cut off trailing nulls
        if !Array.isArray(results[idx]) and idx >= 0
            log "cutting off #{idx}"
            results.pop()
            missingDates.pop()
        else break
    
    lastDataPoint = storeObj.data[storeObj.data.length - 1]
    lastClose = lastDataPoint[lastDataPoint.length - 1]

    for hlc in results
        if !Array.isArray(hlc) then hlc = [lastClose]
        else lastClose = hlc[hlc.length - 1]
        storeObj.data.push(hlc)

    storeObj.meta.endDate = missingDates[missingDates.length - 1]
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

############################################################
getLiveDataQueryURL = (currencies) ->
    url = baseURL+"/latest" 
    params = new URLSearchParams()

    params.set("api_key", apiKey)
    params.set("currencies", currencies)
    return url+"?"+params.toString()
