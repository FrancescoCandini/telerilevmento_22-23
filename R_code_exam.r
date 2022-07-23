# R code to analyze 2 satellite images

library(raster) # to import raster
library(RStoolbox) # to make classifications
library(ggplot2) # to better visualize the data (with plots)
library(patchwork) # to build more easily multiframes
library(viridis) # to use color scales to improve graph readability for who has some forms of color vision deficiency

setwd("C:/landsat_data")

# List of all the file with the same pattern 
rlist_14 <- list.files(pattern="LC08_L2SP_008047_20140101")

# Application of the function "raster" to all the file of the list
rimp_14 <- lapply(rlist_14, raster)

# Variable with all the images of 2014
l_14 <- stack(rimp_14) 

# Same process for the images of 2021
rlist_21 <- list.files(pattern="LC08_L2SP_008047_20210104")
rimp_21 <- lapply(rlist_21, raster)
l_21 <- stack(rimp_21) 

# Band 2 (element 1) - Blue
# Band 3 (element 2) - Green
# Band 4 (element 3) - Red 
# Band 5 (element 4) - Near Infrared (NIR)

# Overview of the images
l_14
l_21
# The min and max values of the bands are 0 and 65535, 
# so these are 16 bit images (65536 possible values)

# Plot of all the layers
plot(l_14, col = magma(65536), axes = F)
plot(l_21, col = magma(65536), axes = F)

# Plot RGB with the correct bands in RGB (Red, Green and Blue) and 2 types of stretch
par(mfrow=c(2, 2))
plotRGB(l_14 , r=3, g=2, b=1, stretch="lin") 
plotRGB(l_21 , r=3, g=2, b=1, stretch="lin")
plotRGB(l_14 , r=3, g=2, b=1, stretch="hist") 
plotRGB(l_21 , r=3, g=2, b=1, stretch="hist")
mtext("Linear stretch", side = 3, line = -2, outer = T)
mtext("Histogram stretch", side = 3, line = -19, outer = T)
mtext("2014                                                                                                                 2021", side = 3, line = -1, outer = T)

# I can also use the functions of ggplot2 package
g14lin <- ggRGB(l_14 , r=3, g=2, b=1, stretch="lin") + 
  theme(axis.text = element_blank(), axis.ticks = element_blank(), axis.title = element_blank())
g21lin <- ggRGB(l_21 , r=3, g=2, b=1, stretch="lin") + 
  theme(axis.text = element_blank(), axis.ticks = element_blank(), axis.title = element_blank())
g14hist <- ggRGB(l_14 , r=3, g=2, b=1, stretch="hist")+ 
  theme(axis.text = element_blank(), axis.ticks = element_blank(), axis.title = element_blank())
g21hist <- ggRGB(l_21 , r=3, g=2, b=1, stretch="hist") + 
  theme(axis.text = element_blank(), axis.ticks = element_blank(), axis.title = element_blank())

# Multiframe to compare the 2 RGB images in different stretch, thanks to RStoolbox
(g14lin + g21lin) / (g14hist + g21hist) 
# In the next plots I will not use the ggplot2 functions
# because I prefer the aesthetic result of the raster package functions

# Plot RGB with NIR in red
par(mfrow=c(1, 2))
plotRGB(l_14 , r=4, g=3, b=2, stretch="lin") 
plotRGB(l_21 , r=4, g=3, b=2, stretch="lin")
mtext("RGB plot with NIR on red", side = 3, line = -1, outer = T)
mtext("2014                                                                                                                 2021", side = 3, line = -2, outer = T)

par(mfrow=c(2, 1))
plotRGB(l_14 , r=4, g=3, b=2, stretch="lin") 
plotRGB(l_21 , r=4, g=3, b=2, stretch="lin")
mtext("2014", side = 3, line = -1, outer = T)
mtext("2021", side = 3, line = -27, outer = T)


####################################################################################
########################## CLASSIFICATION ##########################################
####################################################################################



# Unsupervised classification in different n. of classes

# Let's see for example the classification in 5 classes 
l_14_c5 <- unsuperClass(l_14, nClasses = 5)
l_21_c5 <- unsuperClass(l_21, nClasses = 5)

l_14_c5
l_21_c5

# Many shades of color are not needed, the min is the number of classes
par(mfrow=c(1, 2))
plot(l_14_c5$map , col = viridis(5), axes = F) 
plot(l_21_c5$map , col = viridis(5), axes = F)
mtext("2014                                                                                                                 2021", side = 3, line = -3, outer = T)

# Comparing the RGB images with the classified images
par(mfrow=c(2, 2))
plotRGB(l_14 , r=3, g=2, b=1, stretch="lin") 
plotRGB(l_21 , r=3, g=2, b=1, stretch="lin")
plot(l_14_c5$map , col = viridis(5), axes = F) 
plot(l_21_c5$map , col = viridis(5), axes = F)
mtext("2014                                                                                                                 2021", side = 3, line = -1, outer = T)
# I used the reversed color scale to have the see with the same color

par(mfrow=c(2, 1))
plot(l_14_c5$map , col = viridis(5), axes = F) 
plot(l_21_c5$map , col = viridis(5), axes = F)
mtext("2014", side = 3, line = -1, outer = T)
mtext("2021", side = 3, line = -16, outer = T)

# Water cover

# Frequencies of the 5 classes and the NA pixels
freq(l_14_c5$map)
freq(l_21_c5$map)

# Percentage of the water cover
# Class 3 for both images
water_14 <- 8109545 / 60149911 * 100
water_21 <- 7538758 / 60071601 * 100
water_14
water_21

l_14_c7 <- unsuperClass(l_14, nClasses = 7)
l_21_c7 <- unsuperClass(l_21, nClasses = 7)

par(mfrow=c(1, 2))
plot(l_14_c7$map , col = viridis(7), axes = F) 
plot(l_21_c7$map , col = viridis(7), axes = F)
mtext("2014                                                                                                                 2021", side = 3, line = -3, outer = T)

freq(l_14_c7$map)
freq(l_21_c7$map)

# 7th class for both the images
w.cover7c_14 <- 7848925 / 60149911 *100
w.cover7c_21 <- 6814020 /60071601 * 100
w.cover7c_14
w.cover7c_21

# 9 classes
l_14_c9 <- unsuperClass(l_14, nClasses = 9)
l_21_c9 <- unsuperClass(l_21, nClasses = 9)

par(mfrow=c(1, 2))
plot(l_14_c9$map , col = viridis(9), axes = F) 
plot(l_21_c9$map , col = viridis(9), axes = F)
mtext("2014                                                                                                                 2021", side = 3, line = -3, outer = T)

freq(l_14_c9$map)
freq(l_21_c9$map)

# 5th class for the image of 2014 and the 4th class for the 2021 one
w.cover9c_14 <- 7418838 / 60149911 *100
w.cover9c_21 <- 6473458 /60071601 * 100
w.cover9c_14
w.cover9c_21



####################################################################################
######################### SPECTRAL INDICES #########################################
####################################################################################



# Calculating the Different Vegetation Index (DVI)
# It indicates the amount of vegetation in an area (therefore also the biomass)
# DVI = NIR - red
# DVI (at 16 bit) goes from -65535 to 65535 

dvi_14 = l_14[[4]] - l_14[[3]]
dvi_21 = l_21[[4]] - l_21[[3]]

par(mfrow=c(2, 2))
plotRGB(l_14 , r=3, g=2, b=1, stretch="lin")
plotRGB(l_21 , r=3, g=2, b=1, stretch="lin")  
plot(dvi_14, col = magma(65536), axes = F)
plot(dvi_21, col = magma(65536), axes = F)
mtext("2014                                                                                                                  2021", side = 3, line = -1, outer = T)

# Plot to compare the situations of DVI
par(mfrow=c(1, 2))
plot(dvi_14, col = magma(65536), axes = F)
plot(dvi_21, col = magma(65536), axes = F)
mtext("2014                                                                                                                 2021", side = 3, line = -3, outer = T)

# Calculating of the difference in DVI

# dvi_dif = dvi_21 - dvi_14 # warning due to different image extents

# To not have this warning message we can do a resampling to have the same extents for both images
dvi_21r <- resample(dvi_21, dvi_14)
dvi_perfect_dif = dvi_21r - dvi_14

# It's not necessary to use the DVI standardized (NDVI) 
# because both the images are 16 bit 

# Plot of the difference in DIV 
plot(dvi_perfect_dif, col = magma(65536), 
     main = "DVI difference (2014-2021),
     Dominican Republic", axes = F)
# Higher values mean more vegetation in 2021 then in 2014



# Automatic calculation of the spectral indices (RStoolbox needed)
si_14 <- spectralIndices(l_14, blue=2, green=3, red=4, nir=5)
# Plot of all possible computable indices, both for naturalists and geologists
plot(si_14, col = magma(65536))

# Same for 2021
si_21 <- spectralIndices(l_21, blue=2, green=3, red=4, nir=5)
plot(si_21, col = magma(65536))



####################################################################################
########################### VARIABILITY ############################################
####################################################################################



nir_14 <- l_14[[4]] # dimensions : 7831, 7681, 60149911  (nrow, ncol, ncell)
nir_21 <- l_21[[4]]

# Aggregate from 30x30 resolution to 90x90 (factor = 3) to make less heavy the next step
nir_14_agg <- aggregate(nir_14, fact = 3)
nir_21_agg <- aggregate(nir_21, fact = 3)
nir_14_agg
nir_21_agg

# Standard Deviation
stdev_14 <- focal(nir_14_agg, matrix(1/49, 7, 7), fun=sd)
stdev_21 <- focal(nir_21_agg, matrix(1/49, 7, 7), fun=sd)

# Plot to see the areas with more or less variability
par(mfrow=c(1, 2))
plot(stdev_14, col = mako(65536), axes = F)
plot(stdev_21, col = mako(65536), axes = F)
mtext("2014                                                                                                                 2021", side = 3, line = -3, outer = T)
