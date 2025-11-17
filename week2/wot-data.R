library(readr)
library(tidyverse)
library(janitor)

data_file <- '../data/wot-raw.csv'

wot_raw <- clean_names(read_csv(data_file))

# create character co-occurrence network
# parse book appearances into lists
wot_books <- wot_raw %>%
  mutate(books = str_split(book_appearances, ","))

# create all pairs of characters that share books
character_cooccurrence <- wot_books %>%
                          select(name, books) %>%
                          unnest(books) %>%
                          inner_join(., ., by = "books", relationship = "many-to-many") %>%
                          filter(name.x < name.y) %>%
                          group_by(name.x, name.y) %>%
                          summarise(weight = n(), .groups = "drop") %>%
                          rename(from = name.x, to = name.y)

# location-based network
location_network <- wot_books %>%
                    select(name, location, books) %>%
                    unnest(books) %>%
                    inner_join(., ., by = c("location", "books"), relationship = "many-to-many") %>%
                    filter(name.x < name.y) %>%
                    group_by(name.x, name.y, location) %>%
                    summarise(weight = n(), .groups = "drop") %>%
                    rename(from = name.x, to = name.y)

# group-based network
group_network <- wot_books %>%
                 select(name, group, books) %>%
                 unnest(books) %>%
                 inner_join(., ., by = c("group", "books"), relationship = "many-to-many") %>%
                 filter(name.x < name.y) %>%
                 group_by(name.x, name.y, group) %>%
                 summarise(weight = n(), .groups = "drop") %>%
                 rename(from = name.x, to = name.y)

write_csv(character_cooccurrence, "../data/wot-character_cooccurrence.csv")
write_csv(location_network, "../data/wot-location_network.csv")
write_csv(group_network, "../data/wot-group_network.csv")
