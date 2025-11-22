# R Code from: Geocoding and Routing Tutorial
# Source: https://datasciencend.github.io/ds_canvas_webhosting/60645/GeocodingRouting.html

# Load ggmap package
library("ggmap")

# Register Google API key
register_google(key = "363cb451-d367-48e6-b227-6c4b6de057d1")

# Define addresses
house <- "712 West LaSalle Ave, South Bend IN 46601"
work <- "Hesburgh Library, University of Notre Dame"

# Basic geocoding
geocode(house)

# Geocode with bad address (returns coordinates anyway)
geocode("100 Totally Fake Street, South Bend IN 46617")

# Geocode with address output
geocode("100 Totally Fake Street, South Bend IN 46617", output = "latlona")

# Geocode with more details (accuracy information)
geocode("100 Totally Fake Street, South Bend IN 46617", output = "more")

# Create dataframe with addresses
address.df <- data.frame(
  address_in = c("712 West LaSalle Ave, South Bend IN 46601", 
                 "Hesburgh Library, University of Notre Dame, Notre Dame, IN 46656", 
                 "Notre Dame Stadium", 
                 "1047 Lincoln Way West South Bend, IN 46601",
                 "227 W Jefferson Blvd South Bend, IN 46601"),
  id = c(1:5)
)

# Batch geocoding with mutate_geocode
address.df.geocoded <- address.df %>%
  mutate_geocode(address_in, output = "more")

# Manual geocoding loop with error handling
for(i in 1:nrow(address.df)){
  result <- geocode(as.character(address.df$address_in[i]), 
                    output = "latlona", 
                    source = "google")
  while(is.na(result[1])){ # checks if the latitude is NA and reruns if it is
    Sys.sleep(2) # Pauses for 2 seconds to let the API Catch up
    result <- geocode(as.character(address.df$address_in[i]), 
                      output = "latlona", 
                      source = "google")
  }
  address.df$lon[i] <- as.numeric(result[1])
  address.df$lat[i] <- as.numeric(result[2])
  address.df$geoAddress[i] <- as.character(result[3])
}

head(address.df)

# Get distance and travel time between two points
library(ggmap)
mapdist(from = house, to = work)

# Get distance with different travel mode
mapdist(from = house, to = work, mode = "bicycling")

# Get route with steps
towork <- route(from = house, 
                to = work, 
                mode = "bicycling", 
                alternatives = T, 
                structure = "legs")

head(towork)

# Get basemap and plot route
southbend <- get_map("leeper park, South Bend, IN", zoom = 14, maptype = "roadmap")

ggmap(southbend) +
  geom_leg(aes(x = start_lon, y = start_lat, 
               xend = end_lon, yend = end_lat,
               colour = route),
           alpha = .5, 
           linewidth = 2, 
           data = towork)

# Using tidygeocoder package (free alternative)
library(tidygeocoder)

# Single address geocoding
geo("University of Notre Dame, Notre Dame IN 46556")

# Batch geocoding with tidygeocoder
tidy.geocoded <- geocode(address.df, address = address_in)
tidy.geocoded