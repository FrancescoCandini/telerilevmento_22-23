# Images of ..., the 1st was captured on ... and the 2nd on ...

# Landsat band 5 = NIR
# 

# install.packages("patchwork") and all the other packages

library(raster) # 
library(RStoolbox) # 
library(ggplot2) # 
library(patchwork) # 
library(viridis)

setwd

# Sentinel 2
s2 <- raster
s2

# Landsat
l8 <- raster
l8

# Landsat 8 images
# LC08_L2SP_008047_20220702_20220707_02_T1
# LC08_L2SP_008047_20220616_20220629_02_T1
# LC09_L2SP_008047_20220608_20220610_02_T1
# LC08_L2SP_008047_20220531_20220609_02_T1
# LC09_L2SP_008047_20220523_20220525_02_T1
# LC09_L2SP_008047_20220507_20220509_02_T1
# ...
# LC08_L2SP_008047_20181011_20200830_02_T1
# LC08_L2SP_008047_20180909_20200830_02_T1
