'use strict';

var utils = require('../utils/writer.js');
var EndOfDay = require('../service/EndOfDayService');

module.exports.eodDateGET = function eodDateGET (req, res, next, access_key, date, symbols, exchange, limit, offset, sort) {
  EndOfDay.eodDateGET(access_key, date, symbols, exchange, limit, offset, sort)
    .then(function (response) {
      utils.writeJson(res, response);
    })
    .catch(function (response) {
      utils.writeJson(res, response);
    });
};

module.exports.eodGET = function eodGET (req, res, next, access_key, symbols, exchange, date_from, date_to, sort, limit, offset) {
  EndOfDay.eodGET(access_key, symbols, exchange, date_from, date_to, sort, limit, offset)
    .then(function (response) {
      utils.writeJson(res, response);
    })
    .catch(function (response) {
      utils.writeJson(res, response);
    });
};

module.exports.eodLatestGET = function eodLatestGET (req, res, next, access_key, symbols, exchange, sort, limit, offset) {
  EndOfDay.eodLatestGET(access_key, symbols, exchange, sort, limit, offset)
    .then(function (response) {
      utils.writeJson(res, response);
    })
    .catch(function (response) {
      utils.writeJson(res, response);
    });
};
