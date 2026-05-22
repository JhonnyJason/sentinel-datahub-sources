############################################################
#region debug
import { createLogFunctions } from "thingy-debug"
{log, olog} = createLogFunctions("startupmodule")
#endregion

############################################################
import { prepareAndExpose } from "./scimodule.js"
import { startLiveDataHeartbeat } from "./marketstackmodule.js"
import { startForexDataHeartbeat } from "./forexapimodule.js"

############################################################
#experimental imports
# import { getData } from "./datamodule.js"

############################################################
export serviceStartup = ->
    log "serviceStartup"
    console.log("starting up...")
    startForexDataHeartbeat()
    # startLiveDataHeartbeat()
    # await prepareAndExpose()
    
    # experiment for testing
    # dataSet = await getData("WMT", 30)
    # dataSet = await getData("AAPL", 30)
    # dataSet = await getData("GOOGL", 30)
    # dataSet = await getData("ANET", 30)
    # olog dataSet.meta.splitFactors
    return
