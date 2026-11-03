
# 00 Setup
# Loads packages, sets colours and plot style, reads the data and gives the
# codes readable labels. Every other script starts by sourcing this file,
# so each script can also be run on its own.
#
# Run all scripts from the project root folder (open the .Rproj file in
# RStudio, or setwd() to the folder that contains run_all.R).


# Packages:

library(dplyr)   # Data summaries
library(tidyr)   # Reshaping the visit measurements
library(ggplot2) # Plots

dir.create("outputs/figures", recursive = TRUE, showWarnings = FALSE)
dir.create("outputs/tables", recursive = TRUE, showWarnings = FALSE)


# Colours and plot style:

# Orange for intervention and teal for control throughout.
cols <- c(Intervention = "#D55E00", Control = "#008C8C")

theme_set(theme_minimal(base_size = 15) +
            theme(panel.grid.minor = element_blank(),
                  legend.position = "top"))

# Save each plot to the figures folder.
save_plot <- function(p, file, w = 9, h = 5) {
  ggsave(file.path("outputs/figures", file), p,
         width = w, height = h, dpi = 300, bg = "white")
}

# Save each table to the tables folder.
save_table <- function(x, file) {
  write.csv(x, file.path("outputs/tables", file), row.names = FALSE)
}


# Get the data:

# The public TERECO data are on Dryad (CC0 licence):
# https://doi.org/10.5061/dryad.59zw3r27n
# A copy is included in data/. If it is missing, try to download it.
data_file <- "data/TERECO_Public_Data_wide.csv"
data_page <- "https://datadryad.org/dataset/doi:10.5061/dryad.59zw3r27n"
data_url  <- "https://datadryad.org/downloads/file_stream/805717"

if (!file.exists(data_file)) {
  dir.create("data", showWarnings = FALSE)
  ok <- tryCatch({
    download.file(data_url, data_file, mode = "wb", quiet = TRUE)
    TRUE
  }, error = function(e) FALSE, warning = function(w) FALSE)

  # Dryad sometimes blocks downloads from scripts. If so, download the
  # file in a web browser instead.
  if (!ok || !grepl("num_ID", readLines(data_file, n = 1, warn = FALSE))) {
    unlink(data_file)
    stop("Could not download the data automatically.\n",
         "1. Open ", data_page, "\n",
         "2. Download 'TERECO_Public_Data_wide.csv'\n",
         "3. Save it in the data/ folder of this project, then run again.",
         call. = FALSE)
  }
}


# Load the data:

# Each row is one participant, with separate columns for baseline,
# six weeks and 28 weeks.
dat <- read.csv(data_file, check.names = FALSE)

# Shorter walking-distance names are easier to use in the models.
# mwd1 = baseline, mwd2 = six weeks, mwd3 = 28 weeks.
names(dat) <- sub("^_6MWD", "mwd", names(dat))


# Readable labels:

# Control is the reference group, so the model coefficient gives the
# intervention-minus-control difference.
dat <- dat %>%
  mutate(
    group = factor(group_randomized, levels = c(2, 1),
                   labels = c("Control", "Intervention")),
    sex = factor(male, levels = c(0, 1),
                 labels = c("Female", "Male"))
  )
