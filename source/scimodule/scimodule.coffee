############################################################
#region debug
import { createLogFunctions } from "thingy-debug"
{log, olog} = createLogFunctions("scimodule")
#endregion

############################################################
import * as scicore from "./scicoremodule.js"

############################################################
import "./accesssci.js"

#endregion


############################################################
export prepareAndExpose = ->
    log "prepareAndExpose"
    await scicore.sciStartServer()
    log "Server listening!"
    return
