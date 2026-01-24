# MarketStack Module

## Purpose
Retrieves historical EOD (End-of-Day) price data from MarketStack API for stocks and commodities.

## API Reference (Relevant Endpoints Only)

### Stock EOD Data
```
GET /eod
  ?access_key=<key>
  &symbols=GOOG,AAPL          # comma-separated tickers
  &date_from=YYYY-MM-DD       # optional
  &date_to=YYYY-MM-DD         # optional
  &limit=1000                 # max 1000
  &offset=0                   # for pagination
  &sort=ASC|DESC
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
      "adj_open": 150.00,
      "adj_high": 152.50,
      "adj_low": 149.00,
      "adj_close": 151.75,
      "adj_volume": 1234567,
      "exchange": "XNAS",
      "price_currency": "usd"
    }
  ]
}
```

**Notes:**
- Ticker symbols with `.` must use `-` instead (e.g., `BRK.B` → `BRK-B`)
- 500,000+ tickers available from 30+ exchanges
- No special rate limit (beyond plan limits)

### Commodity Historical Data
```
GET /commoditieshistory
  ?access_key=<key>
  &commodity_name=gold        # single commodity name
  &date_from=YYYY-MM-DD       # optional
  &date_to=YYYY-MM-DD         # optional
  &frequency=daily|weekly|monthly|quarterly|yearly
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

**Notes:**
- **Rate limit: 1 call per minute!**
- Recommended: Request max 1 year of daily data per call
- Up to 15 years of historical data (varies by commodity)
- 70+ commodities (metals, energy, industrial, agricultural, livestock)
- Only provides single price point (no OHLC)

## NOT Available in MarketStack
- **Forex / Currency exchange rates** - `/currencies` only lists currency metadata
- Alternative sources for forex: Tradovate API, histdata.com (free downloads)

## Our Normalized Data Format

Both stock EOD and commodity data are normalized to an efficient array-based structure:

```
DataPoint: [high, low, close]  // array of 3 floats

DataSet: {
  meta: { startDate: "YYYY-MM-DD", endDate: "YYYY-MM-DD", interval: "1d" },
  data: [DataPoint, DataPoint, ...]  // index 0 = startDate
}

Storage: { "<symbol>": DataSet, ... }
// e.g. "GOOG/usd": { meta: {...}, data: [...] }
```

**Design rationale:**
- Array format minimizes memory and JSON size
- Symbol stored once per DataSet, not per DataPoint
- Date computed from index: `date = startDate + (index * interval)`
- Contiguous data guaranteed via gap-filling

**Normalization Rules:**
- Stocks (OHLC available): Extract `high`, `low`, `close` → `[h, l, c]`
- Commodities (single price): Use price for all three → `[price, price, price]`
- Gap-fill: Missing days → `[lastClose, lastClose, lastClose]`
- Symbol format: `{asset}/{quote_currency}` for uniform addressing

## Files

- `marketstackmodule.coffee` - API client implementation
- `marketstack-api/` - Auto-generated API reference (from OpenAPI spec, mostly unused)
- `marketstack-api/api/openapi.yaml` - Full API specification (reference only)
