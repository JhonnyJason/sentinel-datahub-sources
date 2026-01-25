# Data Module

## Purpose
Central data layer that serves historical price data to API endpoints. Manages data freshness and coordinates with external API modules.

---

## Data Flow

```
Client Request → API Endpoint → DataModule → Response
                                    │
                                    ├─ Fresh data available? → return it
                                    │
                                    └─ Stale/missing? → fetch → store → return
```

---

## Freshness Strategy

### Stocks (Pull Model)
DataModule actively manages stock data freshness:

| Situation | Action |
|-----------|--------|
| **Fresh data** (within threshold) | Return cached data immediately |
| **Stale data** (older than threshold) | Top-up via `getStockNewerHistory()`, then return |
| **No data** for symbol | Full fetch via `getStockAllHistory()`, then return |

**Freshness threshold:** Configurable parameter (default: 7 days)
- For EOD data, "fresh" means data includes a recent trading day
- Threshold defines max acceptable gap between last data point and today
- Can be adjusted based on use case (pattern analysis tolerates larger gaps)

### Commodities (Push Model)
DataModule is passive for commodities:
- Returns whatever data the heartbeat has gathered so far
- No active fetching on request
- Background heartbeat continuously fills gaps (managed by MarketStackModule)

---

## Exports

```
initialize(config)
    # sets configured freshnessThreshold (default: 5)

getData(name) → DataSet
    # Allmighty data retrieval, checks name if it is a commodity, a forexPair or a stock symbol
    # Retrieves available data and loads more data if it is reasonable to do so (e.g. for stock data)

```

---

## Storage

Uses `cached-persistentstate` for durable storage:
- Data survives service restarts
- Symbol-keyed storage: `{ "<symbol>": DataSet, ... }`

---

## Implementation Tasks

```
[ ] initialize(config) - setup storage, configure threshold
[ ] getStockData(symbol) - freshness check, fetch if needed, return
[ ] getCommodityData(name) - return stored data
[ ] Storage integration with cached-persistentstate
[ ] Freshness threshold configuration
```

---

## Data Format

All data uses the unified format (see overview.md):

```
DataPoint: [high, low, close]  // 3 floats

DataSet: {
  meta: { startDate: "YYYY-MM-DD", endDate: "YYYY-MM-DD", interval: "1d" },
  data: [DataPoint, ...]  // index 0 = startDate, contiguous
}
```

**Date handling convention:**
- All date arithmetic uses UTC midnight: `new Date(dateStr + "T00:00:00Z")`
- Never use `new Date(dateStr)` alone — causes timezone-dependent off-by-one errors
