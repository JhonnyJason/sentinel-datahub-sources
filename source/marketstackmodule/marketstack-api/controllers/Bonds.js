'use strict';

var utils = require('../utils/writer.js');
var Bonds = require('../service/BondsService');

module.exports.bondGET = function bondGET (req, res, next, access_key, country) {
  Bonds.bondGET(access_key, country)
    .then(function (response) {
      utils.writeJson(res, response);
    })
    .catch(function (response) {
      utils.writeJson(res, response);
    });
};

module.exports.bondlistGET = function bondlistGET (req, res, next, access_key, limit, offset) {
  Bonds.bondlistGET(access_key, limit, offset)
    .then(function (response) {
      utils.writeJson(res, response);
    })
    .catch(function (response) {
      utils.writeJson(res, response);
    });
};
