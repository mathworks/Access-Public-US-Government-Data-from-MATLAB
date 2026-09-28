classdef uscensus < datafeed.rest.connection
%USCENSUS US Census Bureau REST connection.
%   C = USCENSUS creates a USCENSUS REST connection object using
%   the given APIKEY. C is a uscensus object.

%   Copyright 2026 The MathWorks, Inc.

  methods (Access = 'public')

    function c = uscensus(apikey,timeout,url,mediatype,debugmodevalue)

      arguments
        apikey {mustBeText} = ""
        timeout (1,1) double = 200
        url {mustBeText} = "https://api.census.gov/data/"
        mediatype {mustBeText} = "application/json"
        debugmodevalue (1,1) {mustBeNumeric} = 0
      end

      % Set properties of connection object for data requests
      c = datafeed.rest.connection.setConnectionProperties(c,apikey,timeout,url,mediatype,debugmodevalue); 

    end

    function [data,response] = getData(c,httpMethod,endPointPath,varargin)
      %GETDATA Get US Census Bureau data.
      %   DATA = GETDATA(C,HTTPMETHOD,ENDPOINTPATH,NAME,VALUE,...) returns
      %   data from the US Census Bureau.
      %
      %   Inputs:
      %     C - uscensus connection object
      %     HTTPMETHOD - HTTP request method type.
      %     ENDPOINTPATH - US Census Bureau endpoint for data request.
      %     NAME/VALUE - Additional filter parameters as name-value pairs
      %
      %   Outputs:
      %     DATA - Table containing data 
      %     RESPONSE - Full matlab.net.http.ResponseMessage  

      arguments
        c
        httpMethod {mustBeText, mustBeMember(httpMethod,["GET","get"])}
        endPointPath {mustBeText} = ""
      end

      arguments (Repeating)
        varargin
      end

      % Add API_KEY input parameters
      varargin = ["key" c.API_KEY varargin];

      headers = {"Content-Type", c.MediaType};

      % POST requests may be added a later date
      switch lower(httpMethod)

        case 'get'

          response = sendGetRequest(c,headers,endPointPath,varargin{:});

      end

      % Convert output Body Data to table
      try
        switch class(response.Body.Data)
          case {"table","string"}
            data = response.Body.Data;
          case "cell"
            data = cell2table(response.Body.Data{2}','VariableNames',response.Body.Data{1});
          case "struct"
            data = struct2table(response.Body.Data,"AsArray",true);
        end
      catch
        data = response.Body.Data;
      end
   
    end

  end

end
