############################################################
#region debug
import { createLogFunctions } from "thingy-debug"
{log, olog} = createLogFunctions("scimodule")
#endregion

############################################################
#region modules from the Environment
## import * as sciBase from "thingy-sci-base"
#endregion

############################################################
routes = {}

routes["sampleRoute"] = (res, req) ->
    # req.body is our json
    # handle
    res.send("Hello World!")

    
############################################################
export prepareAndExpose = ->
    log "prepareAndExpose"
    
    ## sciBase.prepareAndExpose(null, routes)
    ## log "Server listening!"
    return
