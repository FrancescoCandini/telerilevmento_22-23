# Questo è il primo script che useremo a lezione

# install.packages("raster")

library(raster)

setwd("C:/lab/") # set working directory; codice per caricare i dati nella cartella "lab"
#gli / in Windows vengono copiati al contrario

landsat2011 <- brick("p224r63_2011.grd") # così carichiamo velocemente il file di interesse
# setwd ci consente di non specificare tutto il path del file (simil progetto di R)
landsat2011 <- brick("C:/lab/p224r63_2011.grd") # altrimenti lo specifichiamo
landsat1988 <- brick("p224r63_1988.grd") # carico l'immagine del 1988 nella stessa cartella precedentemente evidenztiata

landsat2011 # vediamo le informazioni del file, abbiamo circa 3*10^7 dati (pixels)
# Banda 1 = blu
# Banda 2 = verde
# Banda 3 = rosso
# Banda 4 = infrarosso vicino (near infrared)
# Banda 5 = 
# Banda 6 = 
# Banda 7 = 


plot(landsat2011) # plot generale X-Y, specificando gli assi (lo stesso file per noi)

cl <- colorRampPalette(c("black", "grey", "light grey")) (100) 
# modifichiamo la legenda base con passaggio graduale tra 100 colori
# link per tutti i colori di R: https://www.r-graph-gallery.com/42-colors-names.html

cl_b <- colorRampPalette(c("dark blue", "blue", "light blue")) (100) #nuova palette blu
cl_v <- colorRampPalette(c("dark green", "green", "light green")) (100) #nuova palette verde
cl_r <- colorRampPalette(c("dark red", "red", "pink")) (100) #nuova palette rossa
cl_ni <- colorRampPalette(c(" red", "orange", "yellow")) (100) #nuova palette near infrared

plot(landsat2011, col = cl)

# Plottiamo singole bande 
plot(landsat2011$B1_sre) # indicando il suo nome
plot(landsat2011[[1]]) # indicando il numero dell'elemento
plot(landsat2011$B1_sre, col = cl) # comando preferito con palette precedentemente creata

# Esportare grafici in pdf
pdf("banda_blu.pdf") # nome del file inserito della directory indicata con setwd
plot(landsat2011$B1_sre, col = cl_b) # indico il file da salvare
dev.off() # chiudo il grafico che creo

# Struttura identica cambiando il formato in png
png("banda_blu.png") # nome del file inserito della directory indicata con setwd
plot(landsat2011$B1_sre, col = cl_b) # indico il file da salvare
dev.off()

# Scansione multiframe
par(mfrow=c(2,1)) # mfrow multiframe row, indichiamo le righe (prima) e le colonne del multiframe
# Alternativa con grafici a colonne: mfrow=c(1,2)
plot(landsat2011$B1_sre, col = cl) 
plot(landsat2011$B1_sre, col = cl_b) 
dev.off()

# Multiframe a 4 grafici
par(mfrow=c(2,2))
plot(landsat2011$B1_sre, col = cl_b) 
plot(landsat2011$B2_sre, col = cl_v) 
plot(landsat2011$B3_sre, col = cl_r) 
plot(landsat2011$B4_sre, col = cl_ni) 
dev.off()

# Esportare multiframe
pdf("multiframe_4_bande.pdf")
par(mfrow=c(2,2))
plot(landsat2011$B1_sre, col = cl_b) 
plot(landsat2011$B2_sre, col = cl_v) 
plot(landsat2011$B3_sre, col = cl_r) 
plot(landsat2011$B4_sre, col = cl_ni) 
dev.off()

# Colori formati con lo schema RGB (red - green - blue) che limitano la sovrapposizione di 3 bande
plotRGB(landsat2011, r="B3_sre", g="B2_sre", b="B1_sre", stretch="lin") # plot RGB 
plotRGB(landsat2011, r=3, g=2, b=1, stretch="lin") # alternativa senza nomi, ma con la posizione degli elementi

plotRGB(landsat2011, r=4, g=3, b=2, stretch="lin") # cancello la banda blu e metto quella dell'infrarosso vicino
# L'infrarosso vicino (NIR) mostra la presenza di vegetazione
plotRGB(landsat2011, r=3, g=4, b=2, stretch="lin") # metto la banda NIR con il colore verde
# Stretch lineare: costruisco una funzione lineare che relativizzano i valori ottenuti dal minimo al massimo
# Stretch histogram: utilizza una funzione iperbolica (?) per distinguere più facilmente colori simili nei valori medi 
plotRGB(landsat2011, r=3, g=4, b=2, stretch="hist")

# multiframe di immagini a colori reali con diverso stretch
par(mfrow=c(2, 1))
plotRGB(landsat2011, r=3, g=2, b=1, stretch="lin") # alternativa senza nomi, ma con la posizione degli elementi
plotRGB(landsat2011, r=3, g=2, b=1, stretch="hist") # alternativa senza nomi, ma con la posizione degli elementi

dev.off()

# Multiframe di confronto tra le immagini di età diverse
par(mfrow=c(2, 1))
plotRGB(landsat2011, r=3, g=2, b=1, stretch="lin") # alternativa senza nomi, ma con la posizione degli elementi
plotRGB(landsat1988, r=3, g=2, b=1, stretch="lin") # alternativa senza nomi, ma con la posizione degli elementi

dev.off()

par(mfrow=c(2, 1))
plotRGB(landsat2011, r=4, g=3, b=2, stretch="lin") # alternativa senza nomi, ma con la posizione degli elementi
plotRGB(landsat1988, r=4, g=3, b=2, stretch="lin") # alternativa senza nomi, ma con la posizione degli elementi



# Indici di vegetazione per misurare lo stato di salute delle piante e confronto nel tempo


