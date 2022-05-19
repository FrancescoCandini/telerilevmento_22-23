# Cambiamenti nell'uso del suolo (o land cover)

# install.packages("patchwork")

library(raster)
library(RStoolbox) # per la classificazione
library(ggplot2) # per visualizzare meglio i dati
library(patchwork)

setwd("C:/lab/defor") # set working directory; codice per caricare i dati nella cartella desiderata

l92 <- brick("defor1_.jpg")
l06 <- brick("defor2_.jpg")

plotRGB(l92, 1, 2, 3, stretch="lin")
# NIR = 1; RED = 2; GREEN = 3

# Plot di entrmbe le immagini satellitari
par(mfrow=c(1, 2))
plotRGB(l92, 1, 2, 3, stretch="lin")
plotRGB(l06, 1, 2, 3, stretch="lin")

# Classificazione delle due immagini

ggRGB(l92, 1, 2, 3, stretch="lin")
ggRGB(l06, 1, 2, 3, stretch="lin")

# Unire le due immagini, necessario il pacchetto patchwork

p1 <- ggRGB(l92, 1, 2, 3, stretch="lin")
p2 <- ggRGB(l06, 1, 2, 3, stretch="lin")

p1 + p2 # immagini affiancate
p1 / p2 # immagini una sopra l'altra

# Classificazione
l92c <- unsuperClass(l92, nClasses = 2) # classi: foresta e suolo nudo + fiume (con detriti)
l92c # è un modello, non una mappa, quindi si deve specificare $map
plot(l92c$map) # classe 1 = foresta; classe 2 = suolo e fiume
# Pixels campione scelti casualmente dal software per la creazione delle classi 

l06c <- unsuperClass(l06, nClasses = 2) # classi: foresta e suolo nudo; il fiume ha pochi detriti
plot(l06c$map)

# Calcolo delle frequenze tramite tabelle
freq(l92c$map) # classe 1: 305357 - classe 2: 35935
freq(l06c$map) # classe 1: 178176 - classe 2: 164550



# fine lezione 22/4
