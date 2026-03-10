############################################################
#region Throttled Request Queue
# MarketStack rate limit: 5 requests/second
# Strategy: allow bursts of 5, only wait if the burst was faster than 1s
# Deduplication: identical URLs are coalesced — fetched once, result shared

queue = []
pending = new Map()  # url → [{resolve, reject}, ...]
processing = false
windowStart = 0
windowCount = 0
maxPerWindow = 5
windowMS = 1001  # 1s + 1ms safety margin

requestQueue = (url) ->
    new Promise (resolve, reject) ->
        if pending.has(url)
            pending.get(url).push({ resolve, reject })
            return
        pending.set(url, [{ resolve, reject }])
        queue.push(url)
        processQueue() unless processing

processQueue = ->
    return if processing or queue.length == 0
    processing = true

    while queue.length > 0
        # Start new measurement window
        if windowCount == 0
            windowStart = performance.now()

        windowCount++
        url = queue.shift()
        waiters = pending.get(url)

        try
            response = await fetch(url)
            unless response.ok
                text = await response.text()
                throw new Error("HTTP #{response.status}: #{text.slice(0, 200)}")
            body = await response.json()
            pending.delete(url)
            w.resolve(body) for w in waiters
        catch err
            pending.delete(url)
            w.reject(err) for w in waiters

        # After 5 requests, check if we need to slow down
        if windowCount >= maxPerWindow
            elapsed = performance.now() - windowStart
            remaining = windowMS - elapsed
            if remaining > 0 then await waitMS(remaining)
            windowCount = 0

    processing = false
    return

#endregion

############################################################
waitMS = (ms) -> new Promise((res) -> setTimeout(res, ms))
