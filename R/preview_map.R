#' Preview point data on a Google Maps satellite view
#'
#' Takes the same data frame as \code{create_kml()} and produces an
#' interactive Google Maps widget with satellite imagery. Intended for
#' previewing point layouts in Quarto documents and RStudio, not as a
#' replacement for the full Google Earth experience.
#'
#' @param data Dataframe containing location data. Uses the same columns
#'   as \code{create_kml()}: \code{lat}, \code{lon}, and optionally
#'   \code{text}, \code{comment}, \code{color}.
#' @param api_key Google Maps API key. If NULL, reads from the
#'   environment variable \code{GGMAP_GOOGLE_API_KEY}.
#' @param map_type Map type: \code{"satellite"} (default),
#'   \code{"roadmap"}, \code{"terrain"}, or \code{"hybrid"}.
#' @param zoom Zoom level (integer). If NULL, the map auto-fits to
#'   show all points.
#' @return A \code{googleway} map object (renders as an HTML widget).
#' @export
#' @examples
#' \dontrun{
#' locations <- data.frame(
#'   text = c("New York City", "Paris", "Sydney"),
#'   lat = c(40.7484, 48.8584, -33.8568),
#'   lon = c(-73.9857, 2.2945, 151.2153),
#'   color = c("yellow", "green", "lightblue")
#' )
#' preview_map(locations)
#' }
preview_map <- function(data,
                        api_key  = NULL,
                        map_type = "satellite",
                        zoom     = NULL) {

  # Resolve API key
  if (is.null(api_key)) {
    api_key <- Sys.getenv("GGMAP_GOOGLE_API_KEY")
    if (api_key == "") {
      stop("No API key provided. Set GGMAP_GOOGLE_API_KEY or pass api_key argument.")
    }
  }

  # Apply default color if not present
  if (!"color" %in% names(data)) {
    data$color <- "red"
  }

  # Map gePoints color names to hex for Google Maps markers
  hex_map <- list(
    "red"       = "#FF0000",
    "blue"      = "#0000FF",
    "green"     = "#00CC00",
    "yellow"    = "#FFCC00",
    "purple"    = "#9900CC",
    "white"     = "#FFFFFF",
    "black"     = "#000000",
    "orange"    = "#FF8000",
    "pink"      = "#FF66CC",
    "lightblue" = "#66CCFF",
    "gray"      = "#808080"
  )

  data$marker_color <- vapply(
    tolower(data$color),
    function(c) if (c %in% names(hex_map)) hex_map[[c]] else "#FF0000",
    character(1)
  )

  # Build info window content from text and comment columns
  data$info <- ""
  if ("text" %in% names(data)) {
    data$info <- data$text
  }
  if ("comment" %in% names(data)) {
    data$info <- ifelse(
      data$info == "",
      data$comment,
      paste0("<b>", data$info, "</b><br>", data$comment)
    )
  }

  # Calculate center
  center_lat <- mean(data$lat, na.rm = TRUE)
  center_lon <- mean(data$lon, na.rm = TRUE)

  # Auto-zoom based on geographic spread
  if (is.null(zoom)) {
    lat_range <- max(data$lat) - min(data$lat)
    lon_range <- max(data$lon) - min(data$lon)
    spread    <- max(lat_range, lon_range)
    zoom <- if (spread > 100) 2
            else if (spread > 40) 3
            else if (spread > 20) 4
            else if (spread > 10) 5
            else if (spread > 5) 6
            else if (spread > 2) 7
            else if (spread > 1) 8
            else if (spread > 0.5) 9
            else if (spread > 0.2) 10
            else if (spread > 0.1) 12
            else 14
  }

  # Create map
  m <- googleway::google_map(
    data     = data,
    key      = api_key,
    location = c(center_lat, center_lon),
    zoom     = zoom,
    map_type = map_type
  ) |>
    googleway::add_markers(
      lat        = "lat",
      lon        = "lon",
      colour     = "marker_color",
      info_window = "info"
    )

  return(m)
}
