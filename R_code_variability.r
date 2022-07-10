# R code variability (eterogeneità)

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



# Multivariate analysis (19/5)
# It' possible to chose the component of the variability

sen <- brick("sentinel_similaun.png")
# 4 levels, 1 = nir, 2 = red, 3 = green, 4 = control
ggRGB(sen, 1, 2, 3) # vegetation is red


im1 <- ggRGB(sen, 2, 1, 3) # vegetation becomes green and rocks purple

# Multivariate analysis
sen_pca <- rasterPCA(sen)
sen_pca
# Many components: $call, $model and $map
# How much variability explains the different components?
summary(sen_pca$model) # there are also the comulative proportion
plot(sen_pca$map) # the 4th model doesn't explain anything

pc1 <- sen_pca$map$PC1
pc2 <- sen_pca$map$PC2
pc3 <- sen_pca$map$PC3

ggplot() + geom_raster(pc1, mapping=aes(x=x, y=y, fill=PC1)) 
# Different way to define the geometry, this is the most clean

g1 <- ggplot() + geom_raster(pc1, mapping=aes(x=x, y=y, fill=PC1)) 
g2 <- ggplot() + geom_raster(pc2, mapping=aes(x=x, y=y, fill=PC2)) 
g3 <- ggplot() + geom_raster(pc3, mapping=aes(x=x, y=y, fill=PC3)) 

g1 + g2 + g3

# Standard deviation of pc1
sd3_pc1 <- focal(pc1, matrix(1/9, 3, 3), fun=sd)
sd3_pc1

# Plot of standard deviation based on 1st principal components
im3 <- ggplot() + geom_raster(sd3_pc1, mapping=aes(x=x, y=y, fill=layer)) +
  scale_fill_viridis(option="inferno")
# The last part of the code determine the legend colors

# Mix of 3 different images
im1 + g1 + im3

# Variability calculated in 5x5 window
sd5_pc1 <- focal(pc1, matrix(1/25, 5, 5), fun=sd)
sd7_pc1 <- focal(pc1, matrix(1/49, 7, 7), fun=sd)

im4 <- ggplot() + geom_raster(sd5_pc1, mapping=aes(x=x, y=y, fill=layer)) +
  scale_fill_viridis(option="inferno")
im5 <- ggplot() + geom_raster(sd7_pc1, mapping=aes(x=x, y=y, fill=layer)) +
  scale_fill_viridis(option="inferno")

im3 + im4 + im5 # difference between the details determined by the dimension of the window

# fine lez. 19/5 next 2 lezioni silili/uguali
