test_that("color conversion works", {
  expect_equal(get_abgr_color("red"), "ff0000ff")
  expect_equal(get_abgr_color("blue"), "ffff0000")
  expect_equal(get_abgr_color("RED"), "ff0000ff") # Case insensitivity test
})

test_that("icon URL generation works", {
  expect_equal(
    get_icon_url("red", "pushpin"),
    "http://maps.google.com/mapfiles/kml/pushpin/red-pushpin.png"
  )
  
  expect_equal(
    get_icon_url("blue", "paddle"),
    "http://maps.google.com/mapfiles/kml/paddle/blu-circle.png"
  )
})

test_that("KML file creation", {
  # Create a temporary file
  temp_file <- tempfile(fileext = ".kml")
  
  # Sample data
  test_data <- data.frame(
    text = c("Test Location"),
    lat = 0,
    lon = 0,
    color = "red"
  )
  
  # Create KML file
  result <- create_kml(test_data, temp_file)
  
  # Check if file exists
  expect_true(file.exists(temp_file))
  
  # Check if it's a valid XML file
  expect_silent(kml_content <- xml2::read_xml(temp_file))
  
  # Check if it has the correct structure
  expect_equal(xml2::xml_name(kml_content), "kml")
  
  # Clean up
  file.remove(temp_file)
})