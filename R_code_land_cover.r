# Changes in land cover use

# install.packages("patchwork")

library(raster) # to import raster
library(RStoolbox) # to make classifications
library(ggplot2) # to better visualize the data (with plots)
library(patchwork) # to build more easily multiframes

setwd("C:/lab/defor") # set working directory; code to link the folder where are our data

l92 <- brick("defor1_.jpg")
l06 <- brick("defor2_.jpg")

plotRGB(l92, 1, 2, 3, stretch="lin")
# NIR = 1; RED = 2; GREEN = 3

# Plot of both the images
par(mfrow=c(1, 2))
plotRGB(l92, 1, 2, 3, stretch="lin")
plotRGB(l06, 1, 2, 3, stretch="lin")

# Display of the two images in RGB
ggRGB(l92, 1, 2, 3, stretch="lin")
ggRGB(l06, 1, 2, 3, stretch="lin")

# Multiframe of the 2 images, patchwork needed
p1 <- ggRGB(l92, 1, 2, 3, stretch="lin")
p2 <- ggRGB(l06, 1, 2, 3, stretch="lin")

p1 + p2 # images side by side
p1 / p2 # images on top of each other

# Classification
l92c <- unsuperClass(l92, nClasses = 2) # classes: forest & land + river (with debris)
l92c # it's a model, not a map, so we must add $map to take the right component of l92c
plot(l92c$map) # class 1 = forest; class 2 = land and river
# Random sampling pixels, chosen by R to build the classes 

l06c <- unsuperClass(l06, nClasses = 2) # classes: forest and land; the river has dew debris
plot(l06c$map)

# Frequencies calculated by tables ("tabelle")
freq(l92c$map) # class 1: 305357 - class 2: 35935
freq(l06c$map) # class 1: 178176 - class 2: 164550

# Proportions
l92 # see the total number of pixels
tot92 <- 341292 # tot. number of pixels
prop_forest_92 <- 305357 /  tot92 # proportion
perc_forest_92 <- 305357 * 100 / tot92 # percentage (%)
perc_forest_92

perc_agr_92 <- 100 - perc_forest_92 # percentage of land cover by agricolture
perc_agr_92

l06
tot06 <- 342726
perc_forest_06 <- 178176 * 100 / tot06 # percentage
perc_forest_06

perc_agr_06 <- 100 - perc_forest_06 
perc_agr_06

# Finale data:
# perc_forest_92 = 89.47089 %
# perc_forest_06 = 51.98789 %
# perc_agr_92 = 10.52911 %
# perc_agr_06 = 48.01211 %

# Dataframe: table rows * columns
class <- c("Forest", "Agricolture")
percent_1992 <- c(89.47089, 10.52911)
percent_2006 <- c(51.98789, 48.01211)

multitemporal <- data.frame(class, percent_1992, percent_2006)
multitemporal
View(multitemporal) # command to see cleaner the table

# 1992
ggplot(multitemporal, aes(x=class, y=percent_1992, color=class)) +
  geom_bar(stat="identity", fill="white")
# I build a ggplot, I set up the dataframe how data source,
# after I select the columns that will make up the graph
# + indicates to add another sunction

# 2006
ggplot(multitemporal, aes(x=class, y=percent_2006, color=class)) +
  geom_bar(stat="identity", fill="white")

# How to make a pdf. We will find it in the folder selected with "setwd" 
pdf("percentages_2006.pdf")
ggplot(multitemporal, aes(x=class, y=percent_2006, color=class)) +
  geom_bar(stat="identity", fill="white")
dev.off()
