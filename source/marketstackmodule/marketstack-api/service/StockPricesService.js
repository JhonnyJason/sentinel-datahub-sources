'use strict';


/**
 * Real-time Stock Market Prices
 * Real-time Stock Market Prices endpoint delivers instant access to live market data for stocks across major exchanges worldwide. Track intraday stock performance on `NYSE`, `NASDAQ`, `LON`, `WSE`, `EPA`, `SHE`, `NSE`, and much more.
 *
 * access_key String Your Marketstack API access key.
 * ticker String Ticker for which to retrieve the stock price (e.g., `AAPL`).
 * exchange String Optional exchange filter (e.g., `NASDAQ`). (optional)
 * returns StockPriceResponse
 **/
exports.stockpriceGET = function(access_key,ticker,exchange) {
  return new Promise(function(resolve, reject) {
    var examples = {};
    examples['application/json'] = {
  "data" : [ {
    "exchange_name" : "exchange_name",
    "country" : "country",
    "ticker" : "ticker",
    "price" : "price",
    "trade_last" : "trade_last",
    "currency" : "currency",
    "exchange_code" : "exchange_code"
  }, {
    "exchange_name" : "exchange_name",
    "country" : "country",
    "ticker" : "ticker",
    "price" : "price",
    "trade_last" : "trade_last",
    "currency" : "currency",
    "exchange_code" : "exchange_code"
  } ]
};
    if (Object.keys(examples).length > 0) {
      resolve(examples[Object.keys(examples)[0]]);
    } else {
      resolve();
    }
  });
}

