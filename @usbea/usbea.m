classdef usbea < datafeed.rest.connection
% USBEA U.S. Bureau of Economic Analysis connection.
%   C = usbea(APIKEY) creates a USBEA REST connection object using the 
%   given APIKEY. APIKEY can be input as a string
%   scalar or character vector. C is a usbea object.

%   Copyright 2026 The MathWorks, Inc.
  
  methods (Access = 'public')
  
      function c = usbea(apikey,timeout,url,mediatype,debugmodevalue)
          
        arguments
          apikey {mustBeText}
          timeout (1,1) double = 200
          url {mustBeText} = "https://apps.bea.gov/api/"
          mediatype {mustBeText} = "application/json"
          debugmodevalue (1,1) {mustBeNumeric} = 0
        end

        % Set properties of connection object for data requests
        if exist("url","var") && isempty(char(url))
          url = "https://apps.bea.gov/api/";
        end
        if exist("mediatype","var") && isempty(char(mediatype))
          mediatype = "application/json";
        end
        c = datafeed.rest.connection.setConnectionProperties(c,apikey,timeout,url,mediatype,debugmodevalue);

        % Validate the connection
        try
          getData(c,"GET","data","method","GETDATASETLIST");
        catch MException
          error(message("datafeed:toolbox:restResponseError",MException.message))
        end

      end

      function [data,response] = getData(c,httpMethod, endPointPath, varargin)
        %GETDATA Get U.S. Bureau of Economic Analysis data.
        %   DATA = GETDATA(C,HTTMETHOD,ENDPOINTPATH,NAME,VALUE,...) returns
        %   data from the U.S. Bureau of Economic Analysis.
        %
        %   Inputs:
        %       C - usbea connection object
        %       HTTMETHOD - HTTP request method type.
        %       ENDPOINTPATH - USBEA endpoint for data request.
        %       NAME/VALUE - Additional filter parameters as name-value pairs
        %
        %   Outputs:
        %       DATA - Table containing data 
        %       RESPONSE - Full matlab.net.http.ResponseMessage
        
        % USBEA adds API_KEY to URL
        varargin = [{"UserID",c.API_KEY} varargin];

        % Create the request message, USBEA currently support GET requests only
        switch lower(httpMethod)
            
          case 'get'
            
            headers = {"Content-Type", c.MediaType};
            response = sendGetRequest(c,headers,endPointPath,varargin{:});
        
        end

        % Check USBEA specific response
        if isfield(response.Body.Data.BEAAPI.Results,"Error")
          error(message("datafeed:toolbox:restResponseError",strcat(response.Body.Data.BEAAPI.Results.Error.APIErrorCode,": ",response.Body.Data.BEAAPI.Results.Error.APIErrorDescription)))
        end
        
        % Convert BEAAPI output data table
        try
          try
            resultField = fields(response.Body.Data.BEAAPI.Results);
            if isscalar(resultField)
              data = struct2table(response.Body.Data.BEAAPI.Results.(resultField{1}));
            else
              data = struct2table(response.Body.Data.BEAAPI.Results,"AsArray",true);
            end
          catch
            data = struct2table(response.Body.Data.BEAAPI.Results); 
          end
        catch
          data = response;
        end

      end

  end
  
end
