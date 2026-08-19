library(tidyverse)
moorea_coral <- read_csv( # _csv vs .csv (which is from the tidyverse)
  "data/moorea_coral.csv",
  na = c("", "NA", "ND") # This vector tells read_csv() which values to interpret as missing data
)

moorea_fish <- read_csv(
  "data/moorea_fish.csv",
  na = c("", "NA", "ND")
)

glimpse(moorea_fish)
glimpse(moorea_coral)

## Wrangle data filter out non-coral

non_coral <- c("Sand", "CTB", "Macroalgae", "Non-coralline Crustose Algae","Unknown or Other")


#Filter moorea_coral to exclude any row whose Taxonomy_Substrate_or_Functional_Group is in non_coral
#and to keep only rows where Depth is less than 17.

corals_only <- moorea_coral |> 
  filter(
    !Taxonomy_Substrate_or_Functional_Group %in% non_coral,
  Depth < 17
) |>
  mutate(Year = as.numeric(str_sub(Date, start = 1, end = 4))) # format date from year-month  to 4 digit year ex. 2005
 
# Summarize at quadrat level first, then at the whole transect level
coral_summary <- corals_only |> 
  summarize(
    quadrant_cover = sum(Percent_Cover, na.rm = TRUE), # quadrat-level percent cover
    .by = c(Year, Site, Habitat, Depth, Quad40)
  ) |> 
  summarize( # transect-level percent cover
    mean_coral_cover = mean(quadrant_cover),
    .by =  c(Year, Site, Habitat, Depth)
  ) |> 
  arrange(Year, Site, Depth)


primary_consumers <- moorea_fish |> 
  filter(Coarse_Trophic == "Primary Consumer")
nrow(moorea_fish)
nrow(primary_consumers)
  
fish_summary <- primary_consumers |> 
  summarize(
    total_biomass = sum(Biomass, na.rm = TRUE),
    .by = c(Site, Habitat, Year)
  ) |>
  arrange(Year, Site, Habitat)

# Join the Summaries
# Use inner_join, combining the two data frames by site, habitat, and the year

reef_joined <- coral_summary |> 
  inner_join(fish_summary, by = join_by(Site, Habitat, Year))

# Reshape
reef_joined_wide <-reef_joined |> 
  select(Site, Habitat, Year, mean_coral_cover) |> 
  # pivot wider to spread out the habitats
  pivot_wider(names_from = Habitat, values_from = mean_coral_cover) |> 
# add a column witht eh difference between the habitats
mutate(coral_cover_difference = Forereef - Fringing)

ggplot(
  data = reef_joined_wide,
    mapping = aes(x = coral_cover_difference)
) +
  geom_histogram()

ggplot(
  data = reef_joined_wide,
    mapping = aes(
      x = coral_cover_difference,
      y = 
    )
) +
 boxplot()