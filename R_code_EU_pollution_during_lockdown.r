# Osservazione degli effetti del lockdown sull'inquinamento (ossidi di N)

library(raster)

setwd("C:/lab/en")

cl <- colorRampPalette(c('red','orange','yellow'))(100) #

en01 <- raster("EN_0001.png")
plot(en01, col=cl)

en13 <- raster("EN_0013.png")
plot(en13, col=cl)

rlist <- list.files(pattern="EN") # lista di tutti i files con il pattern comune
rimp <- lapply(rlist, raster) # applico la funzione raster a tutti i files della lista (importo tutto)
en <- stack(rimp) # variabile contenente tutti i files, così da usarli contemporaneamente

plot(en, col=cl) # plot di tutti i files

# Confronto tra il primo file e l'ultimo
par(mfrow=c(1,2))
plot(en[[1]], col=cl)
plot(en[[13]], col=cl)
# Alternativa
en113 <- stack(en[[1]], en[[13]])
plot(en113, col=cl)


# Differenza tra le immagini estreme

difen <- en[[1]] - en[[13]]
cldif <- colorRampPalette(c('blue','white','red'))(100) #
plot(difen, col=cldif)

# plotRGB di 3 files
plotRGB(en, r=1, g=7, b=13, stretch="lin")

plotRGB(en, r=1, g=7, b=13, stretch="hist")
