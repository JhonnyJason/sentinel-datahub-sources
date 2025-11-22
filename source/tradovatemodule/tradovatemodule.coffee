############################################################
#region debug
import { createLogFunctions } from "thingy-debug"
{log, olog} = createLogFunctions("tradovatemodule")
#endregion


############################################################
apiCid = null
apiSecret = null 

############################################################
export initialize = (c) ->
    log "initialize"
    if c.tradovateSecret? then apiSecret = c.tradovateSecret
    if c.tradovateCid? then apiCid = c.tradovateCid
    return

export simpleTest = ->
    log "simpleTest"
    olog { apiCid, apiSecret }
    ## TODO implement a simple test
    return