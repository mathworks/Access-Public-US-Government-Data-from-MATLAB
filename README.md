# Access publicly available U.S. Government Data from MATLAB&reg;

## Description

This interface allows users to access data from four major U.S. government agencies directly from MATLAB:

- **U.S. Bureau of Labor Statistics (BLS)** — employment, inflation, prices, wages, and productivity data
- **U.S. Bureau of Economic Analysis (BEA)** — GDP, personal income, international trade, and regional economic data
- **U.S. Census Bureau** — population, housing, business, and geographic data
- **U.S. Energy Information Administration (EIA)** — energy production, consumption, prices, and forecasts

[![Open in MATLAB Online](https://www.mathworks.com/images/responsive/global/open-in-matlab-online.svg)](https://matlab.mathworks.com/open/github/v1?repo=mathworks/us-government-data)

## System Requirements

- MATLAB R2026b or later
- Datafeed Toolbox R2026b or later

## API Key Registration

Each agency requires a free API key. Register at the links below:

| Agency | Registration |
|--------|-------------|
| Bureau of Labor Statistics | https://data.bls.gov/registrationEngine/ |
| Bureau of Economic Analysis | https://apps.bea.gov/api/signup/ |
| Census Bureau | https://api.census.gov/data/key_signup.html |
| Energy Information Administration | https://www.eia.gov/opendata/register.php |

## U.S. Bureau of Labor Statistics (BLS)

BLS API documentation: https://www.bls.gov/developers/

BLS.gov cannot vouch for the data or analyses derived from these data after the data have been retrieved from BLS.gov.

### Create a connection

```MATLAB
apikey = "YOUR_USBLS_API_KEY";
c = usbls(apikey);
```

### Retrieve time series data

```MATLAB
% Single series
seriesID = "LAUCN040010000000005";
data = timeseries(c, seriesID);

% Multiple series with date range
seriesIDs = ["LAUCN040010000000005" "LAUCN040010000000006"];
data = timeseries(c, seriesIDs, ...
            "startyear", "2020", ...
            "endyear", "2021", ...
            "catalog", "true", ...
            "calculations", "true");
```

### Retrieve popular series

```MATLAB
% 25 most popular series
data = popular(c);

% Popular series for a specific survey
data = popular(c, "LA");
```

### List available surveys

```MATLAB
% All surveys
s = surveys(c);

% Specific survey metadata
s = surveys(c, "TU");
```

## U.S. Bureau of Economic Analysis (BEA)

This product uses the Bureau of Economic Analysis (BEA) Data API but is not endorsed or certified by BEA.

BEA API documentation: https://apps.bea.gov/api/_pdf/bea_web_service_api_user_guide.pdf

### Create a connection

```MATLAB
apikey = "YOUR_USBEA_API_KEY";
c = usbea(apikey);
```

### Explore available datasets

```MATLAB
% List all available datasets
datasets = getDatasetList(c);

% Get parameters for a dataset
params = getParameterList(c, "Regional");

% Get valid parameter values
values = getParameterValues(c, "IntlServTrade", "TradeDirection");

% Get filtered parameter values
values = getParameterValuesFiltered(c, "Regional", ...
              "LineCode", "TableName", "SAINC1");
```

### Retrieve economic data

```MATLAB
% Real GDP, annual and quarterly, all years
data = getData(c, "GET", "data", "method", "GETDATA", ...
               "DatasetName", "NIPA", ...
               "TableName", "T10101", ...
               "Frequency", "A,Q", "Year", "ALL");
GDP = struct2table(data.Data{:});
```

## U.S. Census Bureau

Census Bureau API documentation: https://www.census.gov/data/developers.html

### Create a connection

```MATLAB
apikey = "YOUR_USCENSUS_API_KEY";
c = uscensus(apikey);
```

### Retrieve census data

```MATLAB
% Population estimates by state
data = getData(c, "GET", "2021/pep/population", ...
               "get", "POP_2021,NAME", ...
               "for", "state:*");

% American Community Survey: median household income
data = getData(c, "GET", "2021/acs/acs1", ...
               "get", "B19013_001E,NAME", ...
               "for", "state:*");
```

## U.S. Energy Information Administration (EIA)

EIA API documentation: https://www.eia.gov/opendata/documentation.php

### Create a connection

```MATLAB
apikey = "YOUR_USEIA_API_KEY";
c = useia(apikey);
```

### Browse available data routes

```MATLAB
% List top-level data categories
data = getData(c, "GET");

% Explore a specific route (e.g., petroleum)
data = getData(c, "GET", "petroleum");
```

### Retrieve energy data

```MATLAB
% Crude oil prices
data = getData(c, "GET", "petroleum/pri/spt/data", ...
               "frequency", ["annual"]);

% Electricity generation by location with facet filters
data = getData(c, "GET", "electricity/electric-power-operational-data/data", ...
               "frequency", "annual", ...
               "Data", ["generation"], ...
               "Facets", struct("location", ["90"]));
```

## License

The license is available in the LICENSE.TXT file in this GitHub repository.

Community Support

[MATLAB Central](https://www.mathworks.com/matlabcentral)

Copyright 2026 The MathWorks, Inc.
