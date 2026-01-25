############################################################
import pathModule from "path"
import fs from "fs"

############################################################
fsA = fs.promises

############################################################
basePath = null

############################################################
export initialize = (path) ->
    if !path? then path = "./state"
    if pathModule.isAbsolute(path) then absoluteBasePath = path
    else absoluteBasePath = pathModule.resolve(process.cwd(), path)

    basePath = absoluteBasePath
    fs.mkdirSync(basePath) unless fs.existsSync(basePath)
    return

############################################################
#region internalFunctions
getPath = (label) ->
    filename = label+".json"
    path = pathModule.resolve(basePath, filename)
    return path

############################################################
#region backupFunctions
getBackupPath = (path) -> path+".backup"

backup = (path) ->
    backupPath = getBackupPath(path)
    try fs.copyFileSync(path, backupPath)
    catch err
        newMessage = "Error: backing up state failed!\n"
        newMessage += "file: "+path+"\n"
        newMessage += "reason: "+err.message
        throw new Error(newMessage)
    return

loadBackup = (id) ->
    path = getPath(id)
    backupPath = getBackupPath(path)
    try
        contentJson = fs.readFileSync(backupPath, "utf-8")
        contentObj = JSON.parse(contentJson)
        fsA.writeFile(path, contentJson)
        return { contentObj, contentJson }
    catch err 
        contentObj = null
        contentJson = null
        return {contentObj, contentJson}
    
#endregion

#endregion

############################################################
#region exposedFunctions
export load = (id) ->
    path = getPath(id)
    try
        contentJson = fs.readFileSync(path, "utf-8")
        contentObj = JSON.parse(contentJson)
        return { contentObj, contentJson }
    catch err
        return loadBackup(id)

export save = (id, contentJson) ->
    path = getPath(id)
    fs.writeFileSync(path, contentJson)
    backup(path)
    return

export remove = (id) ->
    path = getPath(id)
    backupPath = getBackupPath(path)
    p1 = fsA.unlink(path)
    p2 = fsA.unlink(backupPath)
    try await Promise.all([p1, p2])
    catch err then return
    return

#endregion