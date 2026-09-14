############################################################
#region debug
import { createLogFunctions } from "thingy-debug"
{log, olog} = createLogFunctions("authmodule")
#endregion

############################################################
import * as secUtl from "secret-manager-crypto-utils"
import { checkValidity } from "validatabletimestamp"
import {
    createValidator, STRINGHEX64, NUMBER, STRINGHEX128
} from "thingy-schema-validate"

############################################################
import { isBlocked } from "./earlyblockermodule.js"

############################################################
authorizedPubKey = null
ttlNonce = 600_000 # ~ 10 min

############################################################
authSchema = {
    signature: STRINGHEX128
    nonce: NUMBER
    timestamp: NUMBER
    senderId: STRINGHEX64
}
validateAuth = createValidator(authSchema)

############################################################
nonceToDeathTime = Object.create(null)
mrkr = '\x1F' ## US Unit Separator - cannot be part of valid JSON string

############################################################
export initialize = (c) ->
    log "initialize"
    authorizedPubKey = c.accessManagerId
    log authorizedPubKey

    setInterval(removeDeadNonces, ttlNonce) 
    return

############################################################
removeDeadNonces = ->
    now = Date.now()
    for nonce, deathTime of nonceToDeathTime when deathTime < now 
        delete nonceToDeathTime[nonce]
    return

############################################################
export signatureAuth = (req, ctx) ->
    log "signatureAuth"
    olog ctx
    
    ## check if client host relationthip is seemingly abusive
    ip = ctx.meta.ip
    host = ctx.meta.host
    err = isBlocked(ip, host)
    if err then return "Client Blocked!"
    # log "is not blocked!"

    ## check if the shape of the auth Object fits
    err = validateAuth(ctx.auth)
    if err then return "Invalid Auth Object!"
    # log "auth object is valid!"

    ## check if the request froms from our expected authorized sender
    senderId = ctx.auth.senderId
    if !(senderId == authorizedPubKey) then return "Unauthorized Sender!"
    # log "senderId is authorized!"

    ## check if the timestamp is valid
    timestamp = ctx.auth.timestamp
    err = checkValidity(timestamp)
    if err then return "Invalid Timestamp!"
    # log "timestamp is valid!"
    
    ## check if nonce had been used already then set it as used
    nonce = ctx.auth.nonce
    if nonceToDeathTime[nonce]? then return "Nonce used already!"
    nonceToDeathTime[nonce] = Date.now() + ttlNonce

    ## check if we have a valid signature
    sig = ctx.auth.signature
    signedString = ctx.bodyString.replace(sig, mrkr)
    isValid = await secUtl.verify(sig, authorizedPubKey, signedString)
    if !isValid then return "Invalid Signature!"
    # log "signature is valid!"

    log "We have a fully authorized Request!"
    return

