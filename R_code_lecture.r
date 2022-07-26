# install.packages("raster")

library(raster)

setwd("C:/lab/") # set working directory; to link the folder "lab" where i can take files and save others

landsat2011 <- brick("p224r63_2011.grd") # così carichiamo velocemente il file di interesse
# thx to setwd we can no specify the full path  
landsat2011 <- brick("C:/lab/p224r63_2011.grd") # or we can specify all
landsat1988 <- brick("p224r63_1988.grd") 

landsat2011 # see the file indo, we have 3*10^7 pixels (or data)
# Band 1 = blue
# Band 2 = green
# Band 3 = red
# Band 4 = near infrared

plot(landsat2011) # general plot X-Y

cl <- colorRampPalette(c("black", "grey", "light grey")) (100) 
# I change the color scale with a gradation of 100 colors
# link to all the colors in R: https://www.r-graph-gallery.com/42-colors-names.html

cl_b <- colorRampPalette(c("dark blue", "blue", "light blue")) (100) # new palette blue
cl_v <- colorRampPalette(c("dark green", "green", "light green")) (100) # new palette green
cl_r <- colorRampPalette(c("dark red", "red", "pink")) (100) # new palette red
cl_ni <- colorRampPalette(c(" red", "orange", "yellow")) (100) # new palette near infrared

plot(landsat2011, col = cl)

# Plotof the single bands
plot(landsat2011$B1_sre) # I write the name of the raster and link (with $) the sigle element
plot(landsat2011[[1]]) # or specifying the number
plot(landsat2011$B1_sre, col = cl)

# Export graphs .pdf
pdf("banda_blu.pdf") # file name inserted in the folder setted with sewd
plot(landsat2011$B1_sre, col = cl_b) # I specify the file to save
dev.off() # I close the graph

# Export graphs .png
png("banda_blu.png") # file name inserted in the folder setted with sewd
plot(landsat2011$B1_sre, col = cl_b) # I specify the file to save
dev.off() # I close the graph

# Multiframe scanning
par(mfrow=c(2,1)) # mfrow multiframe row, to set the multiframe's rows (first) and the columns 
# Or the opposite: mfcol=c(1,2)
plot(landsat2011$B1_sre, col = cl) 
plot(landsat2011$B1_sre, col = cl_b) 
dev.off()

# Multiframe with 4 graphs
par(mfrow=c(2,2))
plot(landsat2011$B1_sre, col = cl_b) 
plot(landsat2011$B2_sre, col = cl_v) 
plot(landsat2011$B3_sre, col = cl_r) 
plot(landsat2011$B4_sre, col = cl_ni) 
dev.off()

# Export the multiframe
pdf("multiframe_4_bande.pdf")
par(mfrow=c(2,2))
plot(landsat2011$B1_sre, col = cl_b) 
plot(landsat2011$B2_sre, col = cl_v) 
plot(landsat2011$B3_sre, col = cl_r) 
plot(landsat2011$B4_sre, col = cl_ni) 
dev.off()

# Colors RGB (red - green - blue) that limits the overlap at 3 bands
plotRGB(landsat2011, r="B3_sre", g="B2_sre", b="B1_sre", stretch="lin") # plot RGB 
plotRGB(landsat2011, r=3, g=2, b=1, stretch="lin") # alternative with no-name, but with the posistion of the elements

plotRGB(landsat2011, r=4, g=3, b=2, stretch="lin") # remove the blue to put the NIR
# NIR allows us to see the vegetation
plotRGB(landsat2011, r=3, g=4, b=2, stretch="lin") # NIR in green position
# Linear setretch: linear function from min to max obtained value
# histogram setretch: hyperbolic function to easily distinguish the values near the mean
plotRGB(landsat2011, r=3, g=4, b=2, stretch="hist")

# Multiframe with images with different stretch
par(mfrow=c(2, 1))
plotRGB(landsat2011, r=3, g=2, b=1, stretch="lin") # no-name, but posistion of the elements
plotRGB(landsat2011, r=3, g=2, b=1, stretch="hist") # no-name, but posistion of the elements

dev.off()

# Multiframe to compare images at different time
par(mfrow=c(2, 1))
plotRGB(landsat2011, r=3, g=2, b=1, stretch="lin")
plotRGB(landsat1988, r=3, g=2, b=1, stretch="lin") 

dev.off()

par(mfrow=c(2, 1))
plotRGB(landsat2011, r=4, g=3, b=2, stretch="lin")
plotRGB(landsat1988, r=4, g=3, b=2, stretch="lin")
