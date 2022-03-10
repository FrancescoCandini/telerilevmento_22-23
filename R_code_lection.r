# Questo è il primo script che useremo a lezione

# install.packages("raster")

library(raster)

setwd("C:/lab/") # set working directory; codice per caricare i dati nella cartella "lab"
#gli / in Windows vengono copiati al contrario

landsat2011 <- brick("p224r63_2011.grd") # così carichiamo velocemente il file di interesse
# setwd ci consente di non specificare tutto il path del file (simil progetto di R)
landsat2011 <- brick("C:/lab/p224r63_2011.grd") # altrimenti lo specifichiamo

landsat2011 # vediamo le informazioni del file, abbiamo circa 3*10^7 dati (pixels)

plot(landsat2011) # plot generale X-Y, specificando gli assi (lo stesso file per noi)

cl <- colorRampPalette(c("black", "grey", "light grey")) (100) 
# modifichiamo la legenda base con passaggio graduale tra 100 colori
# link per tutti i colori di R: https://www.r-graph-gallery.com/42-colors-names.html

plot(landsat2011, col = cl)
