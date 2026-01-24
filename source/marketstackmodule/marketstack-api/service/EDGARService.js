'use strict';


/**
 * Find CIK Code by Company Name
 * Endpoint provides CIK code information with a search by company name or part of the company name. For example, if you search for “APP” in the response, the endpoint will provide information on the CIK code for all of the companies that we have in the database that have “APP” (“app”) in their name. If you enter “Example LLC”, then the API will give a response with all companies having “Example LLC” in the name, Example LLC Florida, Example LLC., Example LLC International, etc.
 *
 * access_key String Your Marketstack API access key.
 * company_name String Company name (min 3 letters) used to search CIK codes.
 * limit Integer Pagination limit (results per page). Default 100, maximum 1000. (optional)
 * offset Integer Pagination offset (number of results to skip). Default 0. (optional)
 * returns CIKSearchResponse
 **/
exports.cik_codeGET = function(access_key,company_name,limit,offset) {
  return new Promise(function(resolve, reject) {
    var examples = {};
    examples['application/json'] = {
  "pagination" : {
    "total" : 5,
    "offset" : 6,
    "limit" : 0,
    "count" : 1
  },
  "data" : [ {
    "cik_code" : "cik_code",
    "company_name" : "company_name",
    "ein" : "ein",
    "sic" : "sic",
    "sic_description" : "sic_description"
  }, {
    "cik_code" : "cik_code",
    "company_name" : "company_name",
    "ein" : "ein",
    "sic" : "sic",
    "sic_description" : "sic_description"
  } ]
};
    if (Object.keys(examples).length > 0) {
      resolve(examples[Object.keys(examples)[0]]);
    } else {
      resolve();
    }
  });
}


/**
 * Company Facts
 * Returns all the company concepts data for a specific CIK.
 *
 * access_key String Your Marketstack API access key.
 * cik_code String 10-digit SEC Central Index Key (with leading zeros).
 * returns CompanyFactsByCIKResponse
 **/
exports.company_factsGET = function(access_key,cik_code) {
  return new Promise(function(resolve, reject) {
    var examples = {};
    examples['application/json'] = {
  "data" : {
    "cik" : 0,
    "company_name" : "company_name",
    "facts" : {
      "key" : {
        "key" : {
          "description" : "description",
          "label" : "label",
          "units" : {
            "key" : [ {
              "val" : 6.027456183070403,
              "accn" : "accn",
              "fy" : 1,
              "form" : "form",
              "filed" : "filed",
              "end" : "end",
              "fp" : "fp",
              "frame" : "frame"
            }, {
              "val" : 6.027456183070403,
              "accn" : "accn",
              "fy" : 1,
              "form" : "form",
              "filed" : "filed",
              "end" : "end",
              "fp" : "fp",
              "frame" : "frame"
            } ]
          }
        }
      }
    }
  }
};
    if (Object.keys(examples).length > 0) {
      resolve(examples[Object.keys(examples)[0]]);
    } else {
      resolve();
    }
  });
}


/**
 * Find Company Name by CIK Code
 * Find Company Name by CIK code, which will provide a company name with a search by the CIK Code. The CIK code must be entered with all 10 digits, including leading zeros if any. Since the CIK code is a unique code for every company, we also have CIK code validation, meaning if the CIK code is not entered in the correct format with all of the digits, we return an error for invalid CIK format. This API endpoint returns data only in case we have an exact match in the CIK code.
 *
 * access_key String Your Marketstack API access key.
 * cik_code String 10-digit SEC Central Index Key (with leading zeros).
 * returns CompanyNameByCIKResponse
 **/
exports.company_nameGET = function(access_key,cik_code) {
  return new Promise(function(resolve, reject) {
    var examples = {};
    examples['application/json'] = {
  "addresses" : {
    "business" : {
      "state_or_country" : "state_or_country",
      "zipCode" : "zipCode",
      "city" : "city",
      "street1" : "street1",
      "street2" : "street2"
    },
    "mailing" : {
      "state_or_country" : "state_or_country",
      "zipCode" : "zipCode",
      "city" : "city",
      "street1" : "street1",
      "street2" : "street2"
    }
  },
  "data" : [ {
    "Incorporationstate" : "Incorporationstate",
    "cik_code" : "cik_code",
    "phone" : "phone",
    "company_name" : "company_name",
    "ein" : "ein",
    "sic" : "sic",
    "sic_description" : "sic_description"
  }, {
    "Incorporationstate" : "Incorporationstate",
    "cik_code" : "cik_code",
    "phone" : "phone",
    "company_name" : "company_name",
    "ein" : "ein",
    "sic" : "sic",
    "sic_description" : "sic_description"
  } ]
};
    if (Object.keys(examples).length > 0) {
      resolve(examples[Object.keys(examples)[0]]);
    } else {
      resolve();
    }
  });
}


/**
 * Company Concepts for US GAAP Accounts Payable
 * This API endpoint returns all the disclosures from a single company (CIK) and concept (a taxonomy and tag) into a single JSON file, with a separate array of facts for each units on measure that the company has chosen to disclose (e.g. net profits reported in U.S. dollars and in Canadian dollars).
 *
 * access_key String Your Marketstack API access key.
 * cik_code String 10-digit SEC Central Index Key (with leading zeros).
 * returns AccountsPayableResponse
 **/
exports.conceptAccounts_payableGET = function(access_key,cik_code) {
  return new Promise(function(resolve, reject) {
    var examples = {};
    examples['application/json'] = {
  "data" : {
    "cik" : 0,
    "company_name" : "company_name",
    "us-gaap" : {
      "AccountsPayableCurrent" : {
        "description" : "description",
        "label" : "label",
        "units" : {
          "key" : [ {
            "val" : 1.4658129805029452,
            "accn" : "accn",
            "fy" : 6,
            "form" : "form",
            "filed" : "filed",
            "fp" : "fp",
            "end" : "end"
          }, {
            "val" : 1.4658129805029452,
            "accn" : "accn",
            "fy" : 6,
            "form" : "form",
            "filed" : "filed",
            "fp" : "fp",
            "end" : "end"
          } ]
        }
      }
    }
  }
};
    if (Object.keys(examples).length > 0) {
      resolve(examples[Object.keys(examples)[0]]);
    } else {
      resolve();
    }
  });
}


/**
 * Company Concepts for US GAAP Accounts Payable in a Specific Unit
 * The frames API aggregates one fact for each reporting entity that is the last filed that most closely fits the calendrical period requested. This API supports annual, quarterly, and instantaneous data. This API endpoint is made for the US-GAAP taxonomy and the Accounts Payable Current type of the taxonomy.            Where the units of measure specified in the API contain a numerator and a denominator, these are separated by “-per-” such as “USD-per-shares”. Note that the default unit in XBRL is “pure”.            The period format is CY#### for annual data (duration 365 days +/- 30 days), CY####Q# for quarterly data (duration 91 days +/- 30 days), and CY####Q#I for instantaneous data. Because company financial calendars can start and end on any month or day and even change in length from quarter to quarter according to the day of the week, the frame data is assembled by the dates that best align with a calendar quarter or year. Data users should be mindful of the different reporting start and end dates for facts contained in a frame. 
 *
 * access_key String Your Marketstack API access key.
 * frame String This is the information of the frame for which we want to receive information.
 * unit String The unit in which the data is requested. This parameter usually is USD. Validate and sanitize parameter inputs to ensure API security and expected input values.
 * returns FrameResponse
 **/
exports.framesAccounts_payableUnitGET = function(access_key,frame,unit) {
  return new Promise(function(resolve, reject) {
    var examples = {};
    examples['application/json'] = {
  "pagination" : {
    "total" : 5,
    "offset" : 6,
    "limit" : 0,
    "count" : 1
  },
  "data" : {
    "ccp" : "ccp",
    "uom" : "uom",
    "frame_data" : [ {
      "accn" : "accn",
      "val" : 6.027456183070403,
      "cik" : 0,
      "entityName" : "entityName",
      "end" : "end"
    }, {
      "accn" : "accn",
      "val" : 6.027456183070403,
      "cik" : 0,
      "entityName" : "entityName",
      "end" : "end"
    } ],
    "description" : "description",
    "taxonomy" : "taxonomy",
    "tag" : "tag",
    "label" : "label"
  }
};
    if (Object.keys(examples).length > 0) {
      resolve(examples[Object.keys(examples)[0]]);
    } else {
      resolve();
    }
  });
}


/**
 * Company Submission Data
 * Returns submission details for a specific CIK. Pass atleast one parameter `cik_code_name` or  `cik_code`
 *
 * access_key String Your Marketstack API access key.
 * cik_code String The exact 10-digit CIK code including leading zeros (e.g., `0001509697`). (optional)
 * cik_code_name String The exact 10-digit CIK code including leading zeros ending with -submissions.json (e.g., `CIK0001509697-submissions.json`). (optional)
 * report_from date Filter filings by report date from this date (YYYY-MM-DD). (optional)
 * report_to date Filter filings by report date to this date (YYYY-MM-DD). (optional)
 * filing_from date Filter filings by filing date from this date (YYYY-MM-DD). (optional)
 * filing_to date Filter filings by filing date to this date (YYYY-MM-DD). (optional)
 * accession_number String Filter filings by exact accession number (e.g., `0001193125-20-209580`). (optional)
 * returns SubmissionsByCIKResponse
 **/
exports.submissionsGET = function(access_key,cik_code,cik_code_name,report_from,report_to,filing_from,filing_to,accession_number) {
  return new Promise(function(resolve, reject) {
    var examples = {};
    examples['application/json'] = {
  "data" : {
    "former_Names" : [ {
      "name" : "name",
      "from" : "from",
      "to" : "to"
    }, {
      "name" : "name",
      "from" : "from",
      "to" : "to"
    } ],
    "website" : "website",
    "addresses" : {
      "business" : {
        "state_or_country" : "state_or_country",
        "state_or_country_desc" : "state_or_country_desc",
        "zipCode" : "zipCode",
        "city" : "city",
        "street1" : "street1",
        "street2" : "street2"
      },
      "mailing" : {
        "state_or_country" : "state_or_country",
        "state_or_country_desc" : "state_or_country_desc",
        "city" : "city",
        "street1" : "street1",
        "street2" : "street2",
        "zip_Code" : "zip_Code"
      }
    },
    "cik" : "cik",
    "insider_Transaction_For_Owner_Exists" : 0,
    "exchanges" : [ "exchanges", "exchanges" ],
    "fiscal_Year_End" : "fiscal_Year_End",
    "description" : "description",
    "owner_org" : "owner_org",
    "category_filer" : "category_filer",
    "ein" : "ein",
    "sic" : "sic",
    "tickers" : [ "tickers", "tickers" ],
    "incorporation_state_or_country" : "incorporation_state_or_country",
    "filings" : {
      "files" : [ {
        "filing_From" : "filing_From",
        "name" : "name",
        "filing_To" : "filing_To",
        "filing_Count" : 5
      }, {
        "filing_From" : "filing_From",
        "name" : "name",
        "filing_To" : "filing_To",
        "filing_Count" : 5
      } ],
      "recent" : {
        "filing_Date" : [ "filing_Date", "filing_Date" ],
        "core_type" : [ "core_type", "core_type" ],
        "acceptance_Date_Time" : [ "acceptance_Date_Time", "acceptance_Date_Time" ],
        "act" : [ "act", "act" ],
        "form" : [ "form", "form" ],
        "size" : [ 1, 1 ],
        "primary_Doc_Description" : [ "primary_Doc_Description", "primary_Doc_Description" ],
        "primary_Document" : [ "primary_Document", "primary_Document" ],
        "accession_Number" : [ "accession_Number", "accession_Number" ],
        "file_Number" : [ "file_Number", "file_Number" ],
        "report_Date" : [ "report_Date", "report_Date" ],
        "film_Number" : [ "film_Number", "film_Number" ]
      }
    },
    "entity_type" : "entity_type",
    "phone" : "phone",
    "incorporation_state_or_country_desc" : "incorporation_state_or_country_desc",
    "insider_Transaction_For_Issuer_Exists" : 6,
    "name" : "name",
    "investor_Website" : "investor_Website",
    "sic_description" : "sic_description"
  }
};
    if (Object.keys(examples).length > 0) {
      resolve(examples[Object.keys(examples)[0]]);
    } else {
      resolve();
    }
  });
}

