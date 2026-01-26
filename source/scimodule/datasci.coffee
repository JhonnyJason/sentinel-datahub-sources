############################################################
#region debug
import { createLogFunctions } from "thingy-debug"
{log, olog} = createLogFunctions("datasci")
#endregion

############################################################
#region Modules from the Environment
import {
    STRINGHEX32, NONEMPTYSTRING, NUMBERORNOTHING, createValidator
} from "thingy-schema-validate"

############################################################
import { sciAdd, setValidatorCreator } from "./scicoremodule.js"
setValidatorCreator(createValidator)

############################################################
import * as accsM from "./accessmodule.js"
import * as dataM from "./datamodule.js"

#endregion

############################################################
#region wrapper functions

############################################################
hasAccess = (req) -> 
    return false unless req?
    return accsM.hasAccess(req.authCode)

############################################################
getData = (args) -> await dataM.getData(args.dataKey, args.yearsBack)

#endregion


############################################################
## Config Object with all options
# { 
#   bodySizeLimit: # limit body size for this route -> whole payload
#   authOption:  # add a function for request authentication (req, ctx)
#   argsSchema: # required for arguments - will be validated
#   resultSchema: # required for results - will be validated
#   responseAuth: # add a function to proof response authenticity (resultString, ctx)
# }

############################################################ 
#region Data Functions

############################################################ 
sciAdd("getEODHLCData", getData, {
    bodySizeLimit: 1024, 
    authOption: hasAccess,
    argsSchema: {
        authCode: STRINGHEX32,
        dataKey: NONEMPTYSTRING,
        yearsBack: NUMBERORNOTHING
    }
    resultSchema: {
        meta: {
            startDate: NONEMPTYSTRING,
            endDate: NONEMPTYSTRING,
            interval: "1d",
            historyComplete: BOOLEAN
        },
        data: ARRAY
    }
})
#Response is 204 when signature is valid 403 otherwise 


#endregion

