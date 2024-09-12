### GF_UE2_R_SIG

### Titre: "UE2 - Projet risques feux de forêt"
### Auteurs: "DEBAS Adrien, FERGANI Nadjim, GIOVINAZZO Esteban, GOUFFON Valentin, VETTER Johann"
### Date: "2024-09-12"
### Sortie: 
  pdf_document:
    keep_tex: true
    
### Les différents packages à installer 
 ```{r load_packages, include=FALSE}
library(happign)
library(raster)
library(terra)
library(dplyr)
library(stars)
library(readxl)
library(tmap)
library(mapedit)
library(tidyverse)
library(sf)
library(tinytex)
library(ggplot2)
```
### Fonctionnnement de la fonction addition_gpkg : Elle prend en entrée une zone d'étude oub demande une zone d'etude a l'operateur. elle renverra ensuite une cartographie sur les alléas et les enjeux qui definissent les risques d'incendie. Les données DRIAS devront  
### Résumé: Sujet de réflexion sur l'analyse des données DRIAS et du risque incendie. Nous avons ici réalisé une fonction principale ayant pour but de cartographier les zones à risque d'incendie selon différents facteurs. Pour cela, nous avons créé plusieurs sous-fonctions prenant en compte les données DRIAS, ainsi que la desserte forestière, les axes routiers principaux, les bâtiments à risque, l'inflammabilité et la combustibilité.
