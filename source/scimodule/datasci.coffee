############################################################
#region debug
import { createLogFunctions } from "thingy-debug"
{log, olog} = createLogFunctions("datasci")
#endregion

############################################################
#region Modules from the Environment
import {
    STRINGHEX32, NONEMPTYSTRING, NUMBERORNOTHING, 
    BOOLEAN, ARRAY, createValidator
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
authenticate = (req) -> 
    return "No arg provided!" unless req? and req.auth? 
    return "No Access!" unless accsM.hasAccess(req.auth.authCode) 
    return "" # no error = authenticated 

############################################################
getData = (args) -> await dataM.getData(args.dataKey, args.yearsBack)

#endregion


############################################################
## Config Object with all options
# { 
#   bodySizeLimit: # limit body size for this route -> whole payload
#   authOption:  # add a function for request authentication (req, ctx) return falsly on success!
#   argsSchema: # required for arguments - will be validated
#   resultSchema: # required for results - will be validated
#   responseAuth: # add a function to proof response authenticity (resultString, ctx)
# }

############################################################ 
#region Data Functions

############################################################ 
sciAdd("getEODHLCData", getData, {
    bodySizeLimit: 1024, 
    authOption: authenticate,
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
            splitFactors: ARRAY,
            historyComplete: BOOLEAN
        },
        data: ARRAY
    }
})
#Response is 204 when signature is valid 403 otherwise 


#endregion

