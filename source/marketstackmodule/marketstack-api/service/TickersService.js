'use strict';


/**
 * Tickers Info
 * Using the `tickerinfo` endpoint you will be able to get the full information about a ticker.
 *
 * access_key String Your Marketstack API access key.
 * ticker String One or more comma-separated ticker symbols (e.g., `AAPL,MSFT`).
 * returns TickerInfoResponse
 **/
exports.tickerinfoGET = function(access_key,ticker) {
  return new Promise(function(resolve, reject) {
    var examples = {};
    examples['application/json'] = {
  "data" : {
    "incorporation" : "incorporation",
    "ticker" : "ticker",
    "website" : "website",
    "address" : {
      "city" : "city",
      "street1" : "street1",
      "street2" : "street2",
      "state_or_country_description" : "state_or_country_description",
      "postal_code" : "postal_code",
      "stateOrCountry" : "stateOrCountry"
    },
    "start_fiscal" : "start_fiscal",
    "stock_exchanges" : [ {
      "exchange_name" : "exchange_name",
      "country" : "country",
      "website" : "website",
      "city" : "city",
      "exchange_mic" : "exchange_mic",
      "acronym1" : "acronym1",
      "alpha2_code" : "alpha2_code"
    }, {
      "exchange_name" : "exchange_name",
      "country" : "country",
      "website" : "website",
      "city" : "city",
      "exchange_mic" : "exchange_mic",
      "acronym1" : "acronym1",
      "alpha2_code" : "alpha2_code"
    } ],
    "item_type" : "item_type",
    "full_time_employees" : "full_time_employees",
    "about" : "about",
    "key_executives" : [ {
      "exercised" : "exercised",
      "function" : "function",
      "name" : "name",
      "salary" : "salary",
      "birth_year" : "birth_year"
    }, {
      "exercised" : "exercised",
      "function" : "function",
      "name" : "name",
      "salary" : "salary",
      "birth_year" : "birth_year"
    } ],
    "industry" : "industry",
    "ipo_date" : "ipo_date",
    "end_fiscal" : "end_fiscal",
    "vision" : "vision",
    "mission" : "mission",
    "reporting_currency" : "reporting_currency",
    "incorporation_description" : "incorporation_description",
    "phone" : "phone",
    "name" : "name",
    "exchange_code" : "exchange_code",
    "previous_names" : [ "previous_names", "previous_names" ],
    "date_founded" : "date_founded",
    "sector" : "sector"
  }
};
    if (Object.keys(examples).length > 0) {
      resolve(examples[Object.keys(examples)[0]]);
    } else {
      resolve();
    }
  });
}


/**
 * Dividends Data for a Specific Ticker
 * Obtain ticker dividend data for a specific stock ticker by attaching `/dividends` to your URL.
 *
 * access_key String Your Marketstack API access key.
 * symbol String Ticker symbol to look up (e.g., `AAPL`).
 * exchange String Filter your results based on a specific stock exchange by specifying the MIC identification of a stock exchange. (optional)
 * limit Integer Pagination limit (results per page). Default 100, maximum 1000. (optional)
 * offset Integer Pagination offset (number of results to skip). Default 0. (optional)
 * date_from date Filter results from this date (inclusive). Format `YYYY-MM-DD`. (optional)
 * date_to date Filter results up to this date (inclusive). Format `YYYY-MM-DD`. (optional)
 * sort String Sort order. Use `ASC` for oldest first or `DESC` for newest first. (optional)
 * returns TickerDividendsResponse
 **/
exports.tickersSymbolDividendsGET = function(access_key,symbol,exchange,limit,offset,date_from,date_to,sort) {
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
    "declaration_date" : "declaration_date",
    "symbol" : "symbol",
    "record_date" : "record_date",
    "distr_freq" : "distr_freq",
    "dividend" : 0.8008282,
    "payment_date" : "payment_date"
  }, {
    "date" : "date",
    "declaration_date" : "declaration_date",
    "symbol" : "symbol",
    "record_date" : "record_date",
    "distr_freq" : "distr_freq",
    "dividend" : 0.8008282,
    "payment_date" : "payment_date"
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
 * EOD Data for a Specific Ticker on a Specific Date
 * Specify a date in `YYYY-MM-DD` format. You can also specify an exact time in ISO-8601 date format. For example, `2020-05-21T00:00:00+0000`. Example, `/eod/2020-01-01`.
 *
 * access_key String Your Marketstack API access key.
 * symbol String Ticker symbol to look up (e.g., `AAPL`).
 * date String date to look at (e.g., `2020-01-01`).
 * exchange String Filter your results based on a specific stock exchange by specifying the MIC identification of a stock exchange. (optional)
 * limit Integer Pagination limit (results per page). Default 100, maximum 1000. (optional)
 * offset Integer Pagination offset (number of results to skip). Default 0. (optional)
 * returns EODBar
 **/
exports.tickersSymbolEodDateGET = function(access_key,symbol,date,exchange,limit,offset) {
  return new Promise(function(resolve, reject) {
    var examples = {};
    examples['application/json'] = {
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
};
    if (Object.keys(examples).length > 0) {
      resolve(examples[Object.keys(examples)[0]]);
    } else {
      resolve();
    }
  });
}


/**
 * EOD Data for a Specific Ticker
 * Obtain end-of-day data for a specific stock ticker by attaching `/eod` to your URL.
 *
 * access_key String Your Marketstack API access key.
 * symbol String Ticker symbol to look up (e.g., `AAPL`).
 * exchange String Filter your results based on a specific stock exchange by specifying the MIC identification of a stock exchange. (optional)
 * limit Integer Pagination limit (results per page). Default 100, maximum 1000. (optional)
 * offset Integer Pagination offset (number of results to skip). Default 0. (optional)
 * returns TickerEodResponse
 **/
exports.tickersSymbolEodGET = function(access_key,symbol,exchange,limit,offset) {
  return new Promise(function(resolve, reject) {
    var examples = {};
    examples['application/json'] = {
  "pagination" : {
    "total" : 5,
    "offset" : 6,
    "limit" : 0,
    "count" : 1
  },
  "data" : {
    "symbol" : "symbol",
    "country" : "country",
    "has_intraday" : true,
    "name" : "name",
    "has_eod" : true,
    "eod" : [ {
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
  }
};
    if (Object.keys(examples).length > 0) {
      resolve(examples[Object.keys(examples)[0]]);
    } else {
      resolve();
    }
  });
}


/**
 * EOD Data for the Latest Date Available for a Specific Ticker
 * Obtain eod data for the latest date by specifying stock ticker by attaching `/eod/latest` to your URL.
 *
 * access_key String Your Marketstack API access key.
 * symbol String Ticker symbol to look up (e.g., `AAPL`).
 * exchange String Filter your results based on a specific stock exchange by specifying the MIC identification of a stock exchange. (optional)
 * limit Integer Pagination limit (results per page). Default 100, maximum 1000. (optional)
 * offset Integer Pagination offset (number of results to skip). Default 0. (optional)
 * returns EODBar
 **/
exports.tickersSymbolEodLatestGET = function(access_key,symbol,exchange,limit,offset) {
  return new Promise(function(resolve, reject) {
    var examples = {};
    examples['application/json'] = {
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
};
    if (Object.keys(examples).length > 0) {
      resolve(examples[Object.keys(examples)[0]]);
    } else {
      resolve();
    }
  });
}


/**
 * Ticker Information
 * Using the API's Tickers endpoint you will be able to look up information about one or multiple stock ticker symbols as well as obtain end-of-day, real-time and intraday market data for single tickers.
 *
 * access_key String Your Marketstack API access key.
 * symbol String Ticker symbol to look up (e.g., `AAPL`).
 * exchange String Filter your results based on a specific stock exchange by specifying the MIC identification of a stock exchange. (optional)
 * limit Integer Pagination limit (results per page). Default 100, maximum 1000. (optional)
 * offset Integer Pagination offset (number of results to skip). Default 0. (optional)
 * returns TickerResponse
 **/
exports.tickersSymbolGET = function(access_key,symbol,exchange,limit,offset) {
  return new Promise(function(resolve, reject) {
    var examples = {};
    examples['application/json'] = {
  "symbol" : "symbol",
  "cusip" : "cusip",
  "cik" : "cik",
  "stock_exchange" : {
    "operating_mic" : "operating_mic",
    "country" : "country",
    "date_last_update" : {
      "date" : "date",
      "timezone" : "timezone",
      "timezone_type" : 6
    },
    "website" : "website",
    "comments" : "comments",
    "acronym" : "acronym",
    "city" : "city",
    "mic" : "mic",
    "exchange_lei" : "exchange_lei",
    "oprt_sgmt" : "oprt_sgmt",
    "date_creation" : {
      "date" : "date",
      "timezone" : "timezone",
      "timezone_type" : 0
    },
    "date_last_validation" : {
      "date" : "date",
      "timezone" : "timezone",
      "timezone_type" : 1
    },
    "country_code" : "country_code",
    "market_category_code" : "market_category_code",
    "name" : "name",
    "legal_entity_name" : "legal_entity_name",
    "exchange_status" : "exchange_status",
    "date_expiry" : "date_expiry"
  },
  "item_type" : "item_type",
  "ein_employer_id" : "ein_employer_id",
  "industry" : "industry",
  "sic_name" : "sic_name",
  "series_id" : "series_id",
  "lei" : "lei",
  "sic_code" : "sic_code",
  "name" : "name",
  "sector" : "sector",
  "isin" : "isin"
};
    if (Object.keys(examples).length > 0) {
      resolve(examples[Object.keys(examples)[0]]);
    } else {
      resolve();
    }
  });
}


/**
 * Intraday Data for a Specific Ticker
 * Obtain real-time & intraday data for a specific stock ticker by attaching `/intraday` to your URL
 *
 * access_key String Your Marketstack API access key.
 * symbol String Ticker symbol to look up (e.g., `AAPL`).
 * interval String Intraday aggregation interval. (optional)
 * exchange String Filter your results based on a specific stock exchange by specifying the MIC identification of a stock exchange. (optional)
 * date_from date Filter results from this date (inclusive). Format `YYYY-MM-DD`. (optional)
 * date_to date Filter results up to this date (inclusive). Format `YYYY-MM-DD`. (optional)
 * sort String Sort order. Use `ASC` for oldest first or `DESC` for newest first. (optional)
 * limit Integer Pagination limit (results per page). Default 100, maximum 1000. (optional)
 * offset Integer Pagination offset (number of results to skip). Default 0. (optional)
 * after_hours Boolean If set to true, includes pre and post market data if available. By default is set to false. (optional)
 * returns TickerIntradayResponse
 **/
exports.tickersSymbolIntradayGET = function(access_key,symbol,interval,exchange,date_from,date_to,sort,limit,offset,after_hours) {
  return new Promise(function(resolve, reject) {
    var examples = {};
    examples['application/json'] = {
  "pagination" : {
    "total" : 5,
    "offset" : 6,
    "limit" : 0,
    "count" : 1
  },
  "data" : {
    "symbol" : "symbol",
    "country" : "country",
    "intraday" : [ {
      "date" : "date",
      "symbol" : "symbol",
      "ask_size" : 3.6160767,
      "last" : 2.027123,
      "mid" : 5.962134,
      "last_size" : 5.637377,
      "ask_price" : 9.301444,
      "volume" : 7.386282,
      "high" : 6.0274563,
      "low" : 1.4658129,
      "bid_size" : 2.302136,
      "marketstack_last" : 1.2315135,
      "exchange" : "exchange",
      "close" : 4.145608,
      "open" : 0.8008282,
      "bid_price" : 7.0614014
    }, {
      "date" : "date",
      "symbol" : "symbol",
      "ask_size" : 3.6160767,
      "last" : 2.027123,
      "mid" : 5.962134,
      "last_size" : 5.637377,
      "ask_price" : 9.301444,
      "volume" : 7.386282,
      "high" : 6.0274563,
      "low" : 1.4658129,
      "bid_size" : 2.302136,
      "marketstack_last" : 1.2315135,
      "exchange" : "exchange",
      "close" : 4.145608,
      "open" : 0.8008282,
      "bid_price" : 7.0614014
    } ],
    "has_intraday" : true,
    "name" : "name",
    "has_eod" : true
  }
};
    if (Object.keys(examples).length > 0) {
      resolve(examples[Object.keys(examples)[0]]);
    } else {
      resolve();
    }
  });
}


/**
 * Intraday Data for the Latest Date Available for a Specific Ticker
 * Obtain intraday data for the latest date by specifying stock ticker by attaching `/intraday/latest` to your URL.
 *
 * access_key String Your Marketstack API access key.
 * symbol String Ticker symbol to look up (e.g., `AAPL`).
 * exchange String Filter your results based on a specific stock exchange by specifying the MIC identification of a stock exchange. (optional)
 * limit Integer Pagination limit (results per page). Default 100, maximum 1000. (optional)
 * offset Integer Pagination offset (number of results to skip). Default 0. (optional)
 * returns TickerIntradayLatestResponse
 **/
exports.tickersSymbolIntradayLatestGET = function(access_key,symbol,exchange,limit,offset) {
  return new Promise(function(resolve, reject) {
    var examples = {};
    examples['application/json'] = {
  "date" : "date",
  "symbol" : "symbol",
  "ask_size" : 3.6160767,
  "last" : 2.027123,
  "mid" : 5.962134,
  "last_size" : 5.637377,
  "ask_price" : 9.301444,
  "volume" : 7.386282,
  "high" : 6.0274563,
  "low" : 1.4658129,
  "bid_size" : 2.302136,
  "marketstack_last" : 1.2315135,
  "exchange" : "exchange",
  "close" : 4.145608,
  "open" : 0.8008282,
  "bid_price" : 7.0614014
};
    if (Object.keys(examples).length > 0) {
      resolve(examples[Object.keys(examples)[0]]);
    } else {
      resolve();
    }
  });
}


/**
 * Splits Factor for a Specific Ticker
 * Obtain ticker splits factor for a specific stock ticker by attaching `/splits` to your URL.
 *
 * access_key String Your Marketstack API access key.
 * symbol String Ticker symbol to look up (e.g., `AAPL`).
 * exchange String Filter your results based on a specific stock exchange by specifying the MIC identification of a stock exchange. (optional)
 * limit Integer Pagination limit (results per page). Default 100, maximum 1000. (optional)
 * offset Integer Pagination offset (number of results to skip). Default 0. (optional)
 * date_from date Filter results from this date (inclusive). Format `YYYY-MM-DD`. (optional)
 * date_to date Filter results up to this date (inclusive). Format `YYYY-MM-DD`. (optional)
 * sort String Sort order. Use `ASC` for oldest first or `DESC` for newest first. (optional)
 * returns TickerSplitsResponse
 **/
exports.tickersSymbolSplitsGET = function(access_key,symbol,exchange,limit,offset,date_from,date_to,sort) {
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
    "split_factor" : 0.8008281904610115,
    "symbol" : "symbol",
    "stock_split" : "stock_split"
  }, {
    "date" : "date",
    "split_factor" : 0.8008281904610115,
    "symbol" : "symbol",
    "stock_split" : "stock_split"
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
 * Tickers List
 * Using the `tickerslist` endpoint you will be able to get the full list of supported tickers.
 *
 * access_key String Your Marketstack API access key.
 * search String Search term to filter tickers by name or symbol. (optional)
 * exchange String Filter your results based on a specific stock exchange by specifying the MIC identification of a stock exchange. (optional)
 * limit Integer Pagination limit (results per page). Default 100, maximum 1000. (optional)
 * offset Integer Pagination offset (number of results to skip). Default 0. (optional)
 * returns TickersListResponse
 **/
exports.tickerslistGET = function(access_key,search,exchange,limit,offset) {
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
    "ticker" : "ticker",
    "stock_exchange" : {
      "acronym" : "acronym",
      "mic" : "mic",
      "name" : "name"
    },
    "has_intraday" : true,
    "name" : "name",
    "has_eod" : true
  }, {
    "ticker" : "ticker",
    "stock_exchange" : {
      "acronym" : "acronym",
      "mic" : "mic",
      "name" : "name"
    },
    "has_intraday" : true,
    "name" : "name",
    "has_eod" : true
  } ]
};
    if (Object.keys(examples).length > 0) {
      resolve(examples[Object.keys(examples)[0]]);
    } else {
      resolve();
    }
  });
}

