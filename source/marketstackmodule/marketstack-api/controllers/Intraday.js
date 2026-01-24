'use strict';

var utils = require('../utils/writer.js');
var Intraday = require('../service/IntradayService');

module.exports.intradayDateGET = function intradayDateGET (req, res, next, access_key, date, symbols, interval, exchange, limit, offset, after_hours) {
  Intraday.intradayDateGET(access_key, date, symbols, interval, exchange, limit, offset, after_hours)
    .then(function (response) {
      utils.writeJson(res, response);
    })
    .catch(function (response) {
      utils.writeJson(res, response);
    });
};

module.exports.intradayGET = function intradayGET (req, res, next, access_key, symbols, interval, exchange, date_from, date_to, sort, limit, offset, after_hours) {
  Intraday.intradayGET(access_key, symbols, interval, exchange, date_from, date_to, sort, limit, offset, after_hours)
    .then(function (response) {
      utils.writeJson(res, response);
    })
    .catch(function (response) {
      utils.writeJson(res, response);
    });
};

module.exports.intradayLatestGET = function intradayLatestGET (req, res, next, access_key, symbols, interval, exchange, after_hours) {
  Intraday.intradayLatestGET(access_key, symbols, interval, exchange, after_hours)
    .then(function (response) {
      utils.writeJson(res, response);
    })
    .catch(function (response) {
      utils.writeJson(res, response);
    });
};
