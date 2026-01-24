'use strict';

var utils = require('../utils/writer.js');
var Exchanges = require('../service/ExchangesService');

module.exports.exchangesGET = function exchangesGET (req, res, next, access_key, limit, offset, search) {
  Exchanges.exchangesGET(access_key, limit, offset, search)
    .then(function (response) {
      utils.writeJson(res, response);
    })
    .catch(function (response) {
      utils.writeJson(res, response);
    });
};

module.exports.exchangesMicEodDateGET = function exchangesMicEodDateGET (req, res, next, access_key, symbols, mic, date, limit, offset) {
  Exchanges.exchangesMicEodDateGET(access_key, symbols, mic, date, limit, offset)
    .then(function (response) {
      utils.writeJson(res, response);
    })
    .catch(function (response) {
      utils.writeJson(res, response);
    });
};

module.exports.exchangesMicEodGET = function exchangesMicEodGET (req, res, next, access_key, mic, symbols, exchange, date_from, date_to, sort, limit, offset) {
  Exchanges.exchangesMicEodGET(access_key, mic, symbols, exchange, date_from, date_to, sort, limit, offset)
    .then(function (response) {
      utils.writeJson(res, response);
    })
    .catch(function (response) {
      utils.writeJson(res, response);
    });
};

module.exports.exchangesMicEodLatestGET = function exchangesMicEodLatestGET (req, res, next, access_key, symbols, mic) {
  Exchanges.exchangesMicEodLatestGET(access_key, symbols, mic)
    .then(function (response) {
      utils.writeJson(res, response);
    })
    .catch(function (response) {
      utils.writeJson(res, response);
    });
};

module.exports.exchangesMicGET = function exchangesMicGET (req, res, next, access_key, mic) {
  Exchanges.exchangesMicGET(access_key, mic)
    .then(function (response) {
      utils.writeJson(res, response);
    })
    .catch(function (response) {
      utils.writeJson(res, response);
    });
};

module.exports.exchangesMicIntradayDateGET = function exchangesMicIntradayDateGET (req, res, next, access_key, symbols, mic, date, interval, limit, offset) {
  Exchanges.exchangesMicIntradayDateGET(access_key, symbols, mic, date, interval, limit, offset)
    .then(function (response) {
      utils.writeJson(res, response);
    })
    .catch(function (response) {
      utils.writeJson(res, response);
    });
};

module.exports.exchangesMicIntradayGET = function exchangesMicIntradayGET (req, res, next, access_key, symbols, mic, interval, date_from, date_to, sort, limit, offset) {
  Exchanges.exchangesMicIntradayGET(access_key, symbols, mic, interval, date_from, date_to, sort, limit, offset)
    .then(function (response) {
      utils.writeJson(res, response);
    })
    .catch(function (response) {
      utils.writeJson(res, response);
    });
};

module.exports.exchangesMicIntradayLatestGET = function exchangesMicIntradayLatestGET (req, res, next, access_key, symbols, mic, interval) {
  Exchanges.exchangesMicIntradayLatestGET(access_key, symbols, mic, interval)
    .then(function (response) {
      utils.writeJson(res, response);
    })
    .catch(function (response) {
      utils.writeJson(res, response);
    });
};

module.exports.exchangesMicTickersGET = function exchangesMicTickersGET (req, res, next, access_key, mic, limit, offset) {
  Exchanges.exchangesMicTickersGET(access_key, mic, limit, offset)
    .then(function (response) {
      utils.writeJson(res, response);
    })
    .catch(function (response) {
      utils.writeJson(res, response);
    });
};
