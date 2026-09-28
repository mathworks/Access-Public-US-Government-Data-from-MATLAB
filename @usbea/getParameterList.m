function params = getParameterList(c, datasetName,varargin)
%GETPARAMETERLIST Get list of parameters for a specific USBEA dataset.
%   PARAMS = GETPARAMETERLIST(C, DATASETNAME) returns the list
%   of parameters available for the specified USBEA dataset.
%
%   Inputs:
%       C - usbea connection object
%       DATASETNAME - Name of the dataset
%
%   Outputs:
%       PARAMS - Table containing parameter information including:
%              - ParameterName: Name of the parameter
%              - ParameterDescription: Description of the parameter
%              - ParameterIsRequired: Whether parameter is required
%              - ParameterDataType: Data type of the parameter
%
%   Example:
%       c = usbea(apikey);
%       params = getParameterList(c, "Regional");
%
%   See also GETDATASETLIST, GETDATA, GETPARAMETERVALUES, GETPARAMETERVALUESFILTERED.

%   Copyright 2026 The MathWorks, Inc.

arguments
    c (1,1) usbea
    datasetName {mustBeText}
end

arguments (Repeating)
    varargin
end

params = getData(c,"GET","data",...
    "method","GETPARAMETERLIST", ...
    "datasetname",datasetName,varargin{:});