classdef useia < datafeed.rest.connection
%USEIA U.S. Energy Information Administration connection.
%   C = useia(APIKEY) creates a USEIA REST connection object using the
%   given APIKEY. APIKEY can be input as a string
%   scalar or character vector. C is a useia object.
%
%   C = useia(APIKEY,TIMEOUT,URL,MEDIATYPE,DEBUGMODEVALUE) creates a
%   USEIA REST connection object with optional parameters for timeout,
%   base URL, media type, and debug mode.

%   Copyright 2026 The MathWorks, Inc.

  methods (Access = 'public')

      function c = useia(apikey,timeout,url,mediatype,debugmodevalue)

        arguments
          apikey {mustBeText} = ""
          timeout (1,1) double = 200
          url {mustBeText} = "https://api.eia.gov/v2/"
          mediatype {mustBeText} = "application/json"
          debugmodevalue (1,1) {mustBeNumeric} = 0
        end

        % Set properties of connection object for data requests
        c = datafeed.rest.connection.setConnectionProperties(c,apikey,timeout,url,mediatype,debugmodevalue);

        % Authenticate the API KEY
        data = getData(c,"GET");
        if ismember("error",data.Properties.VariableNames)
          error(message("datafeed:toolbox:restResponseError",data.error.message))
        end

      end

      function [data,response] = getData(c,httpMethod, endPointPath, varargin)
        %GETDATA Request U.S. Energy Information Administration data.
        %   [DATA,RESPONSE] = GETDATA(C,HTTPMETHOD,URL,NAME,VALUE,...) returns useia request
        %   information given the useia connection object, C, the http request
        %   method request type, HTTPMETHOD, the endpoint from which to request
        %   the data, URL and any API flags specified by a list of name value
        %   pairs, NAME and VALUE.
        %
        %   Inputs:
        %       C - useia connection object
        %       HTTPMETHOD - HTTP request method type (GET).
        %       URL - API stub for useia endpoint.
        %       NAME/VALUE - API flags input as name-value pairs.
        %
        %   Outputs:
        %       DATA - Table containing available useia information.
        %       RESPONSE - matlab.net.http.ResponseMessage
        
        arguments
            c
            httpMethod {mustBeText, mustBeMember(httpMethod,["GET","get"])}
            endPointPath {mustBeText} = ""
        end

        arguments (Repeating)
            varargin
        end

        % Expand Data and Facets arguments into bracket-syntax parameters
        varargin = expandParams(c,varargin);

        % Add API_KEY to request parameters
        varargin = [{"api_key", c.API_KEY}, varargin];

        headers = {"Content-Type", c.MediaType};

        switch lower(httpMethod)

          case 'get'

            response = sendGetRequest(c,headers,endPointPath,varargin{:});

        end

        % Convert output Body Data to table
        if isempty(response.Body.Data)
          data = [];
        else
          % Parse response output
          try
            
              body = response.Body.Data;
            if istable(body)
              data = body;
            elseif isfield(body,"response")
              data = struct2table(body.response,"AsArray",true);
            else
              data = struct2table(body,"AsArray",true);
            end

            % Convert struct fields to tables
            fields = ["data","routes","facets"];
            for i = 1:numel(fields)
              if ismember(fields(i), data.Properties.VariableNames)
                if iscell(data.(fields(i)))
                  data.(fields(i)){1} = struct2table(data.(fields(i)){:}, "AsArray", true);
                else
                  data.(fields(i)) = {struct2table(data.(fields(i)), "AsArray", true)};
                end
              end
            end
          catch
            data = response;
          end
        end

      end

  end


  methods (Access = private)

      function params = expandParams(~,params)
        %EXPANDPARAMS Expand Data and Facets into bracket-syntax parameters.
        %   Converts "Data",["price","sales"] into repeated "data[]","price","data[]","sales"
        %   Converts "Facets",struct("stateid",["CA","TX"]) into
        %     "facets[stateid][]","CA","facets[stateid][]","TX"

        expanded = {};
        i = 1;
        while i <= numel(params)
          key = params{i};
          if ischar(key) || isstring(key)
            key = string(key);
          else
            expanded = [expanded, params(i)]; %#ok<AGROW>
            i = i + 1;
            continue
          end
          if strcmpi(key,"Data") && i < numel(params)
            vals = string(params{i+1});
            for j = 1:numel(vals)
              expanded = [expanded, {"data%5B%5D", vals(j)}]; %#ok<AGROW>
            end
            i = i + 2;
          elseif strcmpi(key,"Facets") && i < numel(params)
            facetStruct = params{i+1};
            fnames = fieldnames(facetStruct);
            for j = 1:numel(fnames)
              fname = fnames{j};
              fvals = string(facetStruct.(fname));
              for k = 1:numel(fvals)
                expanded = [expanded, {"facets%5B" + fname + "%5D%5B%5D", fvals(k)}]; %#ok<AGROW>
              end
            end
            i = i + 2;
          else
            expanded = [expanded, params(i)]; %#ok<AGROW>
            i = i + 1;
          end
        end
        params = expanded;
      end

  end

end
