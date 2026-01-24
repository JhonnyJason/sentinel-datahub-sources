'use strict';


/**
 * ETF Holdings Info
 * ETF Holding Info (timeframe) holding data within a specified date range using a unique ticker identifier. You can adjust the `ticker`, `date_from`, and `date_to` parameters based on your specific needs.  The example API request below demonstrates how to retrieve **stock market index information.**  **Note:**The ETF API endpoints use a **call count multiplier of 20.**
 *
 * access_key String Your Marketstack API access key.
 * ticker String ETF ticker symbol.
 * date_from date Filter results from this date (inclusive). Format `YYYY-MM-DD`. (optional)
 * date_to date Filter results up to this date (inclusive). Format `YYYY-MM-DD`. (optional)
 * returns ETFHoldingsResponse
 **/
exports.etfholdingsGET = function(access_key,ticker,date_from,date_to) {
  return new Promise(function(resolve, reject) {
    var examples = {};
    examples['application/json'] = {
  "output" : {
    "signature" : {
      "signer_name" : "signer_name",
      "date_signed" : "date_signed",
      "signature" : "signature",
      "name_of_applicant" : "name_of_applicant",
      "title" : "title"
    },
    "attributes" : {
      "date_report_period" : "date_report_period",
      "ticker" : "ticker",
      "series_lei" : "series_lei",
      "end_report_period" : "end_report_period",
      "series_name" : "series_name",
      "final_filing" : true,
      "isin" : "isin",
      "series_id" : "series_id"
    },
    "holdings" : [ {
      "investment_security" : {
        "cusip" : "cusip",
        "payoff_profile" : "payoff_profile",
        "fair_value_level" : "fair_value_level",
        "issuer_category" : "issuer_category",
        "units" : "units",
        "title" : "title",
        "loan_by_fund" : "loan_by_fund",
        "lei" : "lei",
        "asset_category" : "asset_category",
        "percent_value" : "percent_value",
        "balance" : "balance",
        "restricted_sec" : "restricted_sec",
        "cash_collateral" : "cash_collateral",
        "name" : "name",
        "non_cash_collateral" : "non_cash_collateral",
        "value_usd" : "value_usd",
        "invested_country" : "invested_country",
        "currency" : "currency",
        "isin" : "isin"
      }
    }, {
      "investment_security" : {
        "cusip" : "cusip",
        "payoff_profile" : "payoff_profile",
        "fair_value_level" : "fair_value_level",
        "issuer_category" : "issuer_category",
        "units" : "units",
        "title" : "title",
        "loan_by_fund" : "loan_by_fund",
        "lei" : "lei",
        "asset_category" : "asset_category",
        "percent_value" : "percent_value",
        "balance" : "balance",
        "restricted_sec" : "restricted_sec",
        "cash_collateral" : "cash_collateral",
        "name" : "name",
        "non_cash_collateral" : "non_cash_collateral",
        "value_usd" : "value_usd",
        "invested_country" : "invested_country",
        "currency" : "currency",
        "isin" : "isin"
      }
    } ]
  },
  "basics" : {
    "file_number" : "file_number",
    "cik" : "cik",
    "fund_name" : "fund_name",
    "reg_lei" : "reg_lei"
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
 * ETF Holdings Listing
 * The ETF Holdings Listing endpoint delivers instantly complete set of exchange-traded funds data based on the unique identifier code of an ETF data. The endpoint returns a full list of supported ETF tickers.   The example API request below demonstrates how to retrieve **ETF holdings data.**  **Note:** The ETF API endpoints apply a **call count multiplier of 20.**
 *
 * access_key String Your Marketstack API access key.
 * list String ETF list type; currently `ticker`.
 * limit Integer Pagination limit (results per page). Default 100, maximum 1000. (optional)
 * offset Integer Pagination offset (number of results to skip). Default 0. (optional)
 * returns ETFListResponse
 **/
exports.etflistGET = function(access_key,list,limit,offset) {
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
    "ticker" : "ticker"
  }, {
    "ticker" : "ticker"
  } ]
};
    if (Object.keys(examples).length > 0) {
      resolve(examples[Object.keys(examples)[0]]);
    } else {
      resolve();
    }
  });
}

