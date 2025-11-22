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
export tradovateSecret = localCfg.secret || "none"
export tradovateCid = localCfg.cid || "none"

############################################################
export configprop = true
