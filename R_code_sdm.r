# Species Distribution Modelling (SDM)
# It's based on sampling where we extrapolate the (probability of) presence of the species 
# "in funzione delle" enviromental variables, called predictors ("predittori")
# We start from the sampling and a map of distribution of the species to arrive at a map of probability

# install.packages("sdm")
# install.packages("rgdal")

library(sdm)
library(raster) 
library(rgdal)

file <- system.file("external/species.shp", package = "sdm")
# File powered by R

species <- shapefile(file) # import a shapefile

species # 200 points with data presence-absence
species$Occurrence # presence-absence (1 or 0) of the species

plot(species, pch=19) # 
plot(species[species$Occurrence == 1,], col = "blue", pch = 16)

occ <- species$Occurrence

plot(species[occ == 1,], col = "blue", pch = 16)
points(species[occ == 0,], col = "orange", pch = 16) # function to add points to a previous graph

