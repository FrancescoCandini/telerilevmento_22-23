# Classification Sun

library(raster)
library(RStoolbox)

setwd("C:/lab/")

so <- brick("Solar_Orbiter_s_first_views_of_the_Sun_pillars.jpg")

plotRGB(so, 1, 2, 3, stretch="lin")
plotRGB(so, 1, 2, 3, stretch="hist")

# Classification of solar data
cl <- colorRampPalette(c('yellow','black','red'))(100)
soc <- unsuperClass(so, nClasses=3) #
plot(soc$map, col=cl)

# set.seed can be used for repeating the experiment in the same manner for N times
# http://rfunction.com/archives/62



# CLassification Grand Canyon

gc <- brick("dolansprings_oli_2013088_canyon_lrg.jpg")
gc

plotRGB(gc, 1, 2, 3, stretch="lin")
plotRGB(gc, r=1, g=2, b=3, stretch="hist")

# Classification
gcclass2 <- unsuperClass(gc, nClasses=2) # unsuper = unsupervised, automatic classificatione (faster)
gcclass2
plot(gcclass2$map) # 2 classes were created (unuseful legend) between some rocks and others + water + shadows

# set.seed(17) function to mantein the same sample pixels between the plots

# Classification with 4 classes
gcclass4 <- unsuperClass(gc, nClasses=4)
gcclass4

clc <- colorRampPalette(c('yellow','red','blue','black'))(100)

plot(gcclass4$map, col=clc)
# Class 1: clouds and sand
# Class 2: shadows and water
# Class 3 and 4: 2 different types of rocks (probably)
# This classification is useful to make an overview, later it's needed to verify the classes in person
# Classes change at every plot (different sample in every plot)

# Compare the map classified with the original
par(mfrow=c(2,1))
plot(gcclass4$map, col=clc)
plotRGB(gc, r=1, g=2, b=3, stretch="hist") # hist to have a better image
