'use strict';


/**
 * Company Ratings
 * The Company Rating Endpoint delivers real-time buy/sell/hold analyst ratings, updated as new reports are published. It also provides 15+ years of historical ratings and price targets to track trends and analyst performance over time.   **Note:** Rate limit is enforced to 1 API call per minute.
 *
 * access_key String Your Marketstack API access key.
 * ticker String One or more comma-separated ticker symbols (e.g., `AAPL,MSFT`).
 * date_from date Filter results from this date (inclusive). Format `YYYY-MM-DD`. (optional)
 * date_to date Filter results up to this date (inclusive). Format `YYYY-MM-DD`. (optional)
 * rated String Filter response on buy, sell, or hold. (optional)
 * returns CompanyRatingsResponse
 **/
exports.companyratingsGET = function(access_key,ticker,date_from,date_to,rated) {
  return new Promise(function(resolve, reject) {
    var examples = {};
    examples['application/json'] = {
  "result" : {
    "output" : {
      "analysts" : [ {
        "analyst_firm" : "analyst_firm",
        "analyst_role" : "analyst_role",
        "rating" : {
          "rated" : "rated",
          "conclusion" : "conclusion",
          "target_date" : "target_date",
          "date_rating" : "date_rating",
          "price_target" : "price_target"
        },
        "analyst_name" : "analyst_name"
      }, {
        "analyst_firm" : "analyst_firm",
        "analyst_role" : "analyst_role",
        "rating" : {
          "rated" : "rated",
          "conclusion" : "conclusion",
          "target_date" : "target_date",
          "date_rating" : "date_rating",
          "price_target" : "price_target"
        },
        "analyst_name" : "analyst_name"
      } ],
      "analyst_consensus" : {
        "consensus_conclusion" : "consensus_conclusion",
        "analyst_lowest" : "analyst_lowest",
        "analyst_highest" : "analyst_highest",
        "buy" : "buy",
        "sell" : "sell",
        "analysts_number" : "analysts_number",
        "consensus_date" : "consensus_date",
        "stock_price" : "stock_price",
        "analyst_average" : "analyst_average",
        "hold" : "hold"
      }
    },
    "basics" : {
      "ticker" : "ticker",
      "company_name" : "company_name"
    }
  },
  "status" : {
    "code" : 0,
    "details" : "details",
    "message" : "message"
  }
};
    if (Object.keys(examples).length > 0) {
      resolve(examples[Object.keys(examples)[0]]);
    } else {
      resolve();
    }
  });
}

