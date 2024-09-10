library(raster)
library(terra)
library(dplyr)
library(stars)
library(readxl)
library(tmap)
library(happign)
library(mapedit)
library(tidyverse)
library(sf)
library(stars)
library(dplyr)

# Mes fonctions ----

# inflammabilité + combustibilité peuplements
peuplement_inflammabilite <- function(X){
  pplt_aleatoire <- happign::get_wfs(X,"LANDCOVER.FORESTINVENTORY.V2:formation_vegetale")
  
  pplt_aleatoire$inflammability <- ifelse(
    pplt_aleatoire$tfv_g11 == "Forêt fermée feuillus", 20,
    ifelse(pplt_aleatoire$tfv_g11== "Forêt fermée sans couvert arboré",10,
           ifelse(pplt_aleatoire$tfv_g11 == "Forêt ouverte feuillus", 30,
                  ifelse(pplt_aleatoire$tfv_g11 == "Forêt fermée conifères", 70,
                         ifelse(pplt_aleatoire$tfv_g11 == "Forêt ouverte conifères", 80,
                                ifelse(pplt_aleatoire$tfv_g11 == "Lande", 50,
                                       ifelse(pplt_aleatoire$tfv_g11 == "Peupleraie", 10, 50)))))))
  
  
  inflama_raster <- stars::st_rasterize(pplt_aleatoire %>% 
                                          dplyr::select(inflammability, geometry))
  
  return(inflama_raster)
}

peuplement_combustibilite <- function(X){
  pplt_aleatoire <- happign::get_wfs(X,"LANDCOVER.FORESTINVENTORY.V2:formation_vegetale")
  
  pplt_aleatoire$combustibility <-ifelse(
    pplt_aleatoire$tfv_g11 == "Forêt fermée feuillus", 800,
    ifelse(pplt_aleatoire$tfv_g11== "Forêt fermée sans couvert arboré",750,
           ifelse(pplt_aleatoire$tfv_g11 == "Forêt ouverte feuillus",700,
                  ifelse(pplt_aleatoire$tfv_g11 == "Forêt fermée conifères", 300,
                         ifelse(pplt_aleatoire$tfv_g11 == "Forêt ouverte conifères", 200,
                                ifelse(pplt_aleatoire$tfv_g11 == "Lande", 500,
                                       ifelse(pplt_aleatoire$tfv_g11 == "Peupleraie", 700, 500)))))))
  
  combusti_raster <- stars::st_rasterize(pplt_aleatoire %>% 
                                           dplyr::select(combustibility, geometry),
                                         )
  return(combusti_raster)
}


# desserte

fonction_desserte <- function (shp,
                               resolution = 100){
  desserte <- happign::get_wfs(shp, "BDTOPO_V3:troncon_de_route")
  
  desserte_accessible_V <- subset(desserte, nature!="Sentier")
  
  desserte_accessible_V <- subset(desserte_accessible_V, nature!="Escalier")
  
  desserte_accessible_V$score[desserte_accessible_V$nature=="Route empierrée"] <- 5
  
  desserte_accessible_V$score[desserte_accessible_V$nature=="Route à 1 chaussée"] <- 2
  
  desserte_accessible_V$score[desserte_accessible_V$nature=="Route à 2 chaussées"] <- 1
  
  desserte_accessible_V$score[desserte_accessible_V$nature=="Chemin"] <- 9
  
  # Rasteriser le vecteur
  
  raster_desserte <- st_rasterize(desserte_accessible_V %>% 
                                    dplyr::select(score,geometry),
                                  res = resolution) 
  
  write_stars(raster_desserte, "desserte.tif")
  
  return(raster_desserte)
}

# bâtiments sensibles

fonction_bat <- function (shp,
                          buffer = 50){
  batiment <- happign::get_wfs(shp,"BDTOPO_V3:batiment")
  print(st_crs(batiment)) 
  
  batiment_buf <- st_buffer(x = batiment, 
                            buffer) 
  batiment_buf$score <- 1
  
  raster_batiment <- stars::st_rasterize(batiment_buf %>% 
                                           dplyr::select(score, geometry),
                                         )
  write_stars(raster_batiment, "batiment.tif")
  
  return(raster_batiment)
}

# axes routiers

fonction_axe_principaux <- function(zone){
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
                                                 dplyr::select(type_de_route,geometry)) 
  

  
  return(raster_Axe_principaux)
}

# Pente et topographie


# Addition des données raster
desserte_resampled <- st_warp(fonction_desserte(X), peuplement_descrip(X))
print(peuplement_descrip(X))  
print(desserte_resampled)
plot(peuplement_descrip(X)+desserte_resampled)

addition <- function(){
  X = mapedit::drawFeatures()
  liste_fonctions <- c(peuplement_inflammabilite(), peuplement_combustibilite(), 
             fonction_desserte(), fonction_bat(), fonction_axe_principaux())
  liste_raster <- c()
  
}




# brain storming
raster_nouveau <- rast(ext= ext(peuplement_descrip), resolution= 100)
peuplement_resample <- resample(peuplement_descrip(X),raster_nouveau, method= "bilinear")

happign::get_apikeys()
X = mapedit::drawFeatures()
concat_fonctions <- function(X, resolution = 100, buffer = 50) 
  message("Exécution de la fonction peuplement_descrip...")
  peuplement_result <- peuplement_descrip(X)
  message("Exécution de la fonction fonction_desserte...")
  desserte_result <- fonction_desserte(X, resolution)
  message("Exécution de la fonction fonction_bat...")
  batiment_result <- fonction_bat(X, resolution)
  print(st_crs(batiment_result))
  message("Fusion des résultats...")
  resultat_combine <- list(peuplement_inflammability = peuplement_result[[1]],
                           peuplement_combustibility = peuplement_result[[2]],
                           desserte = desserte_result,
                           batiment = batiment_result)
  print(lapply(resultat_combine, class))
  message("Sauvegarde des résultats...")
  write_stars(resultat_combine$peuplement[[1]], "peuplement_inflammability.tif")
  write_stars(resultat_combine$peuplement[[2]], "peuplement_combustibility.tif")
  write_stars(resultat_combine$desserte, "desserte.tif")
  write_stars(resultat_combine$batiment, "batiment.tif")
  return(resultat_combine)
