############################################################
#region debug
import { createLogFunctions } from "thingy-debug"
{log, olog} = createLogFunctions("datamodule")
#endregion

############################################################
import * as mrktStack from "./marketstackmodule.js"

############################################################
export initialize = ->
    log "initialize"
    #Implement or Remove :-)
    return



############################################################
export executeSpecialMission = ->
    log "executeSpecialMission"
    symbol = "GOOG"
    start = performance.now()
    result = await mrktStack.getStockAllHistory(symbol)

    log "full data retrieval took #{performance.now() - start}ms"
    dataSet = result.dataSet
    result.dataSet = ""
    olog result
    olog dataSet.meta
    log dataSet.data.length
    # olog result
    return