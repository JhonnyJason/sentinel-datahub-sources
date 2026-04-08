############################################################
#region debug
import { createLogFunctions } from "thingy-debug"
{log, olog} = createLogFunctions("marketstackrequest")
#endregion

############################################################
import { RequestGuard } from "./throttledrequest.js"

############################################################
normalGuard = new RequestGuard({ maxPerWindow: 5, windowMS: 1001 })
commoditiesGuard = new RequestGuard({ maxPerWindow: 1, windowMS: 60_001 })

############################################################
export request = (url) ->
    if url.indexOf("https://api.marketstack.com/v2/commodities") == 0
        return commoditiesGuard.request(url)
    else return normalGuard.request(url)