'use strict';


/**
 * Bond Info
 * The Bond endpoint delivers immediately real-time government bond data. The bond data focuses on treasury notes issued in leading countries worldwide for ten years. The Bond API delivers info for every country. Endpoint returns the details for the desired country.
 *
 * access_key String Your Marketstack API access key.
 * country String Country name for bonds endpoint (e.g., `kenya`, `united%20states`).
 * returns BondInfoResponse
 **/
exports.bondGET = function(access_key,country) {
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
    "country" : "country",
    "price_change_day" : "price_change_day",
    "percentage_year" : "percentage_year",
    "yield" : "yield",
    "percentage_month" : "percentage_month",
    "region" : "region",
    "type" : "type",
    "percentage_week" : "percentage_week"
  }, {
    "date" : "date",
    "country" : "country",
    "price_change_day" : "price_change_day",
    "percentage_year" : "percentage_year",
    "yield" : "yield",
    "percentage_month" : "percentage_month",
    "region" : "region",
    "type" : "type",
    "percentage_week" : "percentage_week"
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
 * Bonds Listing
 * The Bonds Listing endpoint delivers the list of the supported countries data. Return the full list of supported countries.
 *
 * access_key String Your Marketstack API access key.
 * limit Integer Pagination limit (results per page). Default 100, maximum 1000. (optional)
 * offset Integer Pagination offset (number of results to skip). Default 0. (optional)
 * returns BondListResponse
 **/
exports.bondlistGET = function(access_key,limit,offset) {
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
    "country" : "country"
  }, {
    "country" : "country"
  } ]
};
    if (Object.keys(examples).length > 0) {
      resolve(examples[Object.keys(examples)[0]]);
    } else {
      resolve();
    }
  });
}

