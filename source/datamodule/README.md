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

getStockData(symbol) → DataSet
    # Returns fresh stock data, fetching if needed

getCommodityData(name) → DataSet
    # Returns available commodity data (no fetch)

# Configuration
setFreshnessThreshold(days)  # Default: 7
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
