rm(list = ls())


# install.packages(c("sf", "ggplot2", "leaflet", "dplyr"))

library(sf)
library(ggplot2)
library(leaflet)
library(dplyr)
library(tmap)
ttm()
library(terra)
library(tidyverse)
library(stars)

# chargement du jeu de données ----

indices_feu <-
  read.table(
    "D:/COURS_APT/3A/R_SIG_projet/indicesALADIN63_CNRM-CM5_24090913012904838.KEYuAuU7dD1Uudu0Od00fOx.txt",
    sep = ";",
    quote = "\""
  )

safran <- st_read("D:/COURS_APT/3A/R_SIG_projet/safran.gpkg")

get.drias.gpkg <-
  function(safran = safran,
           indices_feu = indices_feu) {
    # passage des coordonnées en métrique pour le calcul des dalles ----
    
    indices_feu_sf <-
      st_as_sf(indices_feu, coords = c("V3", "V2"), crs = 4326)
    
    
    
    # jointure safran/drias ----
    
    safran_drias <- st_join(safran, indices_feu_sf)
    
    safran_drias <- safran_drias[!is.na(safran_drias$V1), ]
    
    # arrondi des indicateurs à l'unité
    
    safran_drias$V12 <- round(safran_drias$V12, 0)
    safran_drias$V12 <- as.integer(safran_drias$V12)
    
    safran_drias_proche <- safran_drias[safran_drias$V5 == "H1", ]
    safran_drias_moyen <- safran_drias[safran_drias$V5 == "H2", ]
    safran_drias_lointain <- safran_drias[safran_drias$V5 == "H3", ]
    
    
    # rasterize ----
    
    st_write(safran_drias_proche, "drias.gpkg", layer = "ifmx_rcp_8_5_proche")
    st_write(safran_drias_moyen, "drias.gpkg", layer = "ifmx_rcp_8_5_moyen")
    st_write(safran_drias_lointain, "drias.gpkg", layer = "ifmx_rcp_8_5_lointain")
    
  }

get.drias.gpkg(safran, indices_feu)
