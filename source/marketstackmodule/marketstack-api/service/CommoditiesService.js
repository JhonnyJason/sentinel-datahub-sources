'use strict';


/**
 * Commodity Prices
 * Get commodity prices of 70+ world-known commodities of energy, metals, industrial, agricultural, and livestock areas.  **Note:**  * Rate limit for 1 API call per minute is enforced on this endpoint. See the full list of available commodities in the file presented here:[**Download**](https://marketstack.com/download/marketstack-commodities.xlsx)  * Historical end-of-day data (`eod`) is available for up to 15 years back, while intraday data (`intraday`) always only offers the last 10,000 entries for each of the intervals available. **Example:** For a 1-minute interval, historical intraday data is available for up to 10,000 minutes back.
 *
 * access_key String Your Marketstack API access key.
 * commodity_name String Specify the commodity_name for which you like to receive the Price, aluminum for example.
 * returns CommodityResponse
 **/
exports.commoditiesGET = function(access_key,commodity_name) {
  return new Promise(function(resolve, reject) {
    var examples = {};
    examples['application/json'] = {
  "data" : [ {
    "commodity_price" : "commodity_price",
    "percentage_week" : "percentage_week",
    "datetime" : "2000-01-23T04:56:07.000+00:00",
    "commodity_unit" : "commodity_unit",
    "price_change_day" : "price_change_day",
    "percentage_year" : "percentage_year",
    "quarter3_25" : "quarter3_25",
    "quarter4_25" : "quarter4_25",
    "percentage_month" : "percentage_month",
    "percentage_day" : "percentage_day",
    "quarter2_25" : "quarter2_25",
    "commodity_name" : "commodity_name",
    "quarter1_25" : "quarter1_25"
  }, {
    "commodity_price" : "commodity_price",
    "percentage_week" : "percentage_week",
    "datetime" : "2000-01-23T04:56:07.000+00:00",
    "commodity_unit" : "commodity_unit",
    "price_change_day" : "price_change_day",
    "percentage_year" : "percentage_year",
    "quarter3_25" : "quarter3_25",
    "quarter4_25" : "quarter4_25",
    "percentage_month" : "percentage_month",
    "percentage_day" : "percentage_day",
    "quarter2_25" : "quarter2_25",
    "commodity_name" : "commodity_name",
    "quarter1_25" : "quarter1_25"
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
 * Commodities Historical Prices
 * If you are looking for past commodity prices, you can use the Historical Commodity Prices endpoint, where you can choose specific dates and search by individual commodities. Additionally, the API offers options for daily data from the previous five years or monthly intervals using the `frequency` parameter.  **Note:**  * A rate limit of 1 API call per minute is enforced on this endpoint.  * The recommended historical date range for a single API call is 1 year when requesting daily data. While larger ranges (up to 1.5 years) may work, retrieving data one year at a time ensures consistency.  * Historical data for Commodities is available for up to 15 years in the past, though coverage varies by commodity type like **Metals:** Typically over 13 years of historical data, with some having as few as 2 years. **Energy:** Generally 15 years of coverage, though a few have up to 10 years. **Industrial:** Usually 15 years, with some limited to 10 years. **Livestock and Agricultural:** Coverage ranges from 9 to 15 years.
 *
 * access_key String Your Marketstack API access key.
 * commodity_name String Specify the commodity_name for which you like to receive the Price, aluminum for example.
 * date_from date Filter results from this date (inclusive). Format `YYYY-MM-DD`. (optional)
 * date_to date Filter results up to this date (inclusive). Format `YYYY-MM-DD`. (optional)
 * frequency String Specify the frequency of the commodity prices. Available options are `daily`, `weekly`, `monthly`, `quarterly`, and `yearly`. Default is `daily`. (optional)
 * returns CommodityHistoricalResponse
 **/
exports.commoditieshistoryGET = function(access_key,commodity_name,date_from,date_to,frequency) {
  return new Promise(function(resolve, reject) {
    var examples = {};
    examples['application/json'] = {
  "result" : {
    "basics" : {
      "frequency" : "frequency"
    },
    "data" : [ {
      "commodity_unit" : "commodity_unit",
      "commodity_prices" : [ {
        "date" : "date",
        "commodity_price" : "commodity_price"
      }, {
        "date" : "date",
        "commodity_price" : "commodity_price"
      } ],
      "commodity_name" : "commodity_name"
    }, {
      "commodity_unit" : "commodity_unit",
      "commodity_prices" : [ {
        "date" : "date",
        "commodity_price" : "commodity_price"
      }, {
        "date" : "date",
        "commodity_price" : "commodity_price"
      } ],
      "commodity_name" : "commodity_name"
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

