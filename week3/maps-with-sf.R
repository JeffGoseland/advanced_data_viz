# R Code from: Making Maps in R with the sf model
# Source: https://datasciencend.github.io/ds_canvas_webhosting/60645/MappingInR_sf.html

# Load sf package
library(sf)

# Load a shapefile
districts <- st_read("../data/City_Council_Districts.shp", stringsAsFactors = FALSE)

# View geometry of first feature
districts[1,]$geometry

# Load CSV with lat/lon coordinates
facilities.points <- read.csv("SampleData/Public_Facilities.csv")

# Convert table to spatial object
facilities.spatial <- facilities.points %>% 
  st_as_sf(coords = c("Lon","Lat")) %>%
  st_set_crs(value = 4326)

# Basic plot with base R
plot(districts$geometry)

# Load ggmap package
library(ggmap)

# Create map with ggplot
ggplot() +
  geom_sf(data = districts)

# Color map by district
ggplot() +
  geom_sf(data = districts, aes(fill = Dist))

# Add multiple layers with legend adjustments
ggplot() +
  geom_sf(data = districts, aes(fill = Dist))+
  geom_sf(data = facilities.spatial, aes(col = POPL_TYPE), show.legend = "point") +
  guides(fill = guide_legend(override.aes = list(colour = NA)))