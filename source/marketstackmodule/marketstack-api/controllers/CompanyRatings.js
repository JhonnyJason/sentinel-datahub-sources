'use strict';

var utils = require('../utils/writer.js');
var CompanyRatings = require('../service/CompanyRatingsService');

module.exports.companyratingsGET = function companyratingsGET (req, res, next, access_key, ticker, date_from, date_to, rated) {
  CompanyRatings.companyratingsGET(access_key, ticker, date_from, date_to, rated)
    .then(function (response) {
      utils.writeJson(res, response);
    })
    .catch(function (response) {
      utils.writeJson(res, response);
    });
};
