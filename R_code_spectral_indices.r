# Actions needed for all the packages used in the code
# install.packages("...") 
library(raster)
library(rgdal)
library(RStoolbox)
library(rasterdiv)

setwd("C:/lab/") 

landsat1992 <- brick("defor1_.jpg") # import of the file

# Shannon's information: 1 bit could be 0 or 1 
# More bit give exponentially more values due to different combinations of the 0 and 1
landsat1992 # max at 255 because 8bit give 256 values (from 0 to 255)

plotRGB(landsat1992 ,r=1, g=2, b=3, stretch="lin")
# The vegetation is red, so the NIR band is the 1st
# and following the order the 2nd is red and the 3rd is green
# Layer 1 = NIR
# Layer 2 = red
# Layer 3 = green
# The river has the same color of the ground beacuse of the sediments inside (probably) 

landsat2006 <- brick("defor2_.jpg")

landsat2006

plotRGB(landsat2006 ,r=1, g=2, b=3, stretch="lin")

# Comparison Multiframe 
par(mfrow=c(2, 1))
plotRGB(landsat1992 ,r=1, g=2, b=3, stretch="lin")
plotRGB(landsat2006 ,r=1, g=2, b=3, stretch="lin")

# dev.off() to close the grahic processes

# Different Vegetation Index (DVI),  indicates the amount of vegetation in an area (therefore also the biomass)
# DVI = NIR - red ; theerefore DVI (at 8 bit) goes from -255 to 255
cl <- colorRampPalette(c("darkblue", "yellow", "red", "black")) (100)

dvi1992 = landsat1992[[1]] - landsat1992[[2]]
dvi2006 = landsat2006[[1]] - landsat2006[[2]]

par(mfrow=c(2, 1))
plot(dvi1992, col=cl)
plot(dvi2006, col=cl)

# Alternativeto DVI calculation using: file_name$layer_name

dvi_dif = dvi2006 - dvi1992 # warning due to different image size

plot(dvi_dif, col=colorRampPalette(c("blue", "white", "red")) (100))

dev.off()

# DVI standardized = NDVI (8 bit) from -1 to 1 (it's used to compare images at different resolution)
# At 16 bit there are 65536 valori, so DVI goes from -65535 to 65535, but NDVI is always between -1 and 1
# NDVI = DVI / (sum of different components of DVI)
# Exemple
dvi2006 = landsat2006[[1]] - landsat2006[[2]]
ndvi2006 = (landsat2006[[1]] - landsat2006[[2]]) / (landsat2006[[1]] + landsat2006[[2]])
ndvi1992 = (landsat1992[[1]] - landsat1992[[2]]) / (landsat1992[[1]] + landsat1992[[2]])
ndvi2006
ndvi1992

# Multiframe with plotRGB on top of the DVI image
par(mfrow=c(2, 1))
plotRGB(landsat1992, r=1, g=2, b=3,stretch="lin")
plot(ndvi1992, col=cl)
# The river (in the period of the image) has much dissolved sediments, therefore it has a color similar to deforested land
dev.off()

# Multiframe with NDVI1992 and NDVI2006
par(mfrow=c(2, 1))
plot(ndvi1992, col=cl)
plot(ndvi2006, col=cl)

# Automatic calculation of the spectral indices (RLtoolbox needed)
si1992 <- spectralIndices(landsat1992, green=3, red=2, nir=1)
plot(si1992) # plot of all possible computable indices, both for naturalists and geologists

# Same for 2006
si2006 <- spectralIndices(landsat2006, green=3, red=2, nir=1)
plot(si2006)

# Packege rasterdiv needed
plot(copNDVI)
