
# Getting started with U.S. Bureau of Economic Analysis data in MATLAB&reg;

## Description

This interface enables users to access U.S. Bureau of Economic Analysis (BEA) data directly from MATLAB. 

"This product uses the Bureau of Economic Analysis (BEA) Data API but is not endorsed or certified
by BEA." You may use the BEA name in order to identify the source of API content subject to these rules. You
may not use the BEA name, or the like to imply endorsement of any product, service, or entity, not-for-profit, commercial or otherwise.

[![Open in MATLAB Online](https://www.mathworks.com/images/responsive/global/open-in-matlab-online.svg)](https://matlab.mathworks.com/open/github/v1?repo=mathworks/usbea)

## System Requirements

- MATLAB R2026b or later
- Datafeed Toolbox R2026b or later

## Features

Users can retrieve U.S. Bureau of Economic Analysis directly from MATLAB.  API documentation can be found here:

https://apps.bea.gov/api/_pdf/bea_web_service_api_user_guide.pdf

An authenticated connection is required for all requests. Users must register for a unique UserID via the site: 

https://apps.bea.gov/api/signup/


### Create a connection to the U.S. Bureau of Economic Analysis site.

```MATLAB
apikey = "YOUR_USBEA_API_KEY";
c = usbea(apikey);
```
### Get the list of avaiable BEA datasets.

```MATLAB
datasets = getDatasetList(c);
```

### Get a list of parameters, both required and optional, for a specified dataset.

```MATLAB
dataset = "Regional"
params = getParameterList(c, dataset);
```

### Get a list of parameter values for a parameter of a given dataset. 

```MATLAB
dataset = "IntlServTrade";
parameter = "TradeDirection";
values = getParameterValues(c, dataset, parameter);
```

### Get a list of parameter values for a parameter given other parameters.

```MATLAB
dataset = "Regional";
targetparameter = "LineCode";
values = getParameterValuesFiltered(c, dataset, ...
              targetparameter, "TableName", "SAINC1");
```

### Get real gross domestic product both annually and quarterly for all years.

```MATLAB
c = usbea(apikey);
data = getData(c,"GET","data","method","GETDATA",...
               "DatasetName","NIPA",...
               "TableName","T10101",...
               "Frequency","A,Q","Year","ALL");
GDP = struct2table(data.Data{:});
```

## License

The license is available in the LICENSE.TXT file in this GitHub repository.

Community Support

MATLAB Central

Copyright 2026 The MathWorks, Inc.

