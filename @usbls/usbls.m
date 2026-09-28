classdef usbls < datafeed.rest.connection
%USBLS U.S. Bureau of Labor Statistics connection.
%   C = usbls(APIKEY) creates a USBLS REST connection object using the 
%   given APIKEY. APIKEY can be input as a string
%   scalar or character vector. C is a usbls object.

%   Copyright 2026 The MathWorks, Inc.
  
  methods (Access = 'public')
  
      function c = usbls(apikey,timeout,url,mediatype,debugmodevalue)
         
        arguments
          apikey {mustBeText} = ""
          timeout (1,1) double = 200
          url {mustBeText} = "https://api.bls.gov/publicAPI/"
          mediatype {mustBeText} = "application/json"
          debugmodevalue (1,1) {mustBeNumeric} = 0
        end
        
        % Set properties of connection object for data requests
        c = datafeed.rest.connection.setConnectionProperties(c,apikey,timeout,url,mediatype,debugmodevalue); 
       
      end

      function [data,response] = getData(c,httpMethod, endPointPath, payLoad, varargin)
        %GETDATA Get U.S. Bureau of Labor Statistics data.
        %   DATA = GETDATA(C,HTTMETHOD,ENDPOINTPATH,PAYLOAD,NAME,VALUE,...) returns
        %   data from the U.S. Bureau of Labor Statistics.
        %
        %   DATA = GETDATA(C,HTTMETHOD,ENDPOINTPATH,NAME,VALUE,...) returns
        %   data from the U.S. Bureau of Labor Statistics with no payload 
        %   input.
        %
        %   Inputs:
        %       C - usbls connection object
        %       HTTMETHOD - HTTP request method type.
        %       ENDPOINTPATH - USBLS endpoint for data request.
        %       PAYLOAD - HTTP request body payload input as structure.
        %       NAME/VALUE - Additional filter parameters as name-value pairs
        %
        %   Outputs:
        %       DATA - Table containing data 
        %       RESPONSE - Full matlab.net.http.ResponseMessage  
        
        % Add API_KEY to payLoad
        if exist("payLoad","var")
          if isstruct(payLoad)
            payLoad.registrationkey = c.API_KEY;
          else 
            varargin = ["registrationkey" c.API_KEY payLoad varargin];
          end
        else
          varargin = ["registrationkey" c.API_KEY];
        end

        headers = {"Content-Type", c.MediaType};

        switch lower(httpMethod)
          
          case 'get'

            response = sendGetRequest(c,headers,endPointPath,varargin{:});
            
          case 'post'

            response = sendPostRequest(c,headers,endPointPath,payLoad,varargin{:});

        end

        % Check response
        if strcmp(response.Body.Data.status,"REQUEST_NOT_PROCESSED")
          error(message("datafeed:toolbox:restResponseError",response.Body.Data.message{1}))
        end
        
        % Convert output Body Data to table
        if isempty(response.Body.Data)
          data = [];
        else
          try
            if istable(response.Body.Data)
              data = response.Body.Data;
            else
              data = struct2table(response.Body.Data,"AsArray",true);
            end
          catch
            data = response;
          end
        end

      end

  end
  
end
