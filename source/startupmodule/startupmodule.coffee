############################################################
#region debug
import { createLogFunctions } from "thingy-debug"
{log, olog} = createLogFunctions("startupmodule")
#endregion

############################################################
import * as tradovate from "./tradovatemodule.js"
import * as mrktStack from "./marketstackmodule.js"
import * as dataM from "./datamodule.js"

############################################################
export serviceStartup = ->
    log "serviceStartup"
    # await tradovate.startSession()
    # await mrktStack.executeSpecialMission()
    await dataM.executeSpecialMission()
    return
