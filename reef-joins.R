library(tidyverse)

moorea_coral <- read_csv(
  "data/moorea_coral.csv",
  na = c("", "NA", "ND") # This vector tells read_csv() which values to interpret as missing data
)

moorea_fish <- read_csv(
  "data/moorea_fish.csv",
  na = c("", "NA", "ND")
)

glimpse(moorea_fish)
glimpse(moorea_coral)


non_coral <- c("CTB", "Macroalgae", "Non-coralline Crustose Algae","Unknown or Other")
#Filter moorea_coral to exclude any row whose Taxonomy_Substrate_or_Functional_Group is in non_coral, and to keep only rows where Depth is less than 17.