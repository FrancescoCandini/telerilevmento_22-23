# Temporal analysis of temperature in Greenland
library(raster)

setwd("C:/lab/greenland")

# Function "brick" to upload all the file/image in R

lst2000 <- raster("lst_2000.tif") # function to import images

lst2000 # image at 16bit

plot(lst2000)

lst2005 <- raster("lst_2005.tif")
lst2010 <- raster("lst_2010.tif")
lst2015 <- raster("lst_2015.tif")

cl <- colorRampPalette(c("blue", "light blue", "pink", "red")) (100)

par(mfrow=c(2, 2))
plot(lst2000, col=cl)
plot(lst2005, col=cl)
plot(lst2010, col=cl)
plot(lst2015, col=cl)

# How to import all the set of images at the same time

lista <- list.files(pattern = "lst_20") # I make a list of files with the same pattern in the name...
import <- lapply(lista, raster) # ...and use the function raster to all the files in the list

TGr <- stack(import)  # function to aggregate all files into a single one (similar to satellite image) 

plot(TGr, col=cl) # plot all files at the same time
plot(TGr[[1]], col=cl) # plot only the 1st element of "tgr"

plotRGB(TGr, 1, 2, 3, stretch="Lin")
plotRGB(TGr, 2, 3, 4, stretch="Lin")
plotRGB(TGr, 4, 3, 2, stretch="Lin")

# colorist package is useful to make graphic rapresentations
