############################################################
#region debug
import { createLogFunctions } from "thingy-debug"
{log, olog} = createLogFunctions("storagemodule")
#endregion

############################################################
import * as cache from "./statecache.js"

############################################################
export initialize = (cfg) ->
    log "initialize"
    cache.initialize(cfg.persistentStateOptions)
    return

############################################################
export { load, save, remove } from "./statecache.js"