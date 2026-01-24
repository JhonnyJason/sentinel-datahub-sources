'use strict';

var utils = require('../utils/writer.js');
var ETFs = require('../service/ETFsService');

module.exports.etfholdingsGET = function etfholdingsGET (req, res, next, access_key, ticker, date_from, date_to) {
  ETFs.etfholdingsGET(access_key, ticker, date_from, date_to)
    .then(function (response) {
      utils.writeJson(res, response);
    })
    .catch(function (response) {
      utils.writeJson(res, response);
    });
};

module.exports.etflistGET = function etflistGET (req, res, next, access_key, list, limit, offset) {
  ETFs.etflistGET(access_key, list, limit, offset)
    .then(function (response) {
      utils.writeJson(res, response);
    })
    .catch(function (response) {
      utils.writeJson(res, response);
    });
};
