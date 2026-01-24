'use strict';

var utils = require('../utils/writer.js');
var Commodities = require('../service/CommoditiesService');

module.exports.commoditiesGET = function commoditiesGET (req, res, next, access_key, commodity_name) {
  Commodities.commoditiesGET(access_key, commodity_name)
    .then(function (response) {
      utils.writeJson(res, response);
    })
    .catch(function (response) {
      utils.writeJson(res, response);
    });
};

module.exports.commoditieshistoryGET = function commoditieshistoryGET (req, res, next, access_key, commodity_name, date_from, date_to, frequency) {
  Commodities.commoditieshistoryGET(access_key, commodity_name, date_from, date_to, frequency)
    .then(function (response) {
      utils.writeJson(res, response);
    })
    .catch(function (response) {
      utils.writeJson(res, response);
    });
};
