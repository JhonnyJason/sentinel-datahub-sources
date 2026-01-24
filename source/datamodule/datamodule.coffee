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
    symbol = "GOOGL"
    start = performance.now()
    result = await mrktStack.getStockAllHistory(symbol)

    log "full data retrieval took #{performance.now() - start}ms"
    length = result.data.length
    olog result.meta
    log length
    olog result.data[0]
    olog result.data[length - 1]

    return