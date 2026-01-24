'use strict';

var utils = require('../utils/writer.js');
var Indexes = require('../service/IndexesService');

module.exports.indexinfoGET = function indexinfoGET (req, res, next, access_key, index) {
  Indexes.indexinfoGET(access_key, index)
    .then(function (response) {
      utils.writeJson(res, response);
    })
    .catch(function (response) {
      utils.writeJson(res, response);
    });
};

module.exports.indexlistGET = function indexlistGET (req, res, next, access_key, limit, offset) {
  Indexes.indexlistGET(access_key, limit, offset)
    .then(function (response) {
      utils.writeJson(res, response);
    })
    .catch(function (response) {
      utils.writeJson(res, response);
    });
};
