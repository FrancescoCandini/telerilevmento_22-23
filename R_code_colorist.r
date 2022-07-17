# Colorist
# It's a package to explain graphically the spatial distribution of the species
# All the package is based on the use of the colors (colors HCL)
# It's possible to make maps clear also for the people that have some vision issue (inclusive maps)

###################### Packages ########################
# install.packages("colorist")

library(colorist)
library(ggplot2)

######################## Code ##########################
################### Field sparrow ######################

data("fiespa_occ")
fiespa_occ # Colorist works only on RasterStack

# Metrics
met1 <- metrics_pull(fiespa_occ) # preparing the raster to the visualization

# Palette
pal <- palette_timecycle(fiespa_occ)

# map
map_multiples(met1, pal, ncol = 3, labels = names(fiespa_occ))
# metrics, which palette, 3 columns and the names given by the raster 

map_single(met1, pal, layer = 7) # single month map

# Personalization of the palette, 12 colors starting from the value 60 (default 240)
p1 <- palette_timecycle(12, start_hue = 75) 

map_multiples(met1, p1, ncol = 4, labels = names(fiespa_occ))

# Map distill (fusion of all the maps)
met1_distill <- metrics_distill(fiespa_occ)

map_single(met1_distill, pal)

# Grey means high presence of the species all the year (not in a specific period) 
# Different colors indicates specific months/periods when the species is here

# Legend
legend_timecycle(pal, origin_label = "1 jan")
# There is the possibility to manipolate also the legend (see Virtuale or github)

################### Field sparrow ######################

data("fisher_ud")

m2 <- metrics_pull(fisher_ud)

# Different palette because it's a timeline, not a cycle
p2 <- palette_timeline(fisher_ud)

# Shows the esadecimal colors of the palette
head(p2)

map_multiples(m2, p2, ncol = 3, labels = names(fisher_ud))
# Lambda factor to personalize the opacity
map_multiples(m2, p2, ncol = 3, labels = names(fisher_ud), lambda_i = -12)

m2_distill <- metrics_distill(fisher_ud)
map_single(m2_distill, p2, lambda_i = -10)

legend_timeline(p2)
