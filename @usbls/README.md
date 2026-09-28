# Getting Started with U.S. Bureau of Labor Statistics (BLS) Data in MATLAB&reg;

## Description

This interface allows users to access U.S. Bureau of Labor Statistics data directly from MATLAB. 

BLS.gov cannot vouch for the data or analyses derived from these data after the data have been retrieved from BLS.gov.

[![Open in MATLAB Online](https://www.mathworks.com/images/responsive/global/open-in-matlab-online.svg)](https://matlab.mathworks.com/open/github/v1?repo=mathworks/usbls)


## System Requirements

- MATLAB R2026b or later
- Datafeed Toolbox R2026b or later

## Features

Users can retrieve U.S. Bureau of Labor Statistics data directly from MATLAB. BLS API documentation for time series data, popular series, and surveys can be found here: 

https://www.bls.gov/developers/

An authenticated connection is required for all requests. Users must register for a unique UserID via the site: 

https://data.bls.gov/registrationEngine/


### Create a connection to the U.S. Bureau of Labor Statistics site.

```MATLAB
apikey = "YOUR_USBLS_API_KEY";
c = usbls(apikey);
```

### Get time series data for one or multiple series id's.

```MATLAB
seriesID = "LAUCN040010000000005";
data = timeseries(c, seriesID);
tsData = data.Results.series;

seriesIDs = ["LAUCN040010000000005" "LAUCN040010000000006"];
data = timeseries(c, seriesIDs);
tsData = data.Results.series;

data = timeseries(c, seriesIDs, ...
            "startyear", "2020", ...
            "endyear", "2021", ...
            "catalog", "true", ...
            "calculations", "true");

```

### Get a list of the of the series IDs for the 25 most popular and survey-specfic series.

```MATLAB
data = popular(c);
data = popular(c,"LA");
```
### Get a list of all available surveys or metadata associated with a single survey;
```MATLAB
s = surveys(c);
s = surveys(c,"TU");
```

## License

The license is available in the LICENSE.TXT file in this GitHub repository.

Community Support

MATLAB Central

Copyright 2026 The MathWorks, Inc.
