# Questo è il primo script che useremo a lezione

# install.packages("raster")

library(raster)

setwd("C:/lab/") # set working directory; codice per caricare i dati nella cartella "lab"
#gli / in Windows vengono copiati al contrario

landsat2011 <- brick("p224r63_2011.grd") # così carichiamo velocemente il file di interesse
# setwd ci consente di non specificare tutto il path del file (simil progetto di R)
landsat2011 <- brick("C:/lab/p224r63_2011.grd") # altrimenti lo specifichiamo

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

plot(landsat2011, col = cl)

# Plottiamo singole bande 
plot(landsat2011$B1_sre) # indicando il suo nome
plot(landsat2011[[1]]) # indicando il numero dell'elemento
plot(landsat2011$B1_sre, col = cl) # comando preferito con palette precedentemente creata

cl_b <- colorRampPalette(c("dark blue", "blue", "light blue")) (100) #nuova palette blu
cl_v <- colorRampPalette(c("dark green", "green", "light green")) (100) #nuova palette verde
cl_r <- colorRampPalette(c("dark red", "red", "pink")) (100) #nuova palette rossa
cl_ni <- colorRampPalette(c(" red", "orange", "yellow")) (100) #nuova palette near infrared

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
