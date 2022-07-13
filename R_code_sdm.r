# Species Distribution Modelling (SDM)
# It's based on sampling where we extrapolate the (probability of) presence of the species 
# "in funzione delle" enviromental variables, called predictors ("predittori")
# We start from the sampling and a map of distribution of the species to arrive at a map of probability

# install.packages("sdm") and all the other packages

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

path <- system.file("external", package = "sdm") 
# I create a variable to simplify the finding of the files

lst <- list.files(path = path, pattern = 'asc$', full.names = T) # list of predictors
# full.names is needed in case you want to maintain the whole path in the name of the file

# list brick stack
# brick isn't needed beacuse the predictors are inside R

preds <- stack(lst)
preds # like predictors

cl <- colorRampPalette(c("blue", "orange", "red", "yellow"))(100)

# Plots of predictors
plot(preds, col = cl)

elev <- preds$elevation
prec <- preds$precipitation
temp <- preds$temperature
vege <- preds$vegetation

plot(elev, col=cl)
points(species[occ == 1,], pch = 19)

plot(prec, col=cl) + points(species[occ == 1,], col = "black", pch = 19)

plot(temp, col=cl) + points(species[occ == 1,], col = "black", pch = 16)

plot(vege, col=cl) + points(species[occ == 1,], col = "black", pch = 16)

# Creating sdm data
datasdm <- sdmData(train = species, predictors = preds)
datasdm

m1 <- sdm(Occurrence ~ elevation + precipitation + temperature + vegetation, 
    data = datasdm, methods = "glm") 
m1

# Prediction
p1 <- predict(m1, newdata = preds)

plot(p1, col = cl) + points(species[occ == 1,], col = "black", pch = 16)
# Comparison between prediction and last sampling

# Other methods: leave one out, bootsteps (?)

par(mfrow=c(2, 3))
plot(p1, col= cl)
plot(temp, col = cl)
plot(prec, col = cl)
plot(elev, col = cl)
plot(vege, col = cl)
plot(p1, col= cl) + points(species[occ == 1,], col = "black", pch = 16) # extra

# Alternative
final <- stack(preds, p1)
plot(final, col = cl)
