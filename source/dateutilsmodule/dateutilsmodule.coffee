############################################################
# Date utilities for consistent date handling across modules
# All functions use UTC midnight to ensure consistent day boundaries
# Convention: date strings are "YYYY-MM-DD" format

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