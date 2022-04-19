# install.packages("...") azione precedente necessaria per ogni pacchetto

library(raster)
library(rgdal)
library(RStoolbox)
library(rasterdiv)

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

# Different Vegetation Index (DVI), indica la quantità di vegetazione in un'area (quindin anche la biomassa)
# DVI = NIR - red ; quindi il DVI (ad 8 bit) va da -255 a 255
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

dev.off()

# DVI standardizzato = NDVI (8 bit) che va da -1 ad 1 (serve a fare confronti tra risoluzioni diverse)
# A 16 bit ci sono 65536 valori, quindi il DVI va da -65535 a 65535, ma il NDVI varia sempre tra -1 ed 1
# NDVI = DVI / (somma delle componenti del DVI)
# Esempio
dvi2006 = landsat2006[[1]] - landsat2006[[2]]
ndvi2006 = (landsat2006[[1]] - landsat2006[[2]]) / (landsat2006[[1]] + landsat2006[[2]])
ndvi1992 = (landsat1992[[1]] - landsat1992[[2]]) / (landsat1992[[1]] + landsat1992[[2]])
ndvi2006
ndvi1992

# Multiframe con plotRGB sopra all'immagine DVI
par(mfrow=c(2, 1))
plotRGB(landsat1992, r=1, g=2, b=3,stretch="lin")
plot(ndvi1992, col=cl)
# Il fiume (nel periodo della foto) ha molti solidi disciolti, quindi assue un colore simile al terreno deforestato
dev.off()

# Multiframe con NDVI1992ve NDVI2006
par(mfrow=c(2, 1))
plot(ndvi1992, col=cl)
plot(ndvi2006, col=cl)

dev.off()

# Calcolo automatico degli spectral indices (necessario RLtoolbox)
si1992 <- spectralIndices(landsat1992, green=3, red=2, nir=1)
plot(si1992) # plot di tutti gli indici possibili calcolabili, sia per naturalisti che per geologi

# Idem per il 2006
si2006 <- spectralIndices(landsat2006, green=3, red=2, nir=1)
plot(si2006)

dev.off()

# Necessario il pacchetto rasterdiv
plot(copNDVI)

#lez31marzo
