# Images captured by Landsat, the 1st was captured on 2014 and the 2nd on 2018



library(raster) # to import raster
library(RStoolbox) # to make classifications
library(ggplot2) # to better visualize the data (with plots)
library(patchwork) # to build more easily multiframes
library(viridis)

setwd("C:/landsat_data")

# List of all the file with the same pattern 
rlist_14 <- list.files(pattern="LC08_L2SP_008047_20140101")

# Application of the function "raster" to all the file of the list
rimp_14 <- lapply(rlist_14, raster)

# Variable with all the images of 2014
l_14 <- stack(rimp_14) 

# Same process for the images of 2018
rlist_18 <- list.files(pattern="LC08_L2SP_008047_20180909")
rimp_18 <- lapply(rlist_18, raster)
l_18 <- stack(rimp_18)

# Band 2 - Blue
# Band 3 - Green
# Band 4 - Red 
# Band 5 - Near Infrared (NIR)

# Overview of the images
l_14
l_18
# The min and max values of the bands are 0 and 65535, 
# so these are 16 bit images (65536 vpossible values)

# Plot of all the layers
plot(l_14, col = magma(65536))
plot(l_18, col = magma(65536))

# Plot RGB with the correct bands in RGB
# I used the linear stretch to visualize the images as we would see from space
# And I used the histogram stretch to increase the contrast
par(mfrow=c(2, 2))
plotRGB(l_14 ,r=4, g=3, b=2, stretch="lin") 
plotRGB(l_18 ,r=4, g=3, b=2, stretch="lin")
plotRGB(l_14 ,r=4, g=3, b=2, stretch="hist") 
plotRGB(l_18 ,r=4, g=3, b=2, stretch="hist")
mtext("Linear stretch", side = 3, line = -1, outer = T)
mtext("Histogram stretch", side = 3, line = -19, outer = T)

# Plot RGB with NIR in red
par(mfrow=c(1, 2))
plotRGB(l_14 ,r=5, g=4, b=3, stretch="lin") 
plotRGB(l_18 ,r=5, g=4, b=3, stretch="lin")
mtext("RGB plot with NIR on red", side = 3, line = -1, outer = T)

# Calculating the Different Vegetation Index (DVI)
# It indicates the amount of vegetation in an area (therefore also the biomass)
# DVI = NIR - red
# DVI (at 16 bit) goes from -65535 to 65535 

dvi_14 = l_14[[5]] - l_14[[4]]
dvi_18 = l_18[[5]] - l_18[[4]]

# Plot to compare the situations od DVI
par(mfrow=c(1, 2))
plot(dvi_14, col = inferno(65536), main = "DVI 2014 Dominican Republic", axes = F)
plot(dvi_18, col = inferno(65536), main = "DVI 2018 Dominican Republic", axes = F)

# Calculating of the difference in DVI

# dvi_dif = dvi_18 - dvi_14 # warning due to different image size

# To not have this warning message we can do 
# a resampling to have the same size for both images
dvi_18r <- resample(dvi_18, dvi_14)
dvi_perfect_dif = dvi_18r - dvi_14
# But this is not necessary because the difference is 0.13% compared to dvi_14

plot(dvi_perfect_dif, col = magma(65536), 
     main = "DVI difference (2014-2018), Dominican Republic", axes = F)
# Higher values mean more vegetation in 2018 then in 2014


