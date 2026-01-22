############################################################
#region debug
import { createLogFunctions } from "thingy-debug"
{log, olog} = createLogFunctions("marketstackmodule")
#endregion

############################################################
import fs from "node:fs"
import path from "node:path"

############################################################
accessToken = null
apiURL = null


############################################################
symbolsDataPath = path.resolve(".", "symbols.json")
currenciesDataPath = path.resolve(".", "currencies.json")
symbolsData = []
currenciesData = []



############################################################
export initialize = (c) ->
    log "initialize"
    if c.mrktStackSecret? then accessToken = c.mrktStackSecret
    if c.urlMrktStack? then apiURL = c.urlMrktStack
    return

############################################################
export executeSpecialMission = ->
    log "executeSpecialMission"
    # await runTest()
    # await storeRelevantSymbols()
    await storeRelevantCurrencies()
    log "sepcialMission ended... bye!"
    return



############################################################
waitMS = (ms) -> new Promise((res) -> setTimeout(res, ms))

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


############################################################
runTest = ->
    log "runTest"
    result = await getAllSymbols()
    # result = await getEndOfDayData("ASML,MSTR")
    # log Object.keys(result) # result always is (pagination, data)
    olog result.pagination
    # olog result
    return

############################################################
printCurrentRateLimits = (headers) ->
    log headers
    dailyLimit = headers.get("X-RateLimit-Limit-Day")
    monthlyLimit = headers.get("X-RateLimit-Limit-Month")
    leftPerDay = headers.get("X-RateLimit-Remaining-Day")
    leftPerMonth = headers.get("X-RateLimit-Remaining-Month")
    olog {
        dailyLimit, leftPerDay, monthlyLimit, leftPerMonth
    }
    return


############################################################
getEndOfDayData = (symbolString) ->
    log "getEndOfDayData"
    #     ? access_key = YOUR_ACCESS_KEY
    #     & symbols = AAPL
        
    # // optional parameters: 

    #     & sort = DESC
    #     & date_from = YYYY-MM-DD
    #     & date_to = YYYY-MM-DD
    #     & limit = 100
    #     & offset = 0

    options = {
        access_key: accessToken
        symbols: symbolString
    }
    params = new URLSearchParams(options)
    url = apiURL + "/eod?" + params.toString()

    try response = await fetch(url)
    catch err then console.error(err)

    try
        printCurrentRateLimits(response.headers) 
        # log "checking response"
        if response.ok then return await response.json()
        # log "Response was not OK :("+response.status+")"
        console.error("status: "+response.status)
        text = await response.text()
        console.error(text)
    catch err then console.error(err)
    return

# postRequest = (url, data, accessToken) ->
#     log "postRequest"
#     options = {
#         method: "POST"
#         headers: {"Content-Type": "application/json"}
#         body: JSON.stringify(data)
#     }    
#     if accessToken? 
#         options.headers['Authorization'] = "Bearer #{accessToken}"

#     try response = await fetch(url, options)
#     catch err then console.error(err)

#     try
#         if response.ok then return await response.json()
#         console.error("status: "+response.status)
#         text = await response.text()
#         console.error(text)
#     catch err then console.error(err)
#     return
