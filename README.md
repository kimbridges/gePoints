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

# Basic Function: Create a KML file
create_kml(locations, "world_cities.kml")
```
## Data table fields

### Required
- lat (decimal degrees for latitude)
- lon (decimal degrees for longitude)

### Optional
- text (label adjacent to the marked location)
- comment (text to go on the popup marker)
- symbol (marker type; default pushpin)
- color (symbol color; default red)
- symbol_scale (symbol size; default 1.2)
- text_color (color of the text label; default white)
- text_scale (size of the text label; default 1.0)

## Available Symbol Styling Options

### color
The following colors are supported for the icon symbols:
- red (default)
- blue
- green
- yellow
- purple
- white
- pink
- lightblue
- orange (only for paddle)

### symbol
Two symbol types are supported:
- pushpin (default)
- paddle

### symbol_scale
- value (usually between 0.5 and 2.0; default 1.2)

## License

MIT

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.
