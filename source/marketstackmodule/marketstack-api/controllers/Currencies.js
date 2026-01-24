'use strict';

var utils = require('../utils/writer.js');
var Currencies = require('../service/CurrenciesService');

module.exports.currenciesGET = function currenciesGET (req, res, next, access_key, limit, offset) {
  Currencies.currenciesGET(access_key, limit, offset)
    .then(function (response) {
      utils.writeJson(res, response);
    })
    .catch(function (response) {
      utils.writeJson(res, response);
    });
};
