### GF_UE2_R_SIG

### Title: "UE2 - Projet risques feux de forêt"
### Author: "DEBAS Adrien, FERGANI Nadjim, GIOVINAZZO Esteban, GOUFFON Valentin, VETTER Johann"
### Date: "2024-09-12"
### Output: 
  pdf_document:
    keep_tex: true
### Header-includes:
  - \setcounter{tocdepth}{10}
  - \setcounter{secnumdepth}{10}
  - \usepackage{enumitem}
  - \setlistdepth{10}

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
