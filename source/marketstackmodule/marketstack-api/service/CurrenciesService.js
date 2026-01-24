'use strict';


/**
 * Currencies
 * Returns a paginated list of supported currencies by Marketstack API.
 *
 * access_key String Your Marketstack API access key.
 * limit Integer Pagination limit (results per page). Default 100, maximum 1000. (optional)
 * offset Integer Pagination offset (number of results to skip). Default 0. (optional)
 * returns CurrenciesResponse
 **/
exports.currenciesGET = function(access_key,limit,offset) {
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
    "symbol" : "symbol",
    "code" : "code",
    "symbol_native" : "symbol_native",
    "name" : "name"
  }, {
    "symbol" : "symbol",
    "code" : "code",
    "symbol_native" : "symbol_native",
    "name" : "name"
  } ]
};
    if (Object.keys(examples).length > 0) {
      resolve(examples[Object.keys(examples)[0]]);
    } else {
      resolve();
    }
  });
}

