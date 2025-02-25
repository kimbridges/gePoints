#' @title gePoints: Generate KML Point Data for Google Earth/Maps
#' @description Tools for creating KML files with customized point markers for
#' use in Google Earth and Google Maps. Provides functions to set colors,
#' icons, and styling for map markers from R data frames.
#' 
#' @docType package
#' @name gePoints
NULL

#' Create a KML file from location data
#' @param data Dataframe containing location data with columns:
#'   \itemize{
#'     \item \code{text} - Text label for the marker
#'     \item \code{lat} - Latitude (decimal degrees)
#'     \item \code{lon} - Longitude (decimal degrees)
#'     \item \code{comment} - (Optional) Additional information
#'     \item \code{color} - (Optional) Marker color
#'     \item \code{symbol} - (Optional) Marker type ("pushpin" or "paddle")
#'     \item \code{symbol_scale} - (Optional) Size of the symbol (default: 1.2)
#'     \item \code{text_color} - (Optional) Color of the text label (default: "white")
#'     \item \code{text_scale} - (Optional) Size of the text label (default: 1.0)
#'   }
#' @param output_file Output KML filename (default: "locations.kml")
#' @return Invisibly returns the path to the created KML file
#' @export
#' @examples
#' \dontrun{
#' locations <- data.frame(
#'   text = c("New York City", "Paris", "Sydney"),
#'   lat = c(40.7484, 48.8584, -33.8568),
#'   lon = c(-73.9857, 2.2945, 151.2153),
#'   comment = c("Empire State Bldg", "Eiffel Tower", "Opera House"),
#'   color = c("yellow", "green", "lightblue")
#' )
#' create_kml(locations, "world_cities.kml")
#' }
create_kml <- function(data, output_file = "locations.kml") {
  # Set default styling values if not provided
  default_styles <- list(
    symbol = "pushpin",
    symbol_scale = 1.2,
    text_color = "white",
    text_scale = 1.0,
    color = "red"
  )
  
  # Apply defaults where missing
  for (style in names(default_styles)) {
    if (!style %in% names(data)) {
      data[[style]] <- default_styles[[style]]
    }
  }
  
  # Create KML document structure
  kml <- xml2::xml_new_root("kml", xmlns = "http://www.opengis.net/kml/2.2")
  doc <- xml2::xml_add_child(kml, "Document")
  
  # Generate unique styles
  styles <- create_styles(data, doc)
  
  # Add placemarks
  add_placemarks(data, doc, styles)
  
  # Write KML file
  xml2::write_xml(kml, output_file)
  message("KML file created successfully: ", output_file)
  
  # Return path invisibly
  invisible(output_file)
}

#' Create styles for KML markers
#' @param data Dataframe with style information
#' @param doc XML document node
#' @return List mapping style keys to style IDs
#' @keywords internal
create_styles <- function(data, doc) {
  style_map <- list()
  style_counter <- 1
  
  for (i in seq_len(nrow(data))) {
    style_key <- paste(
      data$color[i],
      data$symbol[i],
      data$symbol_scale[i],
      data$text_color[i],
      data$text_scale[i],
      sep = "_"
    )
    
    if (!style_key %in% names(style_map)) {
      style_id <- paste0("style", style_counter)
      style_map[[style_key]] <- style_id
      style_counter <- style_counter + 1
      
      add_style_to_doc(doc, style_id, data[i, ])
    }
  }
  
  return(style_map)
}

#' Add a style definition to the KML document
#' @param doc XML document node
#' @param style_id Style identifier
#' @param style_data Single row of data with style information
#' @keywords internal
add_style_to_doc <- function(doc, style_id, style_data) {
  style <- xml2::xml_add_child(doc, "Style", id = style_id)
  
  # Icon style
  icon_style <- xml2::xml_add_child(style, "IconStyle")
  xml2::xml_add_child(icon_style, "scale", as.character(style_data$symbol_scale))
  icon <- xml2::xml_add_child(icon_style, "Icon")
  xml2::xml_add_child(icon, "href", 
                get_icon_url(style_data$color, style_data$symbol))
  
  # Label style
  label_style <- xml2::xml_add_child(style, "LabelStyle")
  xml2::xml_add_child(label_style, "scale", as.character(style_data$text_scale))
  xml2::xml_add_child(label_style, "color", get_abgr_color(style_data$text_color))
}

#' Add placemarks to the KML document
#' @param data Dataframe with location data
#' @param doc XML document node
#' @param styles Style mapping list
#' @keywords internal
add_placemarks <- function(data, doc, styles) {
  for (i in seq_len(nrow(data))) {
    placemark <- xml2::xml_add_child(doc, "Placemark")
    xml2::xml_add_child(placemark, "name", data$text[i])
    
    # Add style reference
    style_key <- paste(
      data$color[i],
      data$symbol[i],
      data$symbol_scale[i],
      data$text_color[i],
      data$text_scale[i],
      sep = "_"
    )
    xml2::xml_add_child(placemark, "styleUrl", paste0("#", styles[[style_key]]))
    
    # Add comment if available
    if ("comment" %in% names(data)) {
      xml2::xml_add_child(placemark, "comment", data$comment[i])
    }
    
    # Add coordinates
    point <- xml2::xml_add_child(placemark, "Point")
    coords <- sprintf("%f,%f,0", data$lon[i], data$lat[i])
    xml2::xml_add_child(point, "coordinates", coords)
  }
}