'use strict';


/**
 * EOD Data for a Specific Date
 * Specify a date in `YYYY-MM-DD` format. You can also specify an exact time in ISO-8601 date format. For example, `2020-05-21T00:00:00+0000`. Example, `/eod/2020-01-01`
 *
 * access_key String Your Marketstack API access key.
 * date date Specific date for EOD data. Format `YYYY-MM-DD`.
 * symbols String One or more comma-separated ticker symbols (e.g., `AAPL,MSFT`).
 * exchange String Filter your results based on a specific stock exchange by specifying the MIC identification of a stock exchange. (optional)
 * limit Integer Pagination limit (results per page). Default 100, maximum 1000. (optional)
 * offset Integer Pagination offset (number of results to skip). Default 0. (optional)
 * sort String Sort order. Use `ASC` for oldest first or `DESC` for newest first. (optional)
 * returns EODResponse
 **/
exports.eodDateGET = function(access_key,date,symbols,exchange,limit,offset,sort) {
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
    "split_factor" : 1.4894159,
    "symbol" : "symbol",
    "volume" : 3.6160767,
    "high" : 2.302136,
    "adj_open" : 1.2315135,
    "adj_high" : 2.027123,
    "adj_volume" : 1.0246457,
    "low" : 7.0614014,
    "name" : "name",
    "asset_type" : "asset_type",
    "dividend" : 6.846853,
    "adj_close" : 7.386282,
    "exchange" : "exchange",
    "exchange_code" : "exchange_code",
    "close" : 9.301444,
    "open" : 5.637377,
    "price_currency" : "price_currency",
    "adj_low" : 4.145608
  }, {
    "date" : "date",
    "split_factor" : 1.4894159,
    "symbol" : "symbol",
    "volume" : 3.6160767,
    "high" : 2.302136,
    "adj_open" : 1.2315135,
    "adj_high" : 2.027123,
    "adj_volume" : 1.0246457,
    "low" : 7.0614014,
    "name" : "name",
    "asset_type" : "asset_type",
    "dividend" : 6.846853,
    "adj_close" : 7.386282,
    "exchange" : "exchange",
    "exchange_code" : "exchange_code",
    "close" : 9.301444,
    "open" : 5.637377,
    "price_currency" : "price_currency",
    "adj_low" : 4.145608
  } ]
};
    if (Object.keys(examples).length > 0) {
      resolve(examples[Object.keys(examples)[0]]);
    } else {
      resolve();
    }
  });
}


/**
 * EOD Data
 * You can use the API's `eod` endpoint in order to obtain end-of-day data for one or multiple stock tickers. A single or multiple comma-separated ticker symbols are passed to the API using the `symbols` parameter.   **Note:**  * *The EOD data has access to over 500,000 tickers from more major world-known exchanges. The full list of supported tickers and exchanges can be seen here:* [**Download**](https://marketstack.com/download/v2_eod_tickers_finnworlds_tiingo.xlsx)  * *A daily updated list of all tickers accessible via Marketstack is available for download:* [**Download Ticker List**](https://marketstack.com/download/supported_tickers_2.csv)  * *The V2 EOD endpoint supports data from **30+ stock exchanges**, including **NASDAQ,** **PINK, SHG, NYSE, NYSE ARCA, OTCQB,** and **BATS***  * *To retrieve end-of-day data for individual tickers, you can also use the Tickers Endpoint.*  * ***Ticker Symbol Formatting:** When querying ticker symbols that include a period (.), replace the period with a hyphen (-) in the intraday endpoint. **Example:BRK.B → BRK-B***  **Adjusted Prices:** “**Adjusted**” prices represent stock values that have been modified to accurately reflect the impact of corporate actions such as splits and dividends. These adjustments are applied following the CRSP Calculations methodology established by the **Center for Research in Security Prices (CRSP).**
 *
 * access_key String Your Marketstack API access key.
 * symbols String One or more comma-separated ticker symbols (e.g., `AAPL,MSFT`).
 * exchange String Filter your results based on a specific stock exchange by specifying the MIC identification of a stock exchange. (optional)
 * date_from date Filter results from this date (inclusive). Format `YYYY-MM-DD`. (optional)
 * date_to date Filter results up to this date (inclusive). Format `YYYY-MM-DD`. (optional)
 * sort String Sort order. Use `ASC` for oldest first or `DESC` for newest first. (optional)
 * limit Integer Pagination limit (results per page). Default 100, maximum 1000. (optional)
 * offset Integer Pagination offset (number of results to skip). Default 0. (optional)
 * returns EODResponse
 **/
exports.eodGET = function(access_key,symbols,exchange,date_from,date_to,sort,limit,offset) {
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
    "split_factor" : 1.4894159,
    "symbol" : "symbol",
    "volume" : 3.6160767,
    "high" : 2.302136,
    "adj_open" : 1.2315135,
    "adj_high" : 2.027123,
    "adj_volume" : 1.0246457,
    "low" : 7.0614014,
    "name" : "name",
    "asset_type" : "asset_type",
    "dividend" : 6.846853,
    "adj_close" : 7.386282,
    "exchange" : "exchange",
    "exchange_code" : "exchange_code",
    "close" : 9.301444,
    "open" : 5.637377,
    "price_currency" : "price_currency",
    "adj_low" : 4.145608
  }, {
    "date" : "date",
    "split_factor" : 1.4894159,
    "symbol" : "symbol",
    "volume" : 3.6160767,
    "high" : 2.302136,
    "adj_open" : 1.2315135,
    "adj_high" : 2.027123,
    "adj_volume" : 1.0246457,
    "low" : 7.0614014,
    "name" : "name",
    "asset_type" : "asset_type",
    "dividend" : 6.846853,
    "adj_close" : 7.386282,
    "exchange" : "exchange",
    "exchange_code" : "exchange_code",
    "close" : 9.301444,
    "open" : 5.637377,
    "price_currency" : "price_currency",
    "adj_low" : 4.145608
  } ]
};
    if (Object.keys(examples).length > 0) {
      resolve(examples[Object.keys(examples)[0]]);
    } else {
      resolve();
    }
  });
}


/**
 * EOD Latest Data
 * Returns the most recent end-of-day data point for the requested symbols.
 *
 * access_key String Your Marketstack API access key.
 * symbols String One or more comma-separated ticker symbols (e.g., `AAPL,MSFT`).
 * exchange String Filter your results based on a specific stock exchange by specifying the MIC identification of a stock exchange. (optional)
 * sort String Sort order. Use `ASC` for oldest first or `DESC` for newest first. (optional)
 * limit Integer Pagination limit (results per page). Default 100, maximum 1000. (optional)
 * offset Integer Pagination offset (number of results to skip). Default 0. (optional)
 * returns EODResponse
 **/
exports.eodLatestGET = function(access_key,symbols,exchange,sort,limit,offset) {
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
    "split_factor" : 1.4894159,
    "symbol" : "symbol",
    "volume" : 3.6160767,
    "high" : 2.302136,
    "adj_open" : 1.2315135,
    "adj_high" : 2.027123,
    "adj_volume" : 1.0246457,
    "low" : 7.0614014,
    "name" : "name",
    "asset_type" : "asset_type",
    "dividend" : 6.846853,
    "adj_close" : 7.386282,
    "exchange" : "exchange",
    "exchange_code" : "exchange_code",
    "close" : 9.301444,
    "open" : 5.637377,
    "price_currency" : "price_currency",
    "adj_low" : 4.145608
  }, {
    "date" : "date",
    "split_factor" : 1.4894159,
    "symbol" : "symbol",
    "volume" : 3.6160767,
    "high" : 2.302136,
    "adj_open" : 1.2315135,
    "adj_high" : 2.027123,
    "adj_volume" : 1.0246457,
    "low" : 7.0614014,
    "name" : "name",
    "asset_type" : "asset_type",
    "dividend" : 6.846853,
    "adj_close" : 7.386282,
    "exchange" : "exchange",
    "exchange_code" : "exchange_code",
    "close" : 9.301444,
    "open" : 5.637377,
    "price_currency" : "price_currency",
    "adj_low" : 4.145608
  } ]
};
    if (Object.keys(examples).length > 0) {
      resolve(examples[Object.keys(examples)[0]]);
    } else {
      resolve();
    }
  });
}

