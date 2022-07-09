# R code variability

# geologic variability of rocks
# ecologically variability: different use of land

# install.packages("ggplot2")

library(raster) # per l'importazione di raster
library(RStoolbox) # per la classificazione
library(ggplot2) # per visualizzare meglio i dati
library(patchwork) # per facilitare la creazione di multiframe
library(viridis)

setwd("C:/lab/") # set working directory, used to link a specific folder to the script

clsd <- colorRampPalette(c("blue", "green", "pink", "magenta", "orange", "brown", "red", "yellow"))(100)

# Import the Similaun image
sen <- brick("sentinel_similaun.png")

# Plot the image by the ggRGB function
ggRGB(sen, 1, 2, 3, stretch = "lin")
g1 <- ggRGB(sen, 1, 2, 3)
g2 <- ggRGB(sen, 2, 1, 3) # it's possible to see better the differences between the patches

# Plot with 2 graphs
g1+g2 # thx to patchwork

# variance = dev.standard^2
# Calculation of variability over NIR
nir <- sen[[1]] # NIR is very variable thx to vegetation and difference between rocks and water
nir
plot(nir)

sd3 <- focal(nir, matrix(1/9, 3, 3), fun=sd) # sd = standard deviation
# It's forbidden to use the name "sd" because it's also a name of a function
# Matrix of 3x3 pixels
plot(sd3, col=clsd)
# Blue with low variability: compact rocks (without rifts) and water
# Higher variability 

# Plot with package viridis and ggplot
ggplot() + geom_raster(sd3, mapping = aes(x=x, y=y, fill=layer)) +
  scale_fill_viridis() + ggtitle("Standard deviation by viridis package")
ggplot() + geom_raster(sd3, mapping = aes(x=x, y=y, fill=layer)) +
  scale_fill_viridis(option = "cividis") + ggtitle("Standard deviation by viridis package")
ggplot() + geom_raster(sd3, mapping = aes(x=x, y=y, fill=layer)) +
  scale_fill_viridis(option = "magma") + ggtitle("Standard deviation by viridis package")
# The rifts in the rocks, the transiction between forest and grassland are highlighted

sd7 <- focal(nir, matrix(1/49, 7, 3), fun=sd) # sd = standard deviation

# Fine lezione 29/4, le due lez. successive sono uguali
