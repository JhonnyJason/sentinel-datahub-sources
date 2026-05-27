############################################################
#region debug
import { createLogFunctions } from "thingy-debug"
{log, olog} = createLogFunctions("idutils")
#endregion

############################################################
export idForStock = (name) -> "did:#{name.replace(".", "-")}"
export idForForex = (name) -> "did:#{name.replace(".", "-")}"
export idForCommodity = (name) -> "did:#{name.replaceAll(" ", "_")}"