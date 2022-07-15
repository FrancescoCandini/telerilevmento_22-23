# Images captured by Landsat, the 1st was captured on 2014 and the 2nd on 2018

# Landsat band 5 = NIR

# Intro

# install.packages("patchwork") and all the other packages

library(raster) # to import raster
library(RStoolbox) # to make classifications
library(ggplot2) # to better visualize the data (with plots)
library(patchwork) # to build more easily multiframes
library(viridis)

setwd("C:/landsat_data")

cl <- colorRampPalette(c("blue", "green", "pink", "magenta", 
                           "orange", "brown", "red", "yellow"))(100)

# List of all the file with the same pattern 
rlist_14 <- list.files(pattern="LC08_L2SP_008047_20140101")

# Application of the function "raster" to all the file of the list
rimp_14 <- lapply(rlist, raster)

# Variable with all the images of 2014
l_14 <- stack(rimp) 

# Same process for the images of 2018
rlist_18 <- list.files(pattern="LC08_L2SP_008047_20180909")
rimp_18 <- lapply(rlist, raster)
l_18 <- stack(rimp)

plot(l_14)
plot(l_18)





