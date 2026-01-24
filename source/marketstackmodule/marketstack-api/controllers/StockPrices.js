'use strict';

var utils = require('../utils/writer.js');
var StockPrices = require('../service/StockPricesService');

module.exports.stockpriceGET = function stockpriceGET (req, res, next, access_key, ticker, exchange) {
  StockPrices.stockpriceGET(access_key, ticker, exchange)
    .then(function (response) {
      utils.writeJson(res, response);
    })
    .catch(function (response) {
      utils.writeJson(res, response);
    });
};
