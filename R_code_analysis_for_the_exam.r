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

# Same process for the images of 2018
rlist_18 <- list.files(pattern="LC08_L2SP_008047_20180909")
rimp_18 <- lapply(rlist_18, raster)
l_18 <- stack(rimp_18)

# Band 2 (element 1) - Blue
# Band 3 (element 2) - Green
# Band 4 (element 3) - Red 
# Band 5 (element 4) - Near Infrared (NIR)

# Overview of the images
l_14
l_18
# The min and max values of the bands are 0 and 65535, 
# so these are 16 bit images (65536 possible values)

# Plot of all the layers
plot(l_14, col = magma(65536), axes = F)
plot(l_18, col = magma(65536), axes = F)

# Plot RGB with the correct bands in RGB
# I used the linear stretch to visualize the images as we would see from space
# And I used the histogram stretch to increase the contrast
par(mfrow=c(2, 2))
plotRGB(l_14 , r=3, g=2, b=1, stretch="lin") 
plotRGB(l_18 , r=3, g=2, b=1, stretch="lin")
plotRGB(l_14 , r=3, g=2, b=1, stretch="hist") 
plotRGB(l_18 , r=3, g=2, b=1, stretch="hist")
mtext("Linear stretch", side = 3, line = -1, outer = T)
mtext("Histogram stretch", side = 3, line = -19, outer = T)
mtext("2014                                                                                                            2018", side = 3, line = -1, outer = T)

# Plot RGB with NIR in red
par(mfrow=c(1, 2))
plotRGB(l_14 , r=4, g=3, b=2, stretch="lin") 
plotRGB(l_18 , r=4, g=3, b=2, stretch="lin")
mtext("RGB plot with NIR on red", side = 3, line = -1, outer = T)
mtext("2014                                                                                                            2018", side = 3, line = -3, outer = T)



####################################################################################
########################## CLASSIFICATION ##########################################
####################################################################################



# Classification in different n. of classes
l_14_c3 <- unsuperClass(l_14, nClasses = 3)
l_18_c3 <- unsuperClass(l_18, nClasses = 3)

l_14_c4 <- unsuperClass(l_14, nClasses = 4)
l_18_c4 <- unsuperClass(l_18, nClasses = 4)

l_14_c5 <- unsuperClass(l_14, nClasses = 5)
l_18_c5 <- unsuperClass(l_18, nClasses = 5)

# Let's see for example the classification in 5 classes 
l_14_c5
l_18_c5

# Many shades of color are not needed, the min is the number of classes
par(mfrow=c(1, 2))
plot(l_14_c5$map , col = viridis(5), axes = F) 
plot(l_18_c5$map , col = viridis(5), axes = F)
mtext("Plot with 5 classes", side = 3, line = -1, outer = T)

# Comparing the RGB images with the classified images
par(mfrow=c(2, 2))
plotRGB(l_14 , r=3, g=2, b=1, stretch="lin") 
plotRGB(l_18 , r=3, g=2, b=1, stretch="lin")
plot(l_14_c5$map , col = viridis(5), axes = F) 
plot(l_18_c5$map , col = rev(viridis(5)), axes = F)
mtext("2014                                                                                                            2018", side = 3, line = -1, outer = T)
# I used the reversed color scale to have the see with the same color

# Personalize the command "par" to build a matrix and plot the images that you need 
par(mfrow=c(2, 4))
plotRGB(l_14 , r=3, g=2, b=1, stretch="lin") 
plotRGB(l_18 , r=3, g=2, b=1, stretch="lin")
plot(l_14_c3$map , col = viridis(3), axes = F) 
plot(l_18_c3$map , col = rev(viridis(3)), axes = F)
plot(l_14_c4$map , col = viridis(4), axes = F) 
plot(l_18_c4$map , col = viridis(4), axes = F) 
plot(l_14_c5$map , col = rev(viridis(5)), axes = F) 
plot(l_18_c5$map , col = rev(viridis(5)), axes = F) 

# Cloud cover
# I'll use the 4 classes plot 
par(mfrow=c(2, 2))
plotRGB(l_14 , r=3, g=2, b=1, stretch="lin") 
plotRGB(l_18 , r=3, g=2, b=1, stretch="lin")
plot(l_14_c4$map , col = viridis(4), axes = F) 
plot(l_18_c4$map , col = viridis(4), axes = F)
mtext("2014                                                                                                            2018", side = 3, line = -1, outer = T)

# Frequencies of the 4 classes and the NA pixels
freq(l_14_c4$map)
freq(l_18_c4$map)

# Percentage of the cloud cover class 1 (2014) and classes 3 and 4 (2018)
clouds_14 <- 456430 / 60149911 * 100
clouds_18 <- (3205153 + 2007589) / 60071601 * 100
clouds_14
clouds_18

# Now do the same thing to measure the water cover
# This time, instead, we use class 3 (2014) and class 1 (2018)
water_14 <- 10015623 / 60149911 * 100
water_18 <- 8008754 / 60071601 * 100
water_14
water_18



####################################################################################
######################### SPECTRAL INDICES #########################################
####################################################################################



# Calculating the Different Vegetation Index (DVI)
# It indicates the amount of vegetation in an area (therefore also the biomass)
# DVI = NIR - red
# DVI (at 16 bit) goes from -65535 to 65535 

dvi_14 = l_14[[4]] - l_14[[3]]
dvi_18 = l_18[[4]] - l_18[[3]]

par(mfrow=c(2, 2))
plotRGB(l_14 , r=3, g=2, b=1, stretch="lin")
plotRGB(l_18 , r=3, g=2, b=1, stretch="lin")  
plot(dvi_14, col = magma(65536), main = "DVI 2014 Dominican Republic", axes = F)
plot(dvi_18, col = magma(65536), main = "DVI 2018 Dominican Republic", axes = F)
mtext("2014                                                                                                            2018", side = 3, line = -1, outer = T)

# Plot to compare the situations of DVI
par(mfrow=c(1, 2))
plot(dvi_14, col = magma(65536), main = "DVI 2014 Dominican Republic", axes = F)
plot(dvi_18, col = magma(65536), main = "DVI 2018 Dominican Republic", axes = F)

# Calculating of the difference in DVI

# dvi_dif = dvi_18 - dvi_14 # warning due to different image extents

# To not have this warning message we can do 
# a resampling to have the same size and the same extents for both images
dvi_18r <- resample(dvi_18, dvi_14)
dvi_perfect_dif = dvi_18r - dvi_14

# It's not necessary to use the DVI standardized (NDVI) 
# because both the images are al 16 bit 

# Plot of the difference in DIV 
plot(dvi_perfect_dif, col = magma(65536), 
     main = "DVI difference (2014-2018), Dominican Republic", axes = F)
# Higher values mean more vegetation in 2018 then in 2014



# Automatic calculation of the spectral indices (RStoolbox needed)
si_18 <- spectralIndices(l_18, blue=2, green=3, red=4, nir=5)
# Plot of all possible computable indices, both for naturalists and geologists
plot(si_18, col = magma(65536))

# Same for 2014
si_14 <- spectralIndices(l_14, blue=2, green=3, red=4, nir=5)
plot(si_14) # plot of all possible computable indices, both for naturalists and geologists



####################################################################################
########################### VARIABILITY ############################################
####################################################################################



nir_14 <- l_14[[4]] # dimensions : 7831, 7681, 60149911  (nrow, ncol, ncell)
nir_18 <- l_18[[4]]

# Aggregate from 30x30 resolution to 150x150 (factor = 4) to make less heavy the next step
nir_14_agg <- aggregate(nir_14, fact = 5)
nir_18_agg <- aggregate(nir_18, fact = 5)
nir_14_agg
nir_18_agg

# Standard Deviation
stdev_14 <- focal(nir_14_agg, matrix(1/25, 5, 5), fun=sd)
stdev_18 <- focal(nir_18_agg, matrix(1/25, 5, 5), fun=sd)

# Plot to see the areas with more or less variability
plot(stdev_14, col=mako(65536), axes = F)
plot(stdev_18, col=mako(65536), axes = F)
