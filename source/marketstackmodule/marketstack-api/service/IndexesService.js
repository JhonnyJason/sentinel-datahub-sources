'use strict';


/**
 * Stock Market Index Info
 * The Stock Market Index Info endpoint delivers stock market index information and returns the details for the requested index.
 *
 * access_key String Your Marketstack API access key.
 * index String Benchmark/index identifier (e.g., `australia_all_ordinaries`).
 * returns IndexInfoResponse
 **/
exports.indexinfoGET = function(access_key,index) {
  return new Promise(function(resolve, reject) {
    var examples = {};
    examples['application/json'] = [ {
  "date" : "date",
  "country" : "country",
  "price_change_day" : "price_change_day",
  "percentage_year" : "percentage_year",
  "price" : "price",
  "percentage_month" : "percentage_month",
  "region" : "region",
  "percentage_day" : "percentage_day",
  "percentage_week" : "percentage_week",
  "benchmark" : "benchmark"
}, {
  "date" : "date",
  "country" : "country",
  "price_change_day" : "price_change_day",
  "percentage_year" : "percentage_year",
  "price" : "price",
  "percentage_month" : "percentage_month",
  "region" : "region",
  "percentage_day" : "percentage_day",
  "percentage_week" : "percentage_week",
  "benchmark" : "benchmark"
} ];
    if (Object.keys(examples).length > 0) {
      resolve(examples[Object.keys(examples)[0]]);
    } else {
      resolve();
    }
  });
}


/**
 * Stock Market Index Listing
 * The Stock Market Index Listing endpoint delivers instantly real-time and historical stock market index data. Also, returns the full list of supported benchmarks/indexes.
 *
 * access_key String Your Marketstack API access key.
 * limit Integer Pagination limit (results per page). Default 100, maximum 1000. (optional)
 * offset Integer Pagination offset (number of results to skip). Default 0. (optional)
 * returns IndexListResponse
 **/
exports.indexlistGET = function(access_key,limit,offset) {
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
    "benchmark" : "benchmark"
  }, {
    "benchmark" : "benchmark"
  } ]
};
    if (Object.keys(examples).length > 0) {
      resolve(examples[Object.keys(examples)[0]]);
    } else {
      resolve();
    }
  });
}

