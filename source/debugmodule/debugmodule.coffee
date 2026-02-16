import { addModulesToDebug } from "thingy-debug"

############################################################
modulesToDebug = {
    # bugsnitch: true
    datamodule: true
    livefeedmodule: true
    marketstackmodule: true
    # scimodule: true
    # startupmodule: true
    # tradovatemodule: true
}

addModulesToDebug(modulesToDebug)
