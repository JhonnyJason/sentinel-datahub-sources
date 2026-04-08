############################################################
# RequestGuard manages a Throttled Request Queue
# Keeps timeframe parameters + only uses GET requests
# Strategy: allows bursts of "maxPerWindow" requests then waits to complete the timewindow before any further request
# Deduplication: identical URLs are coalesced — fetched once, result shared

############################################################
waitMS = (ms) -> new Promise((res) -> setTimeout(res, ms))

############################################################
export class RequestGuard
    constructor: (opts) ->
        if !opts.maxPerWindow or !opts.windowMS 
            throw new Error("RequestGuard.constructor: maxPerWindow and windowMS must be defined in the options!")
        
        @isBusy = false
        @windowStart = 0
        @windowCount = 0
        @maxPerWindow = opts.maxPerWindow
        @windowMS = opts.windowMS
        
        @queue = []
        @pending = new Map()  # url → [{resolve, reject}, ...]

    processQueue: => 
        return if @isBusy or @queue.length == 0
        @isBusy = true

        while @queue.length > 0
            # Start new measurement window
            if @windowCount == 0
                @windowStart = performance.now()

            @windowCount++
            url = @queue.shift()
            waiters = @pending.get(url)

            try
                response = await fetch(url)
                if !response.ok
                    text = await response.text()
                    throw new Error("HTTP #{response.status}: #{text.slice(0, 200)}")
                
                body = await response.json()
                @pending.delete(url)
                w.resolve(body) for w in waiters
            catch err
                @pending.delete(url)
                w.reject(err) for w in waiters

            # After maxPerWindow requests, check if we need to slow down
            if @windowCount >= @maxPerWindow
                elapsed = performance.now() - @windowStart
                remaining = @windowMS - elapsed
                if remaining > 0 then await waitMS(remaining)
                @windowCount = 0

        @isBusy = false
        return

    request: (url) =>
        promFun = (resolve, reject) =>
            if @pending.has(url)
                @pending.get(url).push({ resolve, reject })
                return
            @pending.set(url, [{ resolve, reject }])
            @queue.push(url)

        prom = new Promise(promFun) 
        @processQueue() unless @isBusy
        return prom

