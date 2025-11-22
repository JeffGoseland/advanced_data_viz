# R Code from: Leaflet Tutorial
# Source: https://datasciencend.github.io/ds_canvas_webhosting/60645/Leaflet.html

# Load required packages
library(leaflet)
library(sf)

# Load shapefile
council.districts <- st_read("SampleData/City_Council_Districts.shp")

# Load CSV and convert to spatial
facilities <- read.csv("SampleData/Public_Facilities.csv")
facilities.spatial <- facilities %>%
  st_as_sf(coords = c("Lon","Lat")) %>%
  st_set_crs(value = 4326)

# Basic leaflet map with markers
leaflet() %>%
  addTiles() %>%
  addMarkers(data = facilities.spatial)

# Add popup with field reference
leaflet() %>%
  addTiles() %>%
  addMarkers(data = facilities.spatial, popup = ~POPL_NAME)

# Create custom HTML popup
facilities.spatial$popup <- paste("<b>", facilities.spatial$POPL_NAME, "</b><br>",
                                  "Type: ", facilities.spatial$POPL_TYPE, "<br>",
                                  "Phone: ", facilities.spatial$POPL_PHONE, sep = "")

leaflet() %>%
  addTiles() %>%
  addMarkers(data = facilities.spatial, popup = ~popup)

# Use circle markers with color palette
pal <- colorFactor(palette = 'Set1', domain = facilities.spatial$POPL_TYPE)

leaflet() %>%
  addTiles() %>%
  addCircleMarkers(data = facilities.spatial, 
                   popup = ~popup, 
                   color = ~pal(POPL_TYPE), 
                   stroke = 0, 
                   fillOpacity = 1, 
                   radius = 4)

# Use different basemap provider (ESRI World Imagery)
leaflet() %>%
  addProviderTiles(providers$Esri.WorldImagery) %>%
  addCircleMarkers(data = facilities.spatial, 
                   popup = ~popup, 
                   color = ~pal(POPL_TYPE), 
                   stroke = 0, 
                   fillOpacity = 1, 
                   radius = 4)

# Add layer control with multiple basemaps and overlay groups
leaflet() %>%
  addTiles(group = "Basic") %>%
  addProviderTiles(providers$Esri.NatGeoWorldMap, group = "Nat Geo") %>%
  addCircleMarkers(data = facilities.spatial, 
                   popup = ~popup, 
                   color = ~pal(POPL_TYPE), 
                   stroke = 0, 
                   fillOpacity = 1, 
                   radius = 4, 
                   group = "Facilities") %>%
  addLayersControl(
    baseGroups = c("Basic", "Nat Geo"),
    overlayGroups = c("Facilities"),
    options = layersControlOptions(collapsed = FALSE)
  )

# Note: To view all RColorBrewer palettes, run:
# RColorBrewer::display.brewer.all()