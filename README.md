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
### Résumé: Sujet de reflexion sur l'analyse des données DRIAS et du risque incendie. Nous avons ici realiser une fonction principale qui à pour but de cartographier les zones à risque d'incendie selon differents facteurs. Pour cela nous avons créé plusieurs sous fonctions prenant en compte : les donées DRIAS mais aussi la desserte forestière, les axes routiers principaux, les batiments à risque, la prise en compte de l'inflammabilité et de la combustbilité. 
