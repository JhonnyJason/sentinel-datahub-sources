############################################################
#region debug
import { createLogFunctions } from "thingy-debug"
{log, olog} = createLogFunctions("startupmodule")
#endregion

############################################################
import * as tradovate from "./tradovatemodule.js"

############################################################
export serviceStartup = ->
    log "serviceStartup"
    await tradovate.simpleTest()
    return
