############################################################
#region debug
import { createLogFunctions } from "thingy-debug"
{log, olog} = createLogFunctions("accessmodule")
#endregion

############################################################
authCodeToHandle = Object.create(null)
## TODO upgrade the authCode Cancellation situation
#    We currently have 1 callback for each authcode 
#    this is becoming costly when  the number of authcodes grow
#    The solution would be to have one heartbeat removing the old ones each cycle

############################################################
export initialize = (c) ->
    log "initialize"
    if c.fallbackAuthCode 
        authCodeToHandle[c.fallbackAuthCode] = {}
    return

############################################################
export setAccess = ({ authCode, ttlMS, limitedFrom }) ->
    log "setAccess"
    log authCode
    log ttlMS
    log limitedFrom

    deathHappens = () -> unsetAccess(authCode)

    handle = authCodeToHandle[authCode]
    if handle? then clearTimeout(handle.deathTimerId)
    else handle = Object.create(null)

    handle.deathTimerId = setTimeout(deathHappens, ttlMS)
    handle.limitedFrom = limitedFrom
    authCodeToHandle[authCode] = handle
    return

############################################################
export unsetAccess = (authCode) ->
    log "unsetAccess"

    handle = authCodeToHandle[authCode]
    return unless handle? # already removed

    clearTimeout(handle.deathTimerId)
    delete authCodeToHandle[authCode]
    return

############################################################
export hasAccess = (authCode) -> 
    log "hasAccess #{authCode}"
    handle = authCodeToHandle[authCode]
    if !handle? then return false

    if handle.limitedFrom == 0 then return true
    if handle.limitedFrom > Date.now() then return true
    return false
    # weHave = ?
    # if weHave and
    # log "we have accesss: #{weHave}"
    # return weHave
