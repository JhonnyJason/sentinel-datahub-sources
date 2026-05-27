############################################################
#region debug
import { createLogFunctions } from "thingy-debug"
{log, olog} = createLogFunctions("startupmodule")
#endregion

############################################################
import { prepareAndExpose } from "./scimodule.js"
import { startLiveDataHeartbeat } from "./marketstackmodule.js"
import { startForexDataHeartbeat } from "./forexapimodule.js"
import { startCommodityDataHeartbeat } from "./commoditydatamodule.js"

############################################################
#experimental imports
import { getData } from "./datamodule.js"

############################################################
export serviceStartup = ->
    log "serviceStartup"
    console.log("starting up...")
    # startCommodityDataHeartbeat() # not fully tested yet!

    # startForexDataHeartbeat()
    # startLiveDataHeartbeat()
    # await prepareAndExpose()
    
    # experiment for testing

    try dataSet = await getData("REIT.AS", 30)
    catch err then console.error(err)
    if dataSet? then console.log "We Actually god a dataSet!"
    else console.log("We shoul have had an error...")
    
    # dataSet = await getData("AAPL", 30)
    # dataSet = await getData("GOOGL", 30)
    # dataSet = await getData("ANET", 30)
    # olog dataSet.meta.splitFactors
    return
