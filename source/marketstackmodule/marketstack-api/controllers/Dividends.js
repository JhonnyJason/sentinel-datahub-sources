'use strict';

var utils = require('../utils/writer.js');
var Dividends = require('../service/DividendsService');

module.exports.dividendsGET = function dividendsGET (req, res, next, access_key, symbols, date_from, date_to, sort, limit, offset) {
  Dividends.dividendsGET(access_key, symbols, date_from, date_to, sort, limit, offset)
    .then(function (response) {
      utils.writeJson(res, response);
    })
    .catch(function (response) {
      utils.writeJson(res, response);
    });
};
