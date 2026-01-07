############################################################
#region debug
import { createLogFunctions } from "thingy-debug"
{log, olog} = createLogFunctions("tradovatemodule")
#endregion

############################################################
import * as data from "cached-persistentstate"

############################################################
userName = null
apiPassword = null
apiCid = null
apiSecret = null 
appId = "sentinel"
version = null

############################################################
checkAccessMS = 600_000 # ~10m
checkSymbolsMS = 3_600_000 # ~1h

############################################################
urlBaseTrdvt = null 
urlBaseWebsocket = null

############################################################
storageObj = null

############################################################
export initialize = (c) ->
    log "initialize"
    return
    data.initialize(c.persistentStateOptions)

    if c.trdvtSecret? then apiSecret = c.trdvtSecret
    if c.trdvtCid? then apiCid = c.trdvtCid
    if c.trdvtUsername? then userName = c.trdvtUsername
    if c.trdvtPassword? then apiPassword = c.trdvtPassword
    if c.version? then verstion = c.version
    if c.urlTrdvt? then urlBaseTrdvt = c.urlTrdvt
    if c.urlTrdvtWS? then urlBaseWebsocket = c.urlTrdvtWS
    
    if c.checkAccessMS? then checkAccessMS = c.checkAccessMS
    if c.checkSymbolsMS? then checkSymbolsMS = c.checkSymbolsMS

    storageObj = data.load("datahubState") || {}
        
    olog storageObj
    return

############################################################
saveToStorage = (obj) ->
    log "saveStorage"
    if obj then storageObj = obj
    data.save("datahubState", storageObj)
    return

############################################################
#region Requests
getRequest = (url, accessToken) ->
    log "getRequest"
    options = {
        method: "GET"
        headers: {
            'Content-Type': 'application/json'
            'Accept': 'application/json',
        }
    }    

    if accessToken? 
        options.headers['Authorization'] = "Bearer #{accessToken}"

    try response = await fetch(url, options)
    catch err then console.error(err)

    try
        if response.ok then return await response.json()
        console.error("status: "+response.status)
        text = await response.text()
        console.error(text)
    catch err then console.error(err)
    return

postRequest = (url, data, accessToken) ->
    log "postRequest"
    options = {
        method: "POST"
        headers: {"Content-Type": "application/json"}
        body: JSON.stringify(data)
    }    
    if accessToken? 
        options.headers['Authorization'] = "Bearer #{accessToken}"

    try response = await fetch(url, options)
    catch err then console.error(err)

    try
        if response.ok then return await response.json()
        console.error("status: "+response.status)
        text = await response.text()
        console.error(text)
    catch err then console.error(err)
    return

#endregion

############################################################
refreshToken = ->
    log "refreshToken"
    url = urlBaseTrdvt + "/auth/renewAccessToken"

    resp = await getRequest(url, storageObj.accessToken)
    olog resp

    if resp.accessToken? then storageObj.accessToken = resp.accessToken
    if resp.mdAccessToken? then storageObj.mdAccessToken = resp.mdAccessToken
    if resp.expirationTime? then storageObj.expirationTime = resp.expirationTime
    
    saveToStorage()
    return

requestAccessToken = ->
    log "requestAccessToken"
    credentials = {
        name: userName
        password: apiPassword
        appId: appId
        appVersion: version
        cid: apiCid
        sec: apiSecret 
    }

    url = urlBaseTrdvt + "/auth/accesstokenrequest"
    accessData = await postRequest(url, credentials)
    olog accessData
    
    if accessData? then saveToStorage(accessData)
    return


############################################################
ensureFreshToken = ->
    log "ensureFreshToken"
    expDate = storageObj.expirationTime
    if !expDate? then return requestAccessToken()

    exp = new Date(expDate).getTime()
    now = new Date().getTime()
    timeToExpiry = exp - now

    olog {
        exp, now, timeToExpiry
    }

    if timeToExpiry < 0 then return requestAccessToken()
    if timeToExpiry < checkAccessMS * 1.9 then return refreshToken()
    return

checkSymbols = ->
    log "checkSymbols"
    # url = urlBaseTrdvt + "/contract/list"
    # url = urlBaseTrdvt + "/account/list"
    # url = urlBaseTrdvt + "/currency/list"
    url = urlBaseTrdvt + "/product/list"
    log "using url: "+url

    # resp = await getRequest(url, storageObj.accessToken)
    resp = await getRequest(url, storageObj.mdAccessToken)
    olog resp

    ## TODO digestResponse
    return

############################################################
export startSession = (rejectOld) ->
    log "startSession"
    if rejectOld then await requestAccessToken()
    await ensureFreshToken()
    setInterval(ensureFreshToken, checkAccessMS)
    await checkSymbols()
    setInterval(checkSymbols, checkSymbolsMS)
    return
