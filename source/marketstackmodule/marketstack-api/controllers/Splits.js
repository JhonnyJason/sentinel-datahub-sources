'use strict';

var utils = require('../utils/writer.js');
var Splits = require('../service/SplitsService');

module.exports.splitsGET = function splitsGET (req, res, next, access_key, symbols, date_from, date_to, sort, limit, offset) {
  Splits.splitsGET(access_key, symbols, date_from, date_to, sort, limit, offset)
    .then(function (response) {
      utils.writeJson(res, response);
    })
    .catch(function (response) {
      utils.writeJson(res, response);
    });
};
