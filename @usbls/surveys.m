function s = surveys(c,surveyabbr)
%SURVEYS Retrieve U.S. Bureau of Labor Statistics surveys data.
%   DATA = SURVEYS(C) retrieve U.S. Bureau of Labor 
%   Statistics surveys data. 
%
%   DATA = SURVEYS(C,SURVEYABBR) retrieve U.S. Bureau of Labor 
%   Statistics surveys data.   
%
%   Inputs:
%       C - usbls connection object.
%       SURVEYABBR - Survey abbreviation.
%
%   Outputs:
%       DATA - Table containing surveys data.
%
%   For example, 
%
%   data = surveys(c);
%   data = surveys(c,"TU");
%   
%   See also USBLS, GETDATA, POPULAR, TIMESERIES.

%   Copyright 2026 The MathWorks, Inc.

arguments
    c (1,1) usbls
    surveyabbr {mustBeText} = '';
end

% Send data request
s = getData(c,"GET",strcat("v2/surveys/",surveyabbr));

% Convert output to table if possible
if isfield(s.Results,"survey")
  s = struct2table(s.Results.survey);
end