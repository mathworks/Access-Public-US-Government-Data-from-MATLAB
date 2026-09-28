function data = getDatasetList(c,varargin)
%GETDATASETLIST Get all available U.S. Bureau of Economic Analysis datasets.
%   DATA = GETDATASETLIST(C) returns a list of all datasets available 
%   from the U.S. Bureau of Economic Analysis.
%
%   Inputs:
%       C - usbea connection object
%
%   Outputs:
%       DATA - Table containing dataset information including:
%              - DatasetName: Name of the dataset
%              - DatasetDescription: Description of the dataset
%
%   Example:
%       c = usbea(apikey);
%       [data, response] = getDatasetList(c);
%
%   See also GETPARAMETERLIST, GETDATA, GETPARAMETERVALUES, GETPARAMETERVALUESFILTERED.

%   Copyright 2026 The MathWorks, Inc.

arguments
    c (1,1) usbea
end

arguments (Repeating)
    varargin
end

data = getData(c,"GET","data","method","GETDATASETLIST",varargin{:});