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

# Band 2 - Blue
# Band 3 - Green
# Band 4 - Red 
# Band 5 - Near Infrared (NIR)

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
plotRGB(l_14 ,r=4, g=3, b=2, stretch="lin") 
plotRGB(l_18 ,r=4, g=3, b=2, stretch="lin")
plotRGB(l_14 ,r=4, g=3, b=2, stretch="hist") 
plotRGB(l_18 ,r=4, g=3, b=2, stretch="hist")
mtext("Linear stretch", side = 3, line = -1, outer = T)
mtext("Histogram stretch", side = 3, line = -19, outer = T)

# Plot RGB with NIR in red
par(mfrow=c(1, 2))
plotRGB(l_14 , r=5, g=4, b=3, stretch="lin") 
plotRGB(l_18 , r=5, g=4, b=3, stretch="lin")
mtext("RGB plot with NIR on red", side = 3, line = -1, outer = T)


####################################################################################
########################## CLASSIFICATION ##########################################
####################################################################################



# Classification in classes
l_14_c <- unsuperClass(l_14, nClasses = 5)
l_18_c <- unsuperClass(l_18, nClasses = 5)

l_14_c
l_18_c

par(mfrow=c(1, 2))
plot(l_14_c$map , col = viridis(65536), axes = F) 
plot(l_18_c$map , col = viridis(65536), axes = F)
mtext("Plot with classification ", side = 3, line = -1, outer = T)

cl <- colorRampPalette(c('yellow', 'black'))(5)

# Comparing the RGB images with the classified images
par(mfrow=c(2, 2))
plotRGB(l_14 ,r=4, g=3, b=2, stretch="lin") 
plotRGB(l_18 ,r=4, g=3, b=2, stretch="lin")
plot(l_14_c$map , col = magma(65536), axes = F) 
plot(l_18_c$map , col = rev(magma(65536)), axes = F) 
# I used the reversed color scale to have the see with the same color

par(mfrow=c(2, 2))
plotRGB(l_14 ,r=4, g=3, b=2, stretch="lin") 
plotRGB(l_18 ,r=4, g=3, b=2, stretch="lin")
plot(l_14_c$map , col = viridis(5), axes = F) 
plot(l_18_c$map , col = rev(viridis(5)), axes = F) 



################################ TEST .......................................

l_14_c2 <- unsuperClass(l_14, nClasses = 2)
l_18_c2 <- unsuperClass(l_18, nClasses = 2)

l_14_c3 <- unsuperClass(l_14, nClasses = 3)
l_18_c3 <- unsuperClass(l_18, nClasses = 3)

l_14_c4 <- unsuperClass(l_14, nClasses = 4)
l_18_c4 <- unsuperClass(l_18, nClasses = 4)

l_14_c5 <- unsuperClass(l_14, nClasses = 5)
l_18_c5 <- unsuperClass(l_18, nClasses = 5)

par(mfrow=c(2, 2))
plotRGB(l_14 ,r=4, g=3, b=2, stretch="lin") 
plotRGB(l_18 ,r=4, g=3, b=2, stretch="lin")
plot(l_14_c2$map , col = viridis(2), axes = F) # possible use to measure the cloud cover
plot(l_18_c2$map , col = viridis(2), axes = F)
plot(l_14_c3$map , col = viridis(3), axes = F) 
plot(l_18_c3$map , col = viridis(3), axes = F)
plot(l_14_c4$map , col = viridis(4), axes = F) 
plot(l_18_c4$map , col = viridis(4), axes = F) 
plot(l_14_c5$map , col = rev(viridis(5)), axes = F) 
plot(l_18_c5$map , col = rev(viridis(5)), axes = F) 

############################## END TEST ............................................



freq(l_14_c$map)
freq(l_18_c$map)

# Continua se le immagini lo permettono.............................................






dev.off()









####################################################################################
######################### SPECTRAL INDICES #########################################
####################################################################################



# Calculating the Different Vegetation Index (DVI)
# It indicates the amount of vegetation in an area (therefore also the biomass)
# DVI = NIR - red
# DVI (at 16 bit) goes from -65535 to 65535 

dvi_14 = l_14[[5]] - l_14[[4]]
dvi_18 = l_18[[5]] - l_18[[4]]

par(mfrow=c(2, 2))
plotRGB(l_14 ,r=4, g=3, b=2, stretch="lin")
plotRGB(l_18 ,r=4, g=3, b=2, stretch="lin")  
plot(dvi_14, col = magma(65536), axes = F)
plot(dvi_18, col = magma(65536), axes = F)

# Plot to compare the situations od DVI
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



nir_14 <- l_14[[5]] # dimensions : 7831, 7681, 60149911  (nrow, ncol, ncell)
nir_18 <- l_18[[5]]

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









####################################################################################
####################################################################################
# Choosing of the best Color Scale

par(mfrow=c(2, 3))
plot(dvi_dif, col = mako(65536), axes = F) 
plot(dvi_dif, col = inferno(65536), axes = F) 
plot(dvi_dif, col = plasma(65536), axes = F) 
plot(dvi_dif, col = magma(65536), axes = F) 
plot(dvi_dif, col = rocket(65536), axes = F) 
plot(dvi_dif, col = viridis(65536), axes = F) 

dev.off()
####################################################################################
####################################################################################


