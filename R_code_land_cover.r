# Cambiamenti nell'uso del suolo (o land cover)

# install.packages("patchwork")

library(raster) # per l'importazione di raster
library(RStoolbox) # per la classificazione
library(ggplot2) # per visualizzare meglio i dati
library(patchwork) # per facilitare la creazione di multiframe

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

p1 + p2 # immagini affiancate grazie a patchwork
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

# Calcolo delle proporzioni tra le classi
l92 # vedo il numero totale di pixels
tot92 <- 341292 # n. tot di pixels dell'immagine
prop_forest_92 <- 305357 /  tot92 # proporzione
perc_forest_92 <- 305357 * 100 / tot92 # percentuale
perc_forest_92

perc_agr_92 <- 100 - perc_forest_92 # calcolo la percentuale agricola tramite sottrazione (ho solo 2 classi)
perc_agr_92

l06
tot06 <- 342726
perc_forest_06 <- 178176 * 100 / tot06 # percentuale
perc_forest_06

perc_agr_06 <- 100 - perc_forest_06 
perc_agr_06

# Dati finali:
# perc_forest_92 = 89.47089 %
# perc_forest_06 = 51.98789 %
# perc_agr_92 = 10.52911 %
# perc_agr_06 = 48.01211 %

# La virgola si scrive col punto in inglese/amercicano

# Dataframe: tabella righe * colonne
# Creo le colonne (fields)
class <- c("Forest", "Agricolture")
percent_1992 <- c(89.47089, 10.52911)
percent_2006 <- c(51.98789, 48.01211)

multitemporal <- data.frame(class, percent_1992, percent_2006)
multitemporal
View(multitemporal) # comando per visualizzare la tabella in modo più chiaro

# 1992
ggplot(multitemporal, aes(x=class, y=percent_1992, color=class)) +
  geom_bar(stat="identity", fill="white")
# Creo un nuovo ggplot, imposto il dataframe come fonte dei dati, 
# poi seleziono le colonne che costituiranno il grafico
# Con il + indico la somma con un'altra funzione 

# 2006
ggplot(multitemporal, aes(x=class, y=percent_2006, color=class)) +
  geom_bar(stat="identity", fill="white")

# Ottenere un pdf, lo troveremo nella cartella indicata all'inizio del codice
pdf("percentages_2006.pdf")
ggplot(multitemporal, aes(x=class, y=percent_2006, color=class)) +
  geom_bar(stat="identity", fill="white")
dev.off()

# fine lezione 28/4
