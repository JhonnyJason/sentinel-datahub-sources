############################################################
#region debug
import { createLogFunctions } from "thingy-debug"
{log, olog} = createLogFunctions("symbolwatch")
#endregion

############################################################
import * as store from "./storagemodule.js"

############################################################
dataId = "failed-symbols"

############################################################
failedSymbols = new Set()
storeObj = null

############################################################
export noteFailedSymbol = (symbol) ->
    log "noteFailedSymbol"
    if !storeObj? then load()
    if failedSymbols.has(symbol) then return

    failedSymbols.add(symbol)
    save()
    return

############################################################
load = ->
    log "load"
    storeObj = store.load(dataId)
    if Array.isArray(storeObj) then failedSymbols = new Set(storeObj)
    else storeObj = [] # probably empty so keeping the empty Set is ok
    return

save = ->
    log "save"
    storeObj = Array.from(failedSymbols)
    store.save(dataId, storeObj)
    return