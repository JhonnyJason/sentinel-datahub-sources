'use strict';

var utils = require('../utils/writer.js');
var Timezones = require('../service/TimezonesService');

module.exports.timezonesGET = function timezonesGET (req, res, next, access_key, limit, offset) {
  Timezones.timezonesGET(access_key, limit, offset)
    .then(function (response) {
      utils.writeJson(res, response);
    })
    .catch(function (response) {
      utils.writeJson(res, response);
    });
};
