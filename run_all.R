
# Run the whole analysis from start to finish.
# Open tereco-telerehab-reanalysis.Rproj in RStudio (or setwd() to this
# folder), then run:  source("run_all.R")
# All tables and figures are written to the outputs/ folder.

source("R/01_check_data.R")
source("R/02_dataset_overview.R")
source("R/03_explore_walking.R")
source("R/04_compare_groups.R")

# Record the R version and packages used.
sessionInfo()
