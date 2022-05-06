# Analisi in serie temporale della Groenlandia

library(raster)

setwd("C:/lab/greenland")

# La funzione "brick" caricare tutte le bande (di un'immagine completa) in R

lst2000 <- raster("lst_2000.tif") # funzione per importare immagini 

lst2000 # immagine a 16bit

plot(lst2000)

lst2005 <- raster("lst_2005.tif")
lst2010 <- raster("lst_2010.tif")
lst2015 <- raster("lst_2015.tif")

dev.off()

cl <- colorRampPalette(c("blue", "light blue", "pink", "red")) (100)

par(mfrow=c(2, 2))
plot(lst2000, col=cl)
plot(lst2005, col=cl)
plot(lst2010, col=cl)
plot(lst2015, col=cl)

# Come importare tutto il set di immagini contemporaneamente

lista <- list.files(pattern = "lst_20") # creao una lista di files
import <- lapply(lista, raster) # applico la funz. raster a tutti i files della lista

tgr <- stack(import)  # funzione per aggregare tutti i files in uno singolo (simil immagine satellitare)

plot(tgr, col=cl) # plottare tutti i files contemporaneamente
plot(tgr[[1]], col=cl) # plotto solo il 1o elemento di "tgr"

plotRGB(tgr, r=1, g=2, b=3, strech="lin") # ERRORE

# colorist package utile per rappresentazioni grafiche

# lezione 1/4
