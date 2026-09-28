function values = getParameterValuesFiltered(c, datasetName, targetParameter, varargin)
%GETPARAMETERVALUESFILTERED Get filtered USBEA parameter values based on other parameters.
%   VALUES = GETPARAMETERVALUESFILTERED(C,DATASETNAME,TARGETPARAMETER,NAME,VALUE,...)
%   returns filtered values for a target parameter based on other parameter constraints.
%
%   Inputs:
%       C - usbea connection object
%       DATASETNAME - Name of the dataset input as string
%                     scalar or character vector
%       TARGETPARAMETER - Parameter to get values for input as string
%                         scalar or character vector
%       NAME/VALUE - Additional filter parameters as name-value pairs
%
%   Outputs:
%       VALUES - Table containing filtered parameter values
%
%   Examples:
%       c = usbea(apikey);
%       
%       % Get LineCode values for SAINC1 table
%       [values, response] = getParameterValuesFiltered(c, "Regional", ...
%           "LineCode", "TableName", "SAINC1");
%       
%       % Get Year values for specific table and location
%       [values, response] = getParameterValuesFiltered(c, "Regional", ...
%           "Year", "TableName", "CAINC5N", "GeoFips", "01001");
%
%   See also GETDATASETLIST, GETPARAMETERLIST, GETDATA, GETPARAMETERVALUES.

%   Copyright 2026 The MathWorks, Inc.

arguments
    c (1,1) usbea
    datasetName {mustBeText}
    targetParameter {mustBeText}
end

arguments (Repeating)
    varargin
end

values = getData(c,"GET","data", ...
    "method","GETPARAMETERVALUESFILTERED", ...
    "datasetname",datasetName, ...
    "TargetParameter",targetParameter, ...
    varargin{:});