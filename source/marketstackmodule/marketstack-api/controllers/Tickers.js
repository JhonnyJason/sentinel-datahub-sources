'use strict';

var utils = require('../utils/writer.js');
var Tickers = require('../service/TickersService');

module.exports.tickerinfoGET = function tickerinfoGET (req, res, next, access_key, ticker) {
  Tickers.tickerinfoGET(access_key, ticker)
    .then(function (response) {
      utils.writeJson(res, response);
    })
    .catch(function (response) {
      utils.writeJson(res, response);
    });
};

module.exports.tickersSymbolDividendsGET = function tickersSymbolDividendsGET (req, res, next, access_key, symbol, exchange, limit, offset, date_from, date_to, sort) {
  Tickers.tickersSymbolDividendsGET(access_key, symbol, exchange, limit, offset, date_from, date_to, sort)
    .then(function (response) {
      utils.writeJson(res, response);
    })
    .catch(function (response) {
      utils.writeJson(res, response);
    });
};

module.exports.tickersSymbolEodDateGET = function tickersSymbolEodDateGET (req, res, next, access_key, symbol, date, exchange, limit, offset) {
  Tickers.tickersSymbolEodDateGET(access_key, symbol, date, exchange, limit, offset)
    .then(function (response) {
      utils.writeJson(res, response);
    })
    .catch(function (response) {
      utils.writeJson(res, response);
    });
};

module.exports.tickersSymbolEodGET = function tickersSymbolEodGET (req, res, next, access_key, symbol, exchange, limit, offset) {
  Tickers.tickersSymbolEodGET(access_key, symbol, exchange, limit, offset)
    .then(function (response) {
      utils.writeJson(res, response);
    })
    .catch(function (response) {
      utils.writeJson(res, response);
    });
};

module.exports.tickersSymbolEodLatestGET = function tickersSymbolEodLatestGET (req, res, next, access_key, symbol, exchange, limit, offset) {
  Tickers.tickersSymbolEodLatestGET(access_key, symbol, exchange, limit, offset)
    .then(function (response) {
      utils.writeJson(res, response);
    })
    .catch(function (response) {
      utils.writeJson(res, response);
    });
};

module.exports.tickersSymbolGET = function tickersSymbolGET (req, res, next, access_key, symbol, exchange, limit, offset) {
  Tickers.tickersSymbolGET(access_key, symbol, exchange, limit, offset)
    .then(function (response) {
      utils.writeJson(res, response);
    })
    .catch(function (response) {
      utils.writeJson(res, response);
    });
};

module.exports.tickersSymbolIntradayGET = function tickersSymbolIntradayGET (req, res, next, access_key, symbol, interval, exchange, date_from, date_to, sort, limit, offset, after_hours) {
  Tickers.tickersSymbolIntradayGET(access_key, symbol, interval, exchange, date_from, date_to, sort, limit, offset, after_hours)
    .then(function (response) {
      utils.writeJson(res, response);
    })
    .catch(function (response) {
      utils.writeJson(res, response);
    });
};

module.exports.tickersSymbolIntradayLatestGET = function tickersSymbolIntradayLatestGET (req, res, next, access_key, symbol, exchange, limit, offset) {
  Tickers.tickersSymbolIntradayLatestGET(access_key, symbol, exchange, limit, offset)
    .then(function (response) {
      utils.writeJson(res, response);
    })
    .catch(function (response) {
      utils.writeJson(res, response);
    });
};

module.exports.tickersSymbolSplitsGET = function tickersSymbolSplitsGET (req, res, next, access_key, symbol, exchange, limit, offset, date_from, date_to, sort) {
  Tickers.tickersSymbolSplitsGET(access_key, symbol, exchange, limit, offset, date_from, date_to, sort)
    .then(function (response) {
      utils.writeJson(res, response);
    })
    .catch(function (response) {
      utils.writeJson(res, response);
    });
};

module.exports.tickerslistGET = function tickerslistGET (req, res, next, access_key, search, exchange, limit, offset) {
  Tickers.tickerslistGET(access_key, search, exchange, limit, offset)
    .then(function (response) {
      utils.writeJson(res, response);
    })
    .catch(function (response) {
      utils.writeJson(res, response);
    });
};
