#' Convert common color names to ABGR format used in KML
#' @param color_name A string containing the color name
#' @return ABGR color code as string
#' @export
get_abgr_color <- function(color_name) {
  color_map <- list(
    "red"    = "ff0000ff",
    "blue"   = "ffff0000",
    "green"  = "ff00ff00",
    "yellow" = "ff00ffff",
    "purple" = "ffff00ff",
    "white"  = "ffffffff",
    "black"  = "ff000000",
    "orange" = "ff0080ff",
    "pink"   = "ffff00ff",
    "gray"   = "ff808080"
  )
  
  return(color_map[[tolower(color_name)]])
}

#' Generate Google Maps icon URL based on color and symbol type
#' @param color Color name for the icon
#' @param symbol_type Either "pushpin" or "paddle"
#' @return Complete URL for the icon
#' @export
get_icon_url <- function(color, symbol_type) {
  # Define color mappings for different symbol types
  symbol_colors <- list(
    pushpin = list(
      "white" = "wht",
      "blue"  = "blue",
      "green" = "grn",
      "yellow" = "ylw",
      "purple" = "purple",
      "lightblue" = "ltblu",
      "pink" = "pink",
      "red" = "red"
    ),
    paddle = list(
      "white" = "wht",
      "blue" = "blu",
      "lightblue" = "ltblu",
      "green" = "grn",
      "yellow" = "ylw",
      "purple" = "purple",
      "orange" = "org",
      "pink" = "pink",
      "red" = "red"
    )
  )
  
  # Select appropriate color mapping
  color_map <- if (tolower(symbol_type) == "paddle") {
    symbol_colors$paddle
  } else {
    symbol_colors$pushpin
  }
  
  # Get color code or default to red
  color_code <- color_map[[tolower(color)]] %||% "red"
  
  # Build icon URL
  base_url <- "http://maps.google.com/mapfiles/kml/"
  if (tolower(symbol_type) == "paddle") {
    return(paste0(base_url, "paddle/", color_code, "-circle.png"))
  } else {
    return(paste0(base_url, "pushpin/", color_code, "-pushpin.png"))
  }
}