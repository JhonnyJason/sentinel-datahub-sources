############################################################
#region debug
import { createLogFunctions } from "thingy-debug"
{log, olog} = createLogFunctions("startupmodule")
#endregion

############################################################
import { prepareAndExpose } from "./scimodule.js"
import { startLiveDataHeartbeat } from "./marketstackmodule.js"

############################################################
export serviceStartup = ->
    log "serviceStartup"
    startLiveDataHeartbeat()
    await prepareAndExpose()
    return
