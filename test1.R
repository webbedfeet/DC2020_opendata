library(htmlwidgets)
library(leaflet)
library(tidyverse)

d <- read_csv('~/Downloads/opendatasites91819.csv', col_names = FALSE) %>% 
  set_names(c('location','url','class'))

pacman::p_load(char = c('ggmap','tmaptools','RCurl','jsonlite','tidyverse',
                        'leaflet'))
geo_d <- geocode_OSM(stringi::stri_trans_general(d$location, 'ASCII-Latin'), as.sf=TRUE)
saveRDS(geo_d, 'geocoded.rds', compress=TRUE)
d1 <- geo_d %>% left_join(d, by = c('query'='location'))

d1_intl <- d1 %>% filter(class=='International Regional') %>% 
  st_set_geometry('bbox')
d1_state <- d1 %>% filter(class == 'US State') %>% 
  st_set_geometry('bbox')
d1_city <- d1 %>% filter(class == 'US City or County') %>% 
  st_set_geometry('point')
