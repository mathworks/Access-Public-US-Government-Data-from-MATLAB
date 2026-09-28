function values = getParameterValues(c, datasetName, parameterName,varargin)
%GETPARAMETERVALUES Get valid values for a specific parameter
%   VALUES = GETPARAMETERVALUES(C, DATASETNAME, PARAMETERNAME) returns the 
%   list of valid values for a specific parameter in a dataset.
%
%   Inputs:
%       C - usbea connection object
%       DATASETNAME - Name of the dataset (e.g., "Regional", "NIPA", "IntlServTrade")
%       PARAMETERNAME - Name of the parameter (e.g., "Year", "TableName", "TradeDirection")
%
%   Outputs:
%       VALUES - Table containing parameter values and descriptions
%
%   Example:
%       c = usbea(apikey);
%       values, response = getParameterValues(c, "IntlServTrade", "TradeDirection");
%
%   See also GETDATASETLIST, GETPARAMETERLIST, GETDATA, GETPARAMETERVALUESFILTERED.

%   Copyright 2026 The MathWorks, Inc.

arguments
    c (1,1) usbea
    datasetName {mustBeText}
    parameterName {mustBeText}
end

arguments (Repeating)
    varargin
end

values= getData(c,"GET","data", ...
    "method","GETPARAMETERVALUES", ...
    "datasetname",datasetName, ...
    "ParameterName",parameterName,varargin{:});