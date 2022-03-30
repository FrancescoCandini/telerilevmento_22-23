
library(raster)
library(rgdal)

setwd("C:/lab/") 

# Importo i file
landsat1992 <- brick("defor1_.jpg")

# Informazione di Shannon: 1 bit che può essere 0 o 1 
# Aumentando i bit aumenta esponenzialmente la quantità di valori grazie alle composizioni di 0 ed 1
landsat1992 # valore massimo a 255 perché 8 bit danno 256 valori (ma partendo da 0 si arriva a 255)

plotRGB(landsat1992 ,r=1, g=2, b=3, stretch="lin")
# Vedendo il risultato (vegetazione rossa) capiamo che il NIR è la 1 (siamo sicuri)
# ed andando in elenco (solitamente succede così) avremo la 2 come rosso e la 3 come verde
# Layer 1 = NIR
# Layer 2 = red
# Layer 3 = green
# Fiume colorato come la terra senza vegetazione per la presenza di sedimento (probabilmente)

landsat2006 <- brick("defor2_.jpg")

landsat2006

plotRGB(landsat2006 ,r=1, g=2, b=3, stretch="lin")

# Multiframe di confronto
par(mfrow=c(2, 1))
plotRGB(landsat1992 ,r=1, g=2, b=3, stretch="lin")
plotRGB(landsat2006 ,r=1, g=2, b=3, stretch="lin")

dev.off()

# Different Vegetation Index (DVI)
# DVI = NIR - red 
cl <- colorRampPalette(c("darkblue", "yellow", "red", "black")) (100)

dvi1992 = landsat1992[[1]] - landsat1992[[2]]
dvi2006 = landsat2006[[1]] - landsat2006[[2]]

par(mfrow=c(2, 1))
plot(dvi1992, col=cl)
plot(dvi2006, col=cl)

dev.off()

# Alternativa al calcolo della DVI utilizzando nome_del_file$nome_dei_layer

dvi_dif = dvi2006 - dvi1992 # warning per dimensione lievemente diversa tra le immagini

plot(dvi_dif, col=colorRampPalette(c("blue", "white", "red")) (100))

