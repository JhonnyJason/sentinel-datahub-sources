# MarketStack Module

## Purpose
Retrieves historical EOD (End-of-Day) price data from MarketStack API for stocks and commodities.

---

## Architecture

Two different retrieval models due to API rate limit constraints:

| | Stocks | Commodities |
|---|--------|-------------|
| **Model** | Pull (on-demand) | Push (heartbeat) |
| **Flow** | DataModule → MarketStack → Response | MarketStack → notifies → DataModule |
| **Trigger** | DataModule requests data | Internal timer (60s+) |
| **Rate limit** | 5 req/s (fast) | 1 req/min (slow) |

---

## Exports

### Shared
```
initialize(config)  # API key, base URL from configmodule
```

### Stocks (Pull Model)
```
getStockAllHistory(ticker) → Result
    # Get all available history (oldest → today)

getStockOlderHistory(ticker, olderThan) → Result
    # Get history older than date (oldest → olderThan)

getStockNewerHistory(ticker, newerThan) → Result
    # Get history newer than date (newerThan → today)

Result: {
  dataSet: DataSet | null,       # Gap-filled data (null if nothing retrieved)
  reachedHistoryStart: boolean,  # True = got all available, no more exists
  reachedPlanLimit: boolean      # True = plan restricts older data access
}
```

### Commodities (Push/Heartbeat Model)
```
startCommodityHeartbeat(config)
    config: {
      commodities: [
        { name: "gold", hasDataFrom: "2010-01-01", hasDataUntil: "2024-01-15" },
        { name: "silver", hasDataFrom: null, hasDataUntil: null },  # nothing yet
        ...
      ],
      onData: fn(name, dataSet, meta),   # called when data chunk arrives
      onComplete: fn(name),              # called when commodity fully loaded
    }

stopCommodityHeartbeat()
```

**Heartbeat behavior:**
1. Round-robin through configured commodities
2. Prioritize older history over newer updates
3. Fetch one chunk per heartbeat (respecting 60s rate limit)
4. Call `onData` with each received chunk
5. Track internal state of what's missing per commodity
6. Call `onComplete` when a commodity is fully loaded

**Initial load estimate:** ~50 commodities × ~15 year-chunks = ~750 requests = ~12.5 hours (one-time)

---

## Implementation Tasks

```
Stocks:
[ ] getStockAllHistory(ticker) - fetch /eod with pagination, normalize, gap-fill
[ ] getStockOlderHistory(ticker, olderThan) - same, bounded date range
[ ] getStockNewerHistory(ticker, newerThan) - same, bounded date range
[ ] detectHistoryStart - recognize when API has no older data
[ ] detectPlanLimit - recognize plan restriction errors

Commodities:
[ ] startCommodityHeartbeat(config) - init state, start interval
[ ] stopCommodityHeartbeat() - clear interval
[ ] heartbeat tick logic - pick next commodity, decide older/newer, fetch
[ ] internal state management - track what's missing per commodity

Shared:
[ ] normalizeStockResponse(apiData) → DataSet
[ ] normalizeCommodityResponse(apiData) → DataSet
[ ] gapFill(data[], startDate, endDate) → contiguous data[]
```

---

## API Reference

### Stock EOD Data
```
GET /eod
  ?access_key=<key>
  &symbols=GOOG,AAPL          # comma-separated tickers
  &date_from=YYYY-MM-DD       # optional
  &date_to=YYYY-MM-DD         # optional
  &limit=1000                 # max 1000
  &offset=0                   # for pagination
  &sort=ASC|DESC              # default DESC (newest first)
```

**Response:**
```json
{
  "pagination": { "total": 500, "limit": 1000, "offset": 0, "count": 500 },
  "data": [
    {
      "date": "2024-01-15",
      "symbol": "GOOG",
      "open": 150.00,
      "high": 152.50,
      "low": 149.00,
      "close": 151.75,
      "volume": 1234567,
      "exchange": "XNAS",
      "price_currency": "usd"
    }
  ]
}
```

**Pagination:** When `total > limit`, fetch additional pages with `offset += limit` until all data retrieved.

**Quirks:**
- Ticker symbols with `.` must use `-` instead (e.g., `BRK.B` → `BRK-B`)
- Multi-symbol requests return **interleaved** data (must group by symbol)
- Default sort is DESC - use `sort=ASC` for chronological order
- No special rate limit (beyond plan limits)

---

### Commodity Historical Data
```
GET /commoditieshistory
  ?access_key=<key>
  &commodity_name=gold        # single commodity name (lowercase)
  &date_from=YYYY-MM-DD
  &date_to=YYYY-MM-DD
  &frequency=daily            # daily|weekly|monthly|quarterly|yearly
```

**Response:**
```json
{
  "result": {
    "basics": { "frequency": "daily" },
    "data": [
      {
        "commodity_name": "gold",
        "commodity_unit": "USD/t oz.",
        "commodity_prices": [
          { "date": "2024-01-15", "commodity_price": "2025.50" },
          { "date": "2024-01-14", "commodity_price": "2018.30" }
        ]
      }
    ]
  }
}
```

**⚠️ CRITICAL: Rate limit 1 call per minute!**

**Quirks:**
- `commodity_price` is a **string** - must `parseFloat()`
- Recommended: Max 1 year of daily data per request
- Up to 15 years history (varies by commodity type)
- Only single price point (no OHLC) → normalize as `[price, price, price]`
- Full commodity list: https://marketstack.com/download/marketstack-commodities.xlsx

---

### Error Response
All endpoints return errors in this format:
```json
{
  "error": {
    "code": "validation_error",
    "message": "Description of the error"
  }
}
```

---

## NOT Available in MarketStack
- **Forex / Currency exchange rates** - `/currencies` only lists currency metadata
- Alternative sources for forex: Tradovate API, histdata.com (free downloads)

---

## Output Data Format

All data normalized to:
```
DataPoint: [high, low, close]  // 3 floats

DataSet: {
  meta: { startDate: "YYYY-MM-DD", endDate: "YYYY-MM-DD", interval: "1d" },
  data: [DataPoint, ...]  // index 0 = startDate, contiguous (gap-filled)
}

Return: { "<symbol>/<currency>": DataSet, ... }
```

**Gap-fill rule:** Missing trading days → `[lastClose, lastClose, lastClose]`

**Date handling convention:**
- All date arithmetic uses UTC midnight: `new Date(dateStr + "T00:00:00Z")`
- Never use `new Date(dateStr)` alone — causes timezone-dependent off-by-one errors

---

## Files
- `marketstackmodule.coffee` - Implementation
- `marketstack-api/api/openapi.yaml` - Full API spec (reference)
