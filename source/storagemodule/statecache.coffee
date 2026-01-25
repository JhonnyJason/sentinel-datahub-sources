############################################################
#region debug
import { createLogFunctions } from "thingy-debug"
{log, olog} = createLogFunctions("statecachemodule")
#endregion

############################################################
import * as saver from "./statesaver.js"

############################################################
jsonCache = {}
objCache = {}

############################################################
#caching Stuff
cacheHeadEntry = null
cacheTailEntry = null
idToCacheEntry = {}
cacheSize = 0
maxCacheSize = 64

defaultState = null

############################################################
export initialize = (options) ->
    if options
        defaultState = options.defaultState
        if options.maxCacheSize? then maxCacheSize = options.maxCacheSize
        saver.initialize(options.basePath)
    else
        saver.initialize()
    return

############################################################
class CacheEntry
    constructor: (@id) ->
        # log "constructor"
        # olog {cacheSize, maxCacheSize}

        @nextEntry = null
        @previousEntry = cacheHeadEntry
        # log "cacheHeadEntry?"+cacheHeadEntry? 
        # log "cacheTailEntry?"+cacheTailEntry?

        if !cacheTailEntry? then cacheTailEntry = this
        # log "cacheHeadEntry?"+cacheHeadEntry? 
        # log "cacheTailEntry?"+cacheTailEntry?

        if cacheHeadEntry? then cacheHeadEntry.nextEntry = this
        cacheHeadEntry = this
        idToCacheEntry[@id] = this
        cacheSize++
        # log "cacheHeadEntry?"+cacheHeadEntry? 
        # log "cacheTailEntry?"+cacheTailEntry?
        # olog {cacheSize, maxCacheSize}
        if cacheSize > maxCacheSize then cutCacheTail()
        # olog {cacheSize, maxCacheSize}

    touch: ->
        return unless @nextEntry?# we are the head
        if @previousEntry? # we are in the middle
            @nextEntry.previousEntry = @previousEntry
            @previousEntry.nextEntry = @nextEntry
        else # we are the tail
            cacheTailEntry = @nextEntry
            @nextEntry.previousEntry = null
        @nextEntry = null
        @previousEntry = cacheHeadEntry
        if cacheHeadEntry? then cacheHeadEntry.nextEntry = this
        cacheHeadEntry = this
        return

    remove: ->
        if @nextEntry? and @previousEntry?
            @nextEntry.previousEntry = @previousEntry
            @previousEntry.nextEntry = @nextEntry
        if !@nextEntry? and !@previousEntry?
            cacheHeadEntry = null
            cacheTailEntry = null
        if @nextEntry? and !@previousEntry?
            @nextEntry.previousEntry = null
            cacheTailEntry = @nextEntry
        if !@nextEntry? and @previousEntry?
            @previousEntry.nextEntry = null
            cacheHeadEntry = @previousEntry
        uncache(@id)
    
    toString: ->
        result = @id+"\n"
        if @nextEntry?
            result +="  next: "+@nextEntry.id+"\n"
        else
            result +="  next: null\n"
        if @previousEntry?
            result +="  previous: "+@previousEntry.id+"\n"
        else
            result += "  previous: null\n"
        return result

############################################################
#region internalFunctions
loadCache = (id) ->
    # if !cacheHeadEntry? and !cacheTailEntry? then log "cache is empty!"
    new CacheEntry(id)
    # if !cacheHeadEntry? or !cacheTailEntry? then log "cache has a problem!"

    { contentObj, contentJson } = saver.load(id)

    if contentObj?
        # log "received contentObj"
        jsonCache[id] = contentJson
        objCache[id] = contentObj
    else loadDefault(id)
    return

loadDefault = (id) ->
    if !defaultState? or !defaultState[id]?
        jsonCache[id] = "{}"
        objCache[id] = {}
    else
        jsonCache[id] = JSON.stringify(defaultState[id])
        objCache[id] = JSON.parse(jsonCache[id])
    return

############################################################
uncache = (id) ->
    delete objCache[id]
    delete jsonCache[id]
    delete idToCacheEntry[id]
    cacheSize--
    return

############################################################
cutCacheTail = ->
    tail = cacheTailEntry
    return unless tail?
    cacheTailEntry = tail.nextEntry
    if cacheTailEntry? then cacheTailEntry.previousEntry = null
    uncache(tail.id)
    return

#endregion

############################################################
#region exposedFunctions
export save = (id, contentObj) ->
    # log "save "+id
    if idToCacheEntry[id]? then idToCacheEntry[id].touch()
    else new CacheEntry(id)

    if contentObj then objCache[id] = contentObj
    contentJson = JSON.stringify(objCache[id])

    if contentJson == jsonCache[id] then return
    else
        jsonCache[id] = contentJson
        await saver.save(id, contentJson)
    return

export load = (id) ->
    # log "load "+id
    if !objCache[id]? then loadCache(id)
    else idToCacheEntry[id].touch()
    return objCache[id]

export remove = (id) ->
    # log "remove "+id
    entry = idToCacheEntry[id]
    return unless entry?
    entry.remove()
    await saver.remove(id)
    return

export logCacheState = ->
    logString = "cacheState:\n"
    if cacheHeadEntry?
        logString += "cacheHead Id: "+cacheHeadEntry.id+"\n"
        logString += cacheHeadEntry.toString()

        entry = cacheHeadEntry.previousEntry
        while(entry?)
            logString += entry.toString()
            entry = entry.previousEntry
        logString +="cacheTail Id: "+cacheTailEntry.id
        logString+= "\n"
    else logString += JSON.stringify({ cacheHeadEntry, cacheTailEntry})
    logString += "- - - - -\n"
    # logString += JSON.stringify({jsonCache})
    logString += JSON.stringify({cacheSize, maxCacheSize})
    log logString+"\n"

#endregion