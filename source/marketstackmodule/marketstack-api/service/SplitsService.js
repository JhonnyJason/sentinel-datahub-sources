'use strict';


/**
 * Splits Data
 * Using the Splits Data endpoint, you will be able to look up information about the stock splits factor for different symbols.   **Note:** The V2 Splits Endpoint provides split data for symbols listed on **NASDAQ, PINK, SHG, NYSE, NYSE ARCA, OTCQB,** and **BATS**. You can also retrieve split information for individual ticker symbols using the Tickers Endpoint.
 *
 * access_key String Your Marketstack API access key.
 * symbols String One or more comma-separated ticker symbols (e.g., `AAPL,MSFT`).
 * date_from date Filter results from this date (inclusive). Format `YYYY-MM-DD`. (optional)
 * date_to date Filter results up to this date (inclusive). Format `YYYY-MM-DD`. (optional)
 * sort String Sort order. Use `ASC` for oldest first or `DESC` for newest first. (optional)
 * limit Integer Pagination limit (results per page). Default 100, maximum 1000. (optional)
 * offset Integer Pagination offset (number of results to skip). Default 0. (optional)
 * returns SplitsResponse
 **/
exports.splitsGET = function(access_key,symbols,date_from,date_to,sort,limit,offset) {
  return new Promise(function(resolve, reject) {
    var examples = {};
    examples['application/json'] = {
  "pagination" : {
    "total" : 5,
    "offset" : 6,
    "limit" : 0,
    "count" : 1
  },
  "data" : [ {
    "date" : "date",
    "symbol" : "symbol",
    "split_factor" : 0.8008282
  }, {
    "date" : "date",
    "symbol" : "symbol",
    "split_factor" : 0.8008282
  } ]
};
    if (Object.keys(examples).length > 0) {
      resolve(examples[Object.keys(examples)[0]]);
    } else {
      resolve();
    }
  });
}

