'use strict';


/**
 * Exchanges
 * Using the Exchanges endpoint you will be able to look up information any of the 2700+ stock exchanges supported by this endpoint. This endpoint provides general information about several stock exchanges. Not all stock exchanges found here are supported by other Marketstack endpoints. For the supported stock exchanges supported by each endpoint, please verify each endpoint documentation.
 *
 * access_key String Your Marketstack API access key.
 * limit Integer Pagination limit (results per page). Default 100, maximum 1000. (optional)
 * offset Integer Pagination offset (number of results to skip). Default 0. (optional)
 * search String Search term to filter tickers by name or symbol. (optional)
 * returns ExchangesResponse
 **/
exports.exchangesGET = function(access_key,limit,offset,search) {
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
    "operating_mic" : "operating_mic",
    "country" : "country",
    "date_last_update" : "date_last_update",
    "website" : "website",
    "comments" : "comments",
    "acronym" : "acronym",
    "city" : "city",
    "mic" : "mic",
    "exchange_lei" : "exchange_lei",
    "oprt_sgmt" : "oprt_sgmt",
    "date_creation" : "date_creation",
    "date_last_validation" : "date_last_validation",
    "country_code" : "country_code",
    "market_category_code" : "market_category_code",
    "name" : "name",
    "legal_entity_name" : "legal_entity_name",
    "exchange_status" : "exchange_status",
    "date_expiry" : "date_expiry"
  }, {
    "operating_mic" : "operating_mic",
    "country" : "country",
    "date_last_update" : "date_last_update",
    "website" : "website",
    "comments" : "comments",
    "acronym" : "acronym",
    "city" : "city",
    "mic" : "mic",
    "exchange_lei" : "exchange_lei",
    "oprt_sgmt" : "oprt_sgmt",
    "date_creation" : "date_creation",
    "date_last_validation" : "date_last_validation",
    "country_code" : "country_code",
    "market_category_code" : "market_category_code",
    "name" : "name",
    "legal_entity_name" : "legal_entity_name",
    "exchange_status" : "exchange_status",
    "date_expiry" : "date_expiry"
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
 * EOD Data for a Specific Stock Exchange on a Specific Date
 * Returns EOD data for the given date for all symbols on a specific exchange.
 *
 * access_key String Your Marketstack API access key.
 * symbols String One or more comma-separated ticker symbols (e.g., `AAPL,MSFT`).
 * mic String Exchange MIC identifier (e.g., `XNAS`).
 * date date Specific date for EOD data. Format `YYYY-MM-DD`.
 * limit Integer Pagination limit (results per page). Default 100, maximum 1000. (optional)
 * offset Integer Pagination offset (number of results to skip). Default 0. (optional)
 * returns ExchangesMicEod
 **/
exports.exchangesMicEodDateGET = function(access_key,symbols,mic,date,limit,offset) {
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
    "operating_mic" : "operating_mic",
    "country" : "country",
    "date_last_update" : "date_last_update",
    "website" : "website",
    "comments" : "comments",
    "acronym" : "acronym",
    "city" : "city",
    "mic" : "mic",
    "exchange_lei" : "exchange_lei",
    "oprt_sgmt" : "oprt_sgmt",
    "date_creation" : "date_creation",
    "date_last_validation" : "date_last_validation",
    "market_category_code" : "market_category_code",
    "name" : "name",
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
    } ],
    "legal_entity_name" : "legal_entity_name",
    "exchange_status" : "exchange_status",
    "date_expiry" : "date_expiry"
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
 * EOD Data for a Specific Stock Exchange
 * Returns EOD data for all symbols on a specific exchange.
 *
 * access_key String Your Marketstack API access key.
 * mic String Exchange MIC identifier (e.g., `XNAS`).
 * symbols String One or more comma-separated ticker symbols (e.g., `AAPL,MSFT`).
 * exchange String Filter your results based on a specific stock exchange by specifying the MIC identification of a stock exchange. (optional)
 * date_from date Filter results from this date (inclusive). Format `YYYY-MM-DD`. (optional)
 * date_to date Filter results up to this date (inclusive). Format `YYYY-MM-DD`. (optional)
 * sort String Sort order. Use `ASC` for oldest first or `DESC` for newest first. (optional)
 * limit Integer Pagination limit (results per page). Default 100, maximum 1000. (optional)
 * offset Integer Pagination offset (number of results to skip). Default 0. (optional)
 * returns ExchangesMicEod
 **/
exports.exchangesMicEodGET = function(access_key,mic,symbols,exchange,date_from,date_to,sort,limit,offset) {
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
    "operating_mic" : "operating_mic",
    "country" : "country",
    "date_last_update" : "date_last_update",
    "website" : "website",
    "comments" : "comments",
    "acronym" : "acronym",
    "city" : "city",
    "mic" : "mic",
    "exchange_lei" : "exchange_lei",
    "oprt_sgmt" : "oprt_sgmt",
    "date_creation" : "date_creation",
    "date_last_validation" : "date_last_validation",
    "market_category_code" : "market_category_code",
    "name" : "name",
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
    } ],
    "legal_entity_name" : "legal_entity_name",
    "exchange_status" : "exchange_status",
    "date_expiry" : "date_expiry"
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
 * EOD Data for the Latest Date Available for a Specific Stock Exchange
 * Returns EOD data for the latest date avialbale for all symbols on a specific exchange.
 *
 * access_key String Your Marketstack API access key.
 * symbols String One or more comma-separated ticker symbols (e.g., `AAPL,MSFT`).
 * mic String Exchange MIC identifier (e.g., `XNAS`).
 * returns ExchangesMicEod
 **/
exports.exchangesMicEodLatestGET = function(access_key,symbols,mic) {
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
    "operating_mic" : "operating_mic",
    "country" : "country",
    "date_last_update" : "date_last_update",
    "website" : "website",
    "comments" : "comments",
    "acronym" : "acronym",
    "city" : "city",
    "mic" : "mic",
    "exchange_lei" : "exchange_lei",
    "oprt_sgmt" : "oprt_sgmt",
    "date_creation" : "date_creation",
    "date_last_validation" : "date_last_validation",
    "market_category_code" : "market_category_code",
    "name" : "name",
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
    } ],
    "legal_entity_name" : "legal_entity_name",
    "exchange_status" : "exchange_status",
    "date_expiry" : "date_expiry"
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
 * Specific Stock Exchange Info
 * Returns detailed information for a single exchange (by MIC).
 *
 * access_key String Your Marketstack API access key.
 * mic String Exchange MIC identifier (e.g., `XNAS`).
 * returns ExchangesResponse
 **/
exports.exchangesMicGET = function(access_key,mic) {
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
    "operating_mic" : "operating_mic",
    "country" : "country",
    "date_last_update" : "date_last_update",
    "website" : "website",
    "comments" : "comments",
    "acronym" : "acronym",
    "city" : "city",
    "mic" : "mic",
    "exchange_lei" : "exchange_lei",
    "oprt_sgmt" : "oprt_sgmt",
    "date_creation" : "date_creation",
    "date_last_validation" : "date_last_validation",
    "country_code" : "country_code",
    "market_category_code" : "market_category_code",
    "name" : "name",
    "legal_entity_name" : "legal_entity_name",
    "exchange_status" : "exchange_status",
    "date_expiry" : "date_expiry"
  }, {
    "operating_mic" : "operating_mic",
    "country" : "country",
    "date_last_update" : "date_last_update",
    "website" : "website",
    "comments" : "comments",
    "acronym" : "acronym",
    "city" : "city",
    "mic" : "mic",
    "exchange_lei" : "exchange_lei",
    "oprt_sgmt" : "oprt_sgmt",
    "date_creation" : "date_creation",
    "date_last_validation" : "date_last_validation",
    "country_code" : "country_code",
    "market_category_code" : "market_category_code",
    "name" : "name",
    "legal_entity_name" : "legal_entity_name",
    "exchange_status" : "exchange_status",
    "date_expiry" : "date_expiry"
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
 * Intraday Data for a Specific Stock Exchange on a Specific Date
 * Returns intraday data for the given date for all symbols on a specific exchange.
 *
 * access_key String Your Marketstack API access key.
 * symbols String One or more comma-separated ticker symbols (e.g., `AAPL,MSFT`).
 * mic String Exchange MIC identifier (e.g., `XNAS`).
 * date String Specific date for intraday data. Example `2024-09-27 15:30`.
 * interval String Intraday aggregation interval. (optional)
 * limit Integer Pagination limit (results per page). Default 100, maximum 1000. (optional)
 * offset Integer Pagination offset (number of results to skip). Default 0. (optional)
 * returns IntradayResponse
 **/
exports.exchangesMicIntradayDateGET = function(access_key,symbols,mic,date,interval,limit,offset) {
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
 * Intraday Data for a Specific Stock Exchange
 * Returns intraday data for all symbols on a specific exchange.
 *
 * access_key String Your Marketstack API access key.
 * symbols String One or more comma-separated ticker symbols (e.g., `AAPL,MSFT`).
 * mic String Exchange MIC identifier (e.g., `XNAS`).
 * interval String Intraday aggregation interval. (optional)
 * date_from date Filter results from this date (inclusive). Format `YYYY-MM-DD`. (optional)
 * date_to date Filter results up to this date (inclusive). Format `YYYY-MM-DD`. (optional)
 * sort String Sort order. Use `ASC` for oldest first or `DESC` for newest first. (optional)
 * limit Integer Pagination limit (results per page). Default 100, maximum 1000. (optional)
 * offset Integer Pagination offset (number of results to skip). Default 0. (optional)
 * returns IntradayResponse
 **/
exports.exchangesMicIntradayGET = function(access_key,symbols,mic,interval,date_from,date_to,sort,limit,offset) {
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
 * Intraday Data for the Latest Date Available for a Specific Stock Exchange
 * Returns intraday data for the latest date avialbale for all symbols on a specific exchange.
 *
 * access_key String Your Marketstack API access key.
 * symbols String One or more comma-separated ticker symbols (e.g., `AAPL,MSFT`).
 * mic String Exchange MIC identifier (e.g., `XNAS`).
 * interval String Intraday aggregation interval. (optional)
 * returns IntradayResponse
 **/
exports.exchangesMicIntradayLatestGET = function(access_key,symbols,mic,interval) {
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
 * Specific Stock Exchange Tickers
 * Returns tickers listed on a specific exchange.
 *
 * access_key String Your Marketstack API access key.
 * mic String Exchange MIC identifier (e.g., `XNAS`).
 * limit Integer Pagination limit (results per page). Default 100, maximum 1000. (optional)
 * offset Integer Pagination offset (number of results to skip). Default 0. (optional)
 * returns ExchangeMicTickersResponse
 **/
exports.exchangesMicTickersGET = function(access_key,mic,limit,offset) {
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
    "operating_mic" : "operating_mic",
    "country" : "country",
    "date_last_update" : "date_last_update",
    "website" : "website",
    "comments" : "comments",
    "acronym" : "acronym",
    "city" : "city",
    "mic" : "mic",
    "exchange_lei" : "exchange_lei",
    "tickers" : [ {
      "symbol" : "symbol",
      "has_intraday" : true,
      "name" : "name",
      "has_eod" : true
    }, {
      "symbol" : "symbol",
      "has_intraday" : true,
      "name" : "name",
      "has_eod" : true
    } ],
    "oprt_sgmt" : "oprt_sgmt",
    "date_creation" : "date_creation",
    "date_last_validation" : "date_last_validation",
    "market_category_code" : "market_category_code",
    "name" : "name",
    "legal_entity_name" : "legal_entity_name",
    "exchange_status" : "exchange_status",
    "date_expiry" : "date_expiry"
  }
};
    if (Object.keys(examples).length > 0) {
      resolve(examples[Object.keys(examples)[0]]);
    } else {
      resolve();
    }
  });
}

