############################################################
#region debug
import { createLogFunctions } from "thingy-debug"
{log, olog} = createLogFunctions("livefeedmodule")
#endregion

############################################################
# symbol -> latest price
latestPrices = Object.create(null)
# symbol -> set of subscribed sockets
symbolToSubscribedSockets = Object.create(null)

############################################################
# Using a map here for mapping Socket references
# socket -> set of subscribed symbols
socketToSubscriptions = new Map()

############################################################
# Restrict Symbols to not cause problems :-) (prototype poisoning etc.)
allowedSymbols = new Set()

############################################################
export initialize = (c) ->
    log "initialize"
    if c.liveDataSymbols? 
        allowedSymbols.add(sym) for sym in c.liveDataSymbols 
    return

############################################################
notifySubscribers = (symbols) ->
    log "notifySubscribers"
    for symbol in symbols
        price = latestPrices[symbol]
        clientSockets = symbolToSubscribedSockets[symbol]
        continue unless clientSockets?
        message = "liveDataUpdate #{symbol} #{price}"
        for sock from clientSockets
            try sock.send(message)
            catch err then log "A certain socket could not be notified! #{err.message}"
    return

############################################################
export subscribeClientSocket = (socket, symbol) ->
    log "subscribeClientSocket"
    return false unless allowedSymbols.has(symbol)

    # Track what the socket is subscribed to
    subs = socketToSubscriptions.get(socket)
    if !subs?
        subs = new Set()
        socketToSubscriptions.set(socket, subs)
    subs.add(symbol)

    # Track what sockets need to be notified
    socks = symbolToSubscribedSockets[symbol]
    if !socks?
        socks = new Set()
        symbolToSubscribedSockets[symbol] = socks
    socks.add(socket)
    return true

############################################################
export unsubscribeSymbol = (socket, symbol) ->
    log "unsubscribeSymbol"
    subs = socketToSubscriptions.get(socket)
    return false unless subs? and subs.has(symbol)
    subs.delete(symbol)
    symbolToSubscribedSockets[symbol]?.delete(socket)
    if subs.size == 0 then socketToSubscriptions.delete(socket)
    return true

############################################################
# Remove all subscriptions for a socket (used on disconnect)
export unsubscribeClientSocket = (socket) ->
    log "unsubscribeClientSocket"
    subs = socketToSubscriptions.get(socket)
    if !subs? then return
    for subSym from subs
        symbolToSubscribedSockets[subSym].delete(socket)
    socketToSubscriptions.delete(socket)
    return

############################################################
export getClientSubscriptions = (socket) ->
    subs = socketToSubscriptions.get(socket)
    if !subs? then return []
    return Array.from(subs)


############################################################
# Called by marketstackmodule heartbeat with { symbol: price } map
export updatePrices = (prices) ->
    log "updatePrices"
    updatedSymbols = Object.create(null)

    for symbol, price of prices
        if latestPrices[symbol] != price then updatedSymbols[symbol] = true
        latestPrices[symbol] = price

    olog latestPrices

    notifySubscribers(Object.keys(updatedSymbols))
    return

############################################################
export getLatestPrice = (symbol) -> latestPrices[symbol] ? null