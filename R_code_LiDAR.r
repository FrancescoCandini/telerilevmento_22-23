# R code for visualising and analysing LiDAR data

# install.packages("lidR")

library(raster)
library(RStoolbox)
library(ggplot2)
library(lidR) # to visualize the point cloud
library(viridis)

setwd("C:/lab/LiDAR") # set working directory, used to link a specific folder to the script

# DSM: Distant Surface Model, the upper surface of the trees in a forest 
# (heigh of the trees + heigh of the groung)
dsm_2013 <- raster("2013Elevation_DigitalElevationModel-0.5m.tif")
dsm_2013 

# DTM: Digital Terrein Model, the heigh of the surface of the ground.
dtm_2013 <- raster("2013Elevation_DigitalTerrainModel-0.5m.tif")
dtm_2013

plot(dtm_2013)

# CHM: , the absolute heigh of the trees 
chm_2013 <- dsm_2013 - dtm_2013
chm_2013
plot(chm_2013)

ggplot() + geom_raster(chm_2013, mapping=aes(x=x, y=y, fill=layer)) + 
  scale_fill_viridis(option="inferno") + ggtitle("CHM 2013 San Genesio/Jenesien")
# The greater values are due to trees. The lowest are the grassland near the town. 
# Are clearly visible the houses

# Worst resolution then the 2013
dsm_2004 <- raster("2004Elevation_DigitalElevationModel-2.5m.tif")
dtm_2004 <- raster("2004Elevation_DigitalTerrainModel-2.5m.tif")
chm_2004 <- dsm_2004 - dtm_2004

ggplot() + geom_raster(chm_2004, mapping=aes(x=x, y=y, fill=layer)) + 
  scale_fill_viridis(option="inferno") + ggtitle("CHM 2004 San Genesio/Jenesien")

# Difference in CHM
# We must change the resolution of a data or R can't make the operation
# (it's better to get worse the file with higher resolution)
# Resample (ricampionare) an image based on another one to omogenize the 2 resolutions

chm_2013r <- resample(chm_2013, chm_2004)

# An alternative it's the function "aggregate"

difference_chm <- chm_2013r - chm_2004 

ggplot() + geom_raster(difference_chm, mapping=aes(x=x, y=y, fill=layer)) + 
  scale_fill_viridis(option="inferno") + 
  ggtitle("CHM difference (2013-2004) 2004 San Genesio/Jenesien")
# Higher value: growth of trees or new houses
# Lower value: cut of a tree
# There are difference in the houses due to the resample

# Poit cluod
point_cloud <- readLAS("point_cloud.laz")

plot(point_cloud)
