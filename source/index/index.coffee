import Modules from "./allmodules"

############################################################
global.allModules = Modules
import *  as cfg from "./configmodule.js"
############################################################
import * as bs from "./bugsnitch.js"

############################################################
run = ->
    try
        promises = (m.initialize(cfg) for n,m of Modules when m.initialize?) 
        await Promise.all(promises)
        await Modules.startupmodule.serviceStartup()
    catch err then bs.report("@run: "+err.message)

############################################################
run()
