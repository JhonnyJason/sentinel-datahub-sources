'use strict';


/**
 * Intraday Data for a Specific Date
 * Specify a date in `YYYY-MM-DD` format. You can also specify an exact time in ISO-8601 date format. For example, `2020-05-21T00:00:00+0000`. Example, `/intraday/2020-01-01`
 *
 * access_key String Your Marketstack API access key.
 * date String Specific date for intraday data. Example `2024-09-27 15:30`.
 * symbols String One or more comma-separated ticker symbols (e.g., `AAPL,MSFT`).
 * interval String Intraday aggregation interval. (optional)
 * exchange String Filter your results based on a specific stock exchange by specifying the MIC identification of a stock exchange. (optional)
 * limit Integer Pagination limit (results per page). Default 100, maximum 1000. (optional)
 * offset Integer Pagination offset (number of results to skip). Default 0. (optional)
 * after_hours Boolean If set to true, includes pre and post market data if available. By default is set to false. (optional)
 * returns IntradayResponse
 **/
exports.intradayDateGET = function(access_key,date,symbols,interval,exchange,limit,offset,after_hours) {
  return new Promise(function(resolve, reject) {
    var examples = {};
    examples['application/json'] = {
  "pagination" : {
    "total" : 5,
    "offset" : 6,
    "limit" : 0,
    "count" : 1
  },
  "data" : [ "", "" ]
};
    if (Object.keys(examples).length > 0) {
      resolve(examples[Object.keys(examples)[0]]);
    } else {
      resolve();
    }
  });
}


/**
 * Intraday Data
 * In additional to daily end-of-day stock prices, the Marketstack API also supports intraday data with data intervals as short as one minute. Intraday prices are available for all US stock tickers included in the IEX (Investors Exchange) stock exchange.  To access intraday market data, use the API’s Intraday Endpoint and specify your desired stock ticker symbols.  **Notes:**  * *A daily updated list of all tickers accessible via Marketstack is available for download:[**Download Ticker List**](https://marketstack.com/download/supported_tickers_2.csv)*  * *You can also request intraday data for **individual ticker symbols** using the **Tickers Endpoint.***  * ***Ticker Symbol Formatting:** When querying ticker symbols that include a period (.), replace the period with a hyphen (-) when using the Intraday Endpoint. **Example:** BRK.B → BRK-B*  **IMPORTANT NOTE:** In the case of Intraday, Marketstack provides derived data that calculates a real-time reference price for each asset. While this is not a substitute for the TOPS Feed, we believe it will fulfill the needs of 95% of our customer base.  We’re doing so because as of **February 1st, 2025**, the IEX Exchange has changed its market data policies. To receive the FULL TOPS Feed, you must now have a market data agreement signed with the IEX Exchange. This means that the parameters bidPrice, bidSize, askPrice, askSize, lastPrice, lastSize, mid, and last will all return NULL in the API response for intraday since **IEX entitlement is required** for them. If you still need to have access to TOPS Feed, please contact our customer support team before signing any contract with them.  For using our derived data, there is no need to have a market data agreement signed with the IEX exchange, and there is no additional cost to the IEX Exchange.`
 *
 * access_key String Your Marketstack API access key.
 * symbols String One or more comma-separated ticker symbols (e.g., `AAPL,MSFT`).
 * interval String Intraday aggregation interval. (optional)
 * exchange String Filter your results based on a specific stock exchange by specifying the MIC identification of a stock exchange. (optional)
 * date_from date Filter results from this date (inclusive). Format `YYYY-MM-DD`. (optional)
 * date_to date Filter results up to this date (inclusive). Format `YYYY-MM-DD`. (optional)
 * sort String Sort order. Use `ASC` for oldest first or `DESC` for newest first. (optional)
 * limit Integer Pagination limit (results per page). Default 100, maximum 1000. (optional)
 * offset Integer Pagination offset (number of results to skip). Default 0. (optional)
 * after_hours Boolean If set to true, includes pre and post market data if available. By default is set to false. (optional)
 * returns IntradayResponse
 **/
exports.intradayGET = function(access_key,symbols,interval,exchange,date_from,date_to,sort,limit,offset,after_hours) {
  return new Promise(function(resolve, reject) {
    var examples = {};
    examples['application/json'] = {
  "pagination" : {
    "total" : 5,
    "offset" : 6,
    "limit" : 0,
    "count" : 1
  },
  "data" : [ "", "" ]
};
    if (Object.keys(examples).length > 0) {
      resolve(examples[Object.keys(examples)[0]]);
    } else {
      resolve();
    }
  });
}


/**
 * Intraday Latest Data
 * Returns the most recent intraday bar for the requested symbols.  **Real-Time Updates:** Please note that data frequency intervals below 15 minutes (15min) are only supported if you are subscribed to the Professional Plan or higher.  US equity markets close at **4:00 PM EST**, with trades at or after this time considered after-hours (retrievable with `after_hours=true`), though IEX after-hours data may be sparse, and note that intraday closing prices differ from official EOD closes, which are set via an auction process [Investopedia](https://www.investopedia.com/articles/investing/091113/auction-method-how-nyse-stock-prices-are-set.asp)
 *
 * access_key String Your Marketstack API access key.
 * symbols String One or more comma-separated ticker symbols (e.g., `AAPL,MSFT`).
 * interval String Intraday aggregation interval. (optional)
 * exchange String Filter your results based on a specific stock exchange by specifying the MIC identification of a stock exchange. (optional)
 * after_hours Boolean If set to true, includes pre and post market data if available. By default is set to false. (optional)
 * returns IntradayResponse
 **/
exports.intradayLatestGET = function(access_key,symbols,interval,exchange,after_hours) {
  return new Promise(function(resolve, reject) {
    var examples = {};
    examples['application/json'] = {
  "pagination" : {
    "total" : 5,
    "offset" : 6,
    "limit" : 0,
    "count" : 1
  },
  "data" : [ "", "" ]
};
    if (Object.keys(examples).length > 0) {
      resolve(examples[Object.keys(examples)[0]]);
    } else {
      resolve();
    }
  });
}

