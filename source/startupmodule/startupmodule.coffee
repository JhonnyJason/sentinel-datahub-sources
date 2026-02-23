############################################################
#region debug
import { createLogFunctions } from "thingy-debug"
{log, olog} = createLogFunctions("startupmodule")
#endregion

############################################################
import { prepareAndExpose } from "./scimodule.js"
import { startLiveDataHeartbeat } from "./marketstackmodule.js"

############################################################
#experimental imports
# import { getData } from "./datamodule.js"

############################################################
export serviceStartup = ->
    log "serviceStartup"
    startLiveDataHeartbeat()
    await prepareAndExpose()
    
    # # experiment - check Netflix Data
    # dataSet = await getData("NFLX", 30)
    # olog dataSet.meta.splitFactors
    return
