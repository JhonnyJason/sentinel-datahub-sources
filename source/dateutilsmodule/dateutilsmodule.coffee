############################################################
# Date utilities for consistent date handling across modules
# All functions use UTC midnight to ensure consistent day boundaries
# Convention: date strings are "YYYY-MM-DD" format

############################################################
export isTradingHour = (date = new Date()) ->
    estHour = (date.getUTCHours() + 19) % 24
    estMinuteOfDay = estHour * 60 + date.getUTCMinutes()
    return estMinuteOfDay >= 420 and estMinuteOfDay < 960

export isPreTradingHour = (date = new Date()) ->
    estHour = (date.getUTCHours() + 19) % 24
    estMinuteOfDay = estHour * 60 + date.getUTCMinutes()
    return estMinuteOfDay > 360 and estMinuteOfDay < 420

export isPostTradingHour = (date = new Date()) ->
    estHour = (date.getUTCHours() + 19) % 24
    estMinuteOfDay = estHour * 60 + date.getUTCMinutes()
    return estMinuteOfDay >= 1080 # 6:00 PM EST through midnight


############################################################
# Check if a date is a trading day (not Saturday or Sunday)
# Accepts Date object or defaults to now
# NOTE: does not account for holidays yet - only weekends
export isTradingDay = (date = new Date()) ->
    day = date.getUTCDay()
    return day != 0 and day != 6

############################################################
# Get the most recent trading day as "YYYY-MM-DD" string
# If today is a trading day, returns today (useful for pre-trading checks)
# If today is Saturday/Sunday, walks back to Friday
# NOTE: does not account for holidays yet - only weekends
export lastTradingDay = (date = new Date()) ->
    d = new Date(Date.UTC(date.getUTCFullYear(), date.getUTCMonth(), date.getUTCDate()))
    while d.getUTCDay() == 0 or d.getUTCDay() == 6
        d.setUTCDate(d.getUTCDate() - 1)
    return d.toISOString().substring(0, 10)

############################################################
# Check if a "YYYY-MM-DD" date string is yesterday (UTC)
export isYesterday = (dateStr) ->
    now = new Date()
    yesterday = new Date(Date.UTC(now.getUTCFullYear(), now.getUTCMonth(), now.getUTCDate() - 1))
    return dateStr == yesterday.toISOString().substring(0, 10)

############################################################
export nextDay = (dateStr) ->
    d = new Date(dateStr + "T00:00:00Z")
    d.setUTCDate(d.getUTCDate() + 1)
    return d.toISOString().substring(0, 10)

############################################################
export prevDay = (dateStr) ->
    d = new Date(dateStr + "T00:00:00Z")
    d.setUTCDate(d.getUTCDate() - 1)
    return d.toISOString().substring(0, 10)

############################################################
export daysBetween = (startDate, endDate) ->
    start = new Date(startDate + "T00:00:00Z")
    end = new Date(endDate + "T00:00:00Z")
    return Math.floor((end - start) / (1000 * 60 * 60 * 24))

############################################################
# Generate array of date strings from start to end (inclusive)
export generateDateRange = (startDate, endDate) ->
    dates = []
    current = new Date(startDate + "T00:00:00Z")
    end = new Date(endDate + "T00:00:00Z")

    while current <= end
        dates.push(current.toISOString().substring(0, 10))
        current.setUTCDate(current.getUTCDate() + 1)

    return dates