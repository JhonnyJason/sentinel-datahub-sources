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
export forexapiKey = localCfg.forexapiKey || "none"

############################################################
# export urlTrdvt = 'https://demo.tradovateapi.com/v1'
export urlTrdvt = 'https://live.tradovateapi.com/v1'
# export urlTrdvtWS = 'wss://md.tradovateapi.com/v1/websocket',
# 'wss://demo.tradovateapi.com/v1/websocket',
# 'wss://live.tradovateapi.com/v1/websocket'

############################################################
export urlMrktStack = "https://api.marketstack.com/v2"
export urlForexAPI = "https://api-eu.forexrateapi.com/v1"

############################################################
export checkAccessMS = 600_000 # ~10m
export checkSymbolsMS = 3_600_000 # ~1h
# export checkForexMS = 72_000_000 # 20h
export checkForexMS = 1_200_000 # ~20m

export checkCommoditiesMS = 36_000_000 # ~10h

export watchdogCheckMS = 120_000 # ~2m

############################################################
export watchdogToleranceF = 1.48

############################################################
export forexSymbols = [
    "AUDCAD", "AUDCHF", "AUDJPY", "AUDNZD", "AUDUSD", "CADCHF", "CADJPY", "CHFJPY", "EURAUD", "EURCAD", "EURCHF", "EURGBP", "EURJPY", "EURNZD", "EURUSD", "GBPAUD", "GBPCAD", "GBPCHF", "GBPJPY", "GBPNZD", "GBPUSD", "NZDCAD", "NZDCHF", "NZDJPY", "NZDUSD", "USDCAD", "USDCHF", "USDJPY"
]

############################################################
export commoditySymbols = [ 
    "aluminum", "bitumen", "brent", "coal", "cobalt", "copper", "crude oil", "di-ammonium", "ethanol", "gallium", "gasoline", "germanium", "gold", "heating oil", "hrc steel", "indium", "iron ore", "iron ore cny", "kraft pulp", "lead", "lithium", "magnesium", "manganese", "methanol", "molybdenum", "naphtha", "natural gas", "neodymium", "nickel", "palladium", "platinum", "polyethylene", "polypropylene", "polyvinyl", "propane", "rhodium", "silver", "soda ash", "steel", "tellurium", "tin", "titanium", "ttf gas", "uk gas", "uranium", "urea", "zinc"
]

############################################################
export liveDataSymbols = [ "HYG", "SPY" ]
# export liveDataHeartbeatMS = 420_000 # 7m
export liveDataHeartbeatMS = 900_000 # 15 min
export liveDataEODRefreshMS = 3_600_000 # 1h
export eodRefreshMaxAttempts = 3

############################################################
export name = "Sentinel Datahub"
export version = "v0.2.4"

############################################################
export accessManagerId = localCfg.accessManagerId || ""
export snitchSocket = localCfg.snitchSocket || "/run/bugsnitch.sk"

############################################################
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
    maxCacheSize: 256
}

############################################################
localCfg = null
