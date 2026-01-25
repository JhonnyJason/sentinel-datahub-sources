############################################################
#region debug
import { createLogFunctions } from "thingy-debug"
{log, olog} = createLogFunctions("startupmodule")
#endregion

############################################################
import { sciStartServer } from "./scicoremodule.js"

############################################################
export serviceStartup = ->
    log "serviceStartup"
    await sciStartServer()
    return
