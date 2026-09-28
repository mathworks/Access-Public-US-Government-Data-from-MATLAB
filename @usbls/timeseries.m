function tData = timeseries(c,seriesids,varargin)
%TIMESERIES Retrieve data from U.S. Bureau of Labor Statistics.
%   DATA = TIMESERIES(C,S) retrieve U.S. Bureau of Labor 
%   Statistics data for series IDs.
%
%   DATA = TIMESERIES(C,S,NAME,VALUE,...) retrieves data given NAME/VALUE 
%   pair inputs.
%
%   Inputs:
%       C - usbls connection object
%       S - Series ID as string scalar, character vector, array of strings
%       or cell array of string scalars or character vectors.
%       NAME/VALUE - Additional api parameters as name-value pairs
%
%   Outputs:
%       DATA - Table containing timeseries data and metadata
%
%   For example, 
%
%   data = timeseries(c,"SERIESID");
%   data = timeseries(c,"SERIESID","startyear","2018","endyear","2019");
%   
%   See also USBLS, GETDATA, POPULAR.

%   Copyright 2026 The MathWorks, Inc.


arguments
    c (1,1) usbls
    seriesids {mustBeText}
end

arguments (Repeating)
    varargin
end

% Add series IDs to payload for data request
seriesids = cellstr(seriesids);
for i = 1:length(seriesids)
  payload.seriesid{i} = seriesids{i};
end

% Add name/value pair inputs to payload
for i = 1:2:length(varargin)
  payload.(varargin{i}) = varargin{i+1};
end

% Send data request
tData = getData(c,"POST","v2/timeseries/data",payload);