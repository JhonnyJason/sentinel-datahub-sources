############################################################
#region debug
import { createLogFunctions } from "thingy-debug"
{log, olog} = createLogFunctions("watchdogmodule")
#endregion

############################################################
import { performance } from 'node:perf_hooks'
import process from 'node:process'
import * as bs from './bugsnitch.js'

############################################################
heartbeatMS = 120_000
toleranceF = 1.44
maxDeltaMS = heartbeatMS * toleranceF

############################################################
lastStamp = 0

############################################################
export initialize = (c) ->
    log "initialize"
    if c.watchdogToleranceF? then tolerancF = c.watchdogToleranceF
    if c.watchdogCheckMS? then heartbeatMS = c.watchdogCheckMS
    maxDeltaMS = heartbeatMS * toleranceF
    setInterval(heartbeat, heartbeatMS)    
    return

############################################################
heartbeat = ->
    # log "heartbeat"
    nowStamp = performance.now()
    deltaMS = nowStamp - lastStamp

    # olog { nowStamp, lastStamp, deltaMS, maxDeltaMS }
    
    if deltaMS > maxDeltaMS
        date  = new Date()
        bs.report("Watchdog exeeded tolerance! @#{date.toISOString()}")
        process.exit(1)
    # else log "all good :-)"

    lastStamp = nowStamp
    return
    
