############################################################
import path from "node:path"
import fs from "node:fs"

############################################################
import * as bs from "./bugsnitch.js"
############################################################
localCfg = Object.create(null)

############################################################
try
    configPath = path.resolve(process.cwd(), "./.config.json")
    localCfgString = fs.readFileSync(configPath, 'utf8')
    localCfg = JSON.parse(localCfgString)
catch err
    msg = "@configmodule - config parsing:\n"
    msg += " Local Config File could not be read or parsed!\n "
    msg += err.message
    bs.report(msg)

############################################################
export trdvtSecret = localCfg.secret || "none"
export trdvtCid = localCfg.cid || "none"
export trdvtUsername = localCfg.name || "none"
export trdvtPassword = localCfg.password || "none"
############################################################
export mrktStackSecret = localCfg.mrktStackSecret || "none"


############################################################
# export urlTrdvt = 'https://demo.tradovateapi.com/v1'
export urlTrdvt = 'https://live.tradovateapi.com/v1'
# export urlTrdvtWS = 'wss://md.tradovateapi.com/v1/websocket',
# 'wss://demo.tradovateapi.com/v1/websocket',
# 'wss://live.tradovateapi.com/v1/websocket'

############################################################
export urlMrktStack = "https://api.marketstack.com/v2"

############################################################
export checkAccessMS = 600_000 # ~10m
export checkSymbolsMS = 3_600_000 # ~1h

############################################################
export liveDataSymbols = [ "HYG" ]
# export liveDataHeartbeatMS = 420_000 # 7m
export liveDataHeartbeatMS = 3_000_000 # 50 min

############################################################
export name = "Sentinel Datahub"
export version = "v0.2.0"

############################################################
export accessManagerId = localCfg.accessManagerId || ""
export snitchSocket = localCfg.snitchSocket || "/run/bugsnitch.sk"

export legalOrigins = [
    "localhost", 
    "localhost:3333", 
    "sentinel-dashboard-dev.dotv.ee",
    "sentinel-datahub.dotv.ee",
    "sentinel.ewag-handelssysteme.de"
]

############################################################
export fallbackAuthCode = "aaaaaaaabbbbbbbbccccccccdddddddd"

############################################################
export persistentStateOptions = {
    basePath: "../state"
    maxCacheSize: 128
}

############################################################
localCfg = null
