# GF_UE2_R_SIG

Title: "UE2 - Projet risques feux de forêt"
author: "DEBAS Adrien, FERGANI Nadjim, GIOVINAZZO Esteban, GOUFFON Valentin, VETTER Johann"
date: "2024-09-12"
output: 
  pdf_document:
    keep_tex: true
header-includes:
  - \setcounter{tocdepth}{10}
  - \setcounter{secnumdepth}{10}
  - \usepackage{enumitem}
  - \setlistdepth{10}

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
```
library(ggplot2)
