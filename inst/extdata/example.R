plot_id = "PRF002"
plot_id = "PRF025"
plot_id = "PRF036"
plot_id = "PRF133"
plot_id = "PRF184"
plot_id = "PRF185"
plot_id = "PRF193"
plot_id = "PRF200"

library(TreeMatching)

prf_treemap = function(plot_id)
{
  finventory = "/home/jr/Téléchargements/ALS_TLS_GJ/Bastien/Matching_MLS_FI/FI/FieldData_2025_Aligned_UTM.csv"
  all_inventory <- read.csv(finventory)
  inventory = all_inventory[all_inventory$Plot == plot_id,]
  inventory = inventory[!duplicated(inventory),]

  fmeasure = file.path("/home/jr/Téléchargements/ALS_TLS_GJ/Bastien/Matching_MLS_FI/MLS/", paste0(plot_id, "_DBH_HTs.csv"))
  measure <- read.csv(fmeasure)

  inventory = standardize(inventory, "Field_Xpj", "Field_Ypj", "DBH", dbhunits = "cm", crs = 2959)
  measure   = standardize(measure, "X", "Y", "DBH", dbhunits = "m", crs = 2959)
  center    = c(inventory$Easting[1], inventory$Northing[1])

  treemap = make_mapmatching(inventory, measure, center = center, radius = 11.5)
  treemap
}

treemap = prf_treemap(plot_id)

plot(treemap, scale = 2)

treemap = match_trees(treemap, lsap_matching, dxymax = 2, dzmax = 0.04, zrel = 40)
plot(treemap, scale = 2)
plot(treemap, rgl = TRUE)

treemap = match_trees(treemap, bidirectionnal_double_matching, dmax = 2, dz = 0.3)
plot(treemap, scale = 2)
plot(treemap, scale = 2, rgl = TRUE)
plot(treemap, gg = TRUE)


guess_unmatch_cost(treemap, 2, 0.3, 50, plot = TRUE)

ans = lapply(c("PRF025", "PRF036",  "PRF133", "PRF200"), function(x)
{
  treemap = prf_treemap(x)
  treemap = match_trees(treemap, lsap_matching, dxymax = 2, dzmax = 0.04, zrel = 40)
  plot(treemap, scale = 2, gg = TRUE)
})

gridExtra::grid.arrange(grobs = ans, ncol = 2)
