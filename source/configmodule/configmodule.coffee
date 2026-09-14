############################################################
import path from "node:path"
import fs from "node:fs"

############################################################
import * as bs from "./bugsnitch.js"

############################################################
localCfg = Object.create(null)

############################################################
try
    configPath = path.resolve(process.cwd(), ".config.json")
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
export checkAccessMS = localCfg.checkAccessMS || 600_000 # ~10m
export checkSymbolsMS = localCfg.checkSymbolsMS || 3_600_000 # ~1h
export checkForexMS = localCfg.checkForexMS || 1_200_000 # ~20m

export checkCommoditiesMS = localCfg.checkCommoditiesMS || 36_000_000 # ~10h

export watchdogCheckMS = localCfg.watchdogCheckMS || 120_000 # ~2m

############################################################
export watchdogToleranceF = 1.48

############################################################
export forexSymbols = localCfg.forexSymbols || [
    "AUDCAD", "AUDCHF", "AUDJPY", "AUDNZD", "AUDUSD", "CADCHF", "CADJPY", "CHFJPY", "EURAUD", "EURCAD", "EURCHF", "EURGBP", "EURJPY", "EURNZD", "EURUSD", "GBPAUD", "GBPCAD", "GBPCHF", "GBPJPY", "GBPNZD", "GBPUSD", "NZDCAD", "NZDCHF", "NZDJPY", "NZDUSD", "USDCAD", "USDCHF", "USDJPY"
]

############################################################
export commoditySymbols = localCfg.commoditySymbols || [
    "aluminum", "bitumen", "brent", "coal", "cobalt", "copper", "crude oil", "di-ammonium", "ethanol", "gallium", "gasoline", "germanium", "gold", "heating oil", "hrc steel", "indium", "iron ore", "iron ore cny", "kraft pulp", "lead", "lithium", "magnesium", "manganese", "methanol", "molybdenum", "naphtha", "natural gas", "neodymium", "nickel", "palladium", "platinum", "polyethylene", "polypropylene", "polyvinyl", "propane", "rhodium", "silver", "soda ash", "steel", "tellurium", "tin", "titanium", "ttf gas", "uk gas", "uranium", "urea", "zinc"
]

############################################################
export liveDataSymbols = localCfg.liveDataSymbols || [ "HYG", "SPY" ]
# export liveDataHeartbeatMS = 420_000 # 7m
export liveDataHeartbeatMS = localCfg.liveDataHeartbeatMS || 900_000 # 15 min
export liveDataEODRefreshMS = localCfg.liveDataEODRefreshMS ||  3_600_000 # 1h
export eodRefreshMaxAttempts = localCfg.eodRefreshAttempts || 3

############################################################
# local testing: "21e35d83b9960ce67da1b2a132edc99d633cf41336ac591960aa30ad1d958a25"
# remote testing: "d9475cc24ed55635304a4b1e310dc4200a581c8f7099ab0dfae7cec2dad94fe1"
export accessManagerId = localCfg.accessManagerId || ""

export snitchSocket = localCfg.snitchSocket || "/run/bugsnitch.sk"

############################################################
export legalOrigins = localCfg.legalOrigins || [
    "localhost", 
    "localhost:3000",
    "localhost:3333", 
    "sentinel-dashboard-dev.dotv.ee",
    "sentinel-datahub.dotv.ee",
    "sentinel.ewag-handelssysteme.de"
]

############################################################
localCfg = null

############################################################
export name = "Sentinel Datahub"
export version = "v0.2.5"

############################################################
export fallbackAuthCode = "aaaaaaaabbbbbbbbccccccccdddddddd"

############################################################
export persistentStateOptions = {
    basePath: "./state"
    maxCacheSize: 256
}