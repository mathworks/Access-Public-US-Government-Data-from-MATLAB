function s = popular(c,surveyabbr,varargin)
%POPULAR Retrieve most popular series IDs for U.S. Bureau of Labor Statistics.
%   DATA = POPULAR(C) retrieve the 25 most popular U.S. Bureau of Labor 
%   Statistics series IDs. 
%
%   DATA = POPULAR(C,SURVEYABBR) retrieves series information for given
%   survey abbreviation.
%
%   Inputs:
%       C - usbls connection object.
%       SURVEY - Survey abbreviation.
%
%   Outputs:
%       DATA - Table of 25 most popular series ID or most popular ID's associated with a survey abbreviation.
%
%   For example, 
%
%   data = popular(c);
%   data = popular(c,"survey","LA");
%   
%   See also USBLS, GETDATA, TIMESERIES.

%   Copyright 2026 The MathWorks, Inc.


arguments
    c (1,1) usbls
    surveyabbr {mustBeText} = ''
end

arguments (Repeating)
    varargin
end

% Create URL for request
if ~isempty(surveyabbr)
  varargin = ["survey" surveyabbr varargin];
end

% Send data request
s = getData(c,"GET","v2/timeseries/popular",varargin{:});

% Convert output to table if possible
if isfield(s.Results,"series")
  s = struct2table(s.Results.series);
end
