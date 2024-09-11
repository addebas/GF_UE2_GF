
library(readxl)
library(tmap)
library(happign)
library(mapedit)
library(tidyverse)
library(sf)
library(stars)
library(dplyr)

View(happign::get_layers_metadata("wfs"))
zone <- mapedit::drawFeatures() 

fonction_axe_principaux <- function(shp,
                                    resolution = 100){
  route <- happign::get_wfs(zone,
                             "BDTOPO_V3:route_numerotee_ou_nommee")
  
  route_departementale <- route %>% mutate(type_de_route = ifelse(
    type_de_route == "Départementale", type_de_route, NA))
  
  route_autoroute <- route %>% mutate(type_de_route = ifelse(
    type_de_route == "Autoroute", type_de_route, NA))
  
  route_nommée <- route %>% mutate(type_de_route = ifelse(
    type_de_route == "Route_nommée", type_de_route, NA))
  
  route_intercommunale <- route %>% mutate(type_de_route = ifelse(
    type_de_route == "Route intercommunale", type_de_route, NA))
  
  Axe_principaux <- rbind(
    route_departementale, route_autoroute, route_intercommunale, route_nommée)
  
  Axe_principaux$score[Axe_principaux$type_de_route=="Départementale"] <- 1
  
  Axe_principaux$score[Axe_principaux$type_de_route=="Autoroute"] <- 1
  
  Axe_principaux$score[Axe_principaux$type_de_route=="Route_nommée"] <- 1
  
  Axe_principaux$score[Axe_principaux$type_de_route=="Route intercommunale"] <- 1
  
  raster_Axe_principaux <- stars::st_rasterize(Axe_principaux %>% 
                                  dplyr::select(score, geometry),
                                res = resolution) 
  
  write_stars(raster_Axe_principaux, "Axe_principaux.tif")
  
  return(raster_Axe_principaux)
  }

