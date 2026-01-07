############################################################
#region debug
import { createLogFunctions } from "thingy-debug"
{log, olog} = createLogFunctions("marketstackmodule")
#endregion

############################################################
accessToken = null
apiURL = null



############################################################
export initialize = (c) ->
    log "initialize"
    if c.mrktStackSecret? then accessToken = c.mrktStackSecret
    if c.urlMrktStack? then apiURL = c.urlMrktStack

    # log runTest.toString()
    await runTest()
    return


runTest = ->
    log "runTest"
    result = await getEndOfDayData("ASML,MSTR")
    log Object.keys(result)
    # olog result
    return


############################################################
printCurrentRateLimits = (headers) ->
    dailyLimit = headers.get("X-RateLimit-Limit-Day")
    monthlyLimit = headers.get("X-RateLimit-Limit-Month")
    leftPerDay = headers.get("X-RateLimit-Remaining-Day")
    leftPerMonth = headers.get("X-RateLimit-Remaining-Month")
    olog {
        dailyLimit, leftPerDay, monthlyLimit, leftPerMonth
    }
    return

############################################################
getAllSymbols = ->
    log "getAllSymbols"
    options = { access_key: accessToken, limit: 1000, offset: 0 }
    params = new URLSearchParams(options)
    url = apiURL + "/tickerslist?" + params.toString()

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
