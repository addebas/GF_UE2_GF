

# Mes fonctions ----

# inflammabilité + combustibilité peuplements
peuplement_descrip <- function(X, resolution= 100 ){
  pplt_aleatoire <- happign::get_wfs(X,"LANDCOVER.FORESTINVENTORY.V2:formation_vegetale")
  
  plot(pplt_aleatoire)
  pplt_aleatoire$inflammability <- ifelse(
    pplt_aleatoire$tfv_g11 == "Forêt fermée feuillus", 20,
    ifelse(pplt_aleatoire$tfv_g11== "Forêt fermée sans couvert arboré",10,
           ifelse(pplt_aleatoire$tfv_g11 == "Forêt ouverte feuillus", 30,
                  ifelse(pplt_aleatoire$tfv_g11 == "Forêt fermée conifères", 70,
                         ifelse(pplt_aleatoire$tfv_g11 == "Forêt ouverte conifères", 80,
                                ifelse(pplt_aleatoire$tfv_g11 == "Lande", 50,
                                       ifelse(pplt_aleatoire$tfv_g11 == "Peupleraie", 10, 50)))))))
  
  
  pplt_aleatoire$combustibility <-ifelse(
    pplt_aleatoire$tfv_g11 == "Forêt fermée feuillus", 800,
    ifelse(pplt_aleatoire$tfv_g11== "Forêt fermée sans couvert arboré",750,
           ifelse(pplt_aleatoire$tfv_g11 == "Forêt ouverte feuillus",700,
                  ifelse(pplt_aleatoire$tfv_g11 == "Forêt fermée conifères", 300,
                         ifelse(pplt_aleatoire$tfv_g11 == "Forêt ouverte conifères", 200,
                                ifelse(pplt_aleatoire$tfv_g11 == "Lande", 500,
                                       ifelse(pplt_aleatoire$tfv_g11 == "Peupleraie", 700, 500)))))))
  
  inflama_raster <- stars::st_rasterize(pplt_aleatoire %>% 
                                          dplyr::select(inflammability, geometry),
                                        res=resolution)
  
  combusti_raster <- stars::st_rasterize(pplt_aleatoire %>% 
                                           dplyr::select(combustibility, geometry),
                                         res= resolution)
  return(c(inflama_raster, combusti_raster))
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
                          resolution = 100,
                          buffer = 50){
  batiment <- happign::get_wfs(shp,"BDTOPO_V3:batiment")
  print(st_crs(batiment)) 
  
  batiment_buf <- st_buffer(x = batiment, 
                            buffer) 
  batiment_buf$score <- 1
  
  raster_batiment <- stars::st_rasterize(batiment_buf %>% 
                                           dplyr::select(score, geometry)
                                         res= resolution)
  write_stars(raster_batiment, "batiment.tif")
  
  return(raster_batiment)
}








































































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
}
