'use strict';

var utils = require('../utils/writer.js');
var EDGAR = require('../service/EDGARService');

module.exports.cik_codeGET = function cik_codeGET (req, res, next, access_key, company_name, limit, offset) {
  EDGAR.cik_codeGET(access_key, company_name, limit, offset)
    .then(function (response) {
      utils.writeJson(res, response);
    })
    .catch(function (response) {
      utils.writeJson(res, response);
    });
};

module.exports.company_factsGET = function company_factsGET (req, res, next, access_key, cik_code) {
  EDGAR.company_factsGET(access_key, cik_code)
    .then(function (response) {
      utils.writeJson(res, response);
    })
    .catch(function (response) {
      utils.writeJson(res, response);
    });
};

module.exports.company_nameGET = function company_nameGET (req, res, next, access_key, cik_code) {
  EDGAR.company_nameGET(access_key, cik_code)
    .then(function (response) {
      utils.writeJson(res, response);
    })
    .catch(function (response) {
      utils.writeJson(res, response);
    });
};

module.exports.conceptAccounts_payableGET = function conceptAccounts_payableGET (req, res, next, access_key, cik_code) {
  EDGAR.conceptAccounts_payableGET(access_key, cik_code)
    .then(function (response) {
      utils.writeJson(res, response);
    })
    .catch(function (response) {
      utils.writeJson(res, response);
    });
};

module.exports.framesAccounts_payableUnitGET = function framesAccounts_payableUnitGET (req, res, next, access_key, frame, unit) {
  EDGAR.framesAccounts_payableUnitGET(access_key, frame, unit)
    .then(function (response) {
      utils.writeJson(res, response);
    })
    .catch(function (response) {
      utils.writeJson(res, response);
    });
};

module.exports.submissionsGET = function submissionsGET (req, res, next, access_key, cik_code, cik_code_name, report_from, report_to, filing_from, filing_to, accession_number) {
  EDGAR.submissionsGET(access_key, cik_code, cik_code_name, report_from, report_to, filing_from, filing_to, accession_number)
    .then(function (response) {
      utils.writeJson(res, response);
    })
    .catch(function (response) {
      utils.writeJson(res, response);
    });
};
