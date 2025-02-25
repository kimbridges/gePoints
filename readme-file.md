# gePoints

> Generate KML Point Data for Google Earth/Maps

## Overview

`gePoints` is an R package that makes it easy to create KML files with customized point markers for use in Google Earth and Google Maps. It provides functions to set colors, icons, and styling for map markers from R data frames.

## Installation

You can install the development version from GitHub with:

```r
# install.packages("devtools")
devtools::install_github("kimbridges/gePoints")
```

## Usage

```r
library(gePoints)

# Create a data frame with location data
locations <- data.frame(
  text = c("New York City", "Paris", "Sydney"),
  lat = c(40.7484, 48.8584, -33.8568),
  lon = c(-73.9857, 2.2945, 151.2153),
  comment = c("Empire State Bldg", "Eiffel Tower", "Opera House"),
  color = c("yellow", "green", "lightblue"),
  symbol = c("pushpin", "paddle", "paddle"),
  symbol_scale = c(1.2, 1.5, 1.0),
  text_color = c("Yellow", "Green", "Orange"),
  text_scale = c(1.0, 1.2, 0.8)
)

# Create a KML file
create_kml(locations, "world_cities.kml")
```

## Available Styling Options

### Colors
The following colors are supported:
- red
- blue
- green
- yellow
- purple
- white
- black
- orange
- pink
- gray
- lightblue

### Symbol Types
Two symbol types are supported:
- pushpin
- paddle

## License

MIT

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.
