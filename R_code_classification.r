# Classificazione Sole

library(raster)
library(RStoolbox)

setwd("C:/lab/")

so <- brick("Solar_Orbiter_s_first_views_of_the_Sun_pillars.jpg")

plotRGB(so, 1, 2, 3, stretch="lin")
plotRGB(so, 1, 2, 3, stretch="hist")

# Classificazione dei dati solari
cl <- colorRampPalette(c('yellow','black','red'))(100)
soc <- unsuperClass(so, nClasses=3) #
plot(soc$map, col=cl)

# set.seed can be used for repeating the experiment in the same manner for N times
# http://rfunction.com/archives/62

# fine lez. 7/4



# CLassificazione Grand Canyon

gc <- brick("dolansprings_oli_2013088_canyon_lrg.jpg")
gc

plotRGB(gc, 1, 2, 3, stretch="lin")
plotRGB(gc, r=1, g=2, b=3, stretch="hist")

# Classificazione
gcclass2 <- unsuperClass(gc, nClasses=2) # unsuper = unsupervised, cioé classificazione automatica (più veloce)
gcclass2
plot(gcclass2$map) # create 2 classi (legenda superflua) tra alcune rocce ed acqua+ombre

# set.seed(17) funzione per mantenere gli stessi pixels di campione tra i vari plot 


# Classificazione a 4
gcclass4 <- unsuperClass(gc, nClasses=4)
gcclass4

clc <- colorRampPalette(c('yellow','red','blue','black'))(100)

plot(gcclass4$map, col=clc)
# Classe con nuvole e sabbia, un'altra con ombre ed acqua ed altre 2 con 2 diversi tipi di roccia (probabilmente)
# Questa classificazione è utile per poi fare un sopralluogo e verificare le classi
# Le classi cambiano ad ogni plot

# comparare la mappa classificata con quella originale
par(mfrow=c(2,1))
plot(gcclass4$map, col=clc)
plotRGB(gc, r=1, g=2, b=3, stretch="hist") # hist per avere un'immagine più chiara


# fine lez. 21/4
