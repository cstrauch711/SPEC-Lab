##################################################
# World Inequality Database
# Source: https://wid.world/data/
# Created by: Clayton Strauch
# Created: 18 June 2020
# Suffix: WID
##################################################

#Load libraries and set working directory 
library(tidyr)
library(dplyr)

### PREP DATA #################################
#Import data as csv files (4 total). Note that seperator is semicolon, not comma
#First line is a header, but it is not the variable names (not included) --> header = F and skip one line, treat blank spaces and unnamed values as missing
income_top10 <- read.csv("data/WID_income_data_top10_CS_06222020.csv", sep=';', header=F, skip=1, na.strings = c('','Unnamed: 4'))
income_mid40 <- read.csv("data/WID_income_data_mid40_CS_06222020.csv", sep=';', header=F, skip=1, na.strings = c('','Unnamed: 4'))
income_bot50 <- read.csv("data/WID_income_data_bot50_CS_06222020.csv", sep=';', header=F, skip=1, na.strings = c('','Unnamed: 4'))
income_top01 <- read.csv("data/WID_income_data_top01_CS_06222020.csv", sep=';', header=F, skip=1, na.strings = c('','Unnamed: 4'))

#Assign proper variable names to dummy names
names(income_top10) <- c('country','concept','percentile','year','value')
names(income_mid40) <- c('country','concept','percentile','year','value')
names(income_bot50) <- c('country','concept','percentile','year','value')
names(income_top01) <- c('country','concept','percentile','year','value')

#Change unique concept name to general concept name
#Example: 'sptinc_p90p100_z_AE Pre-tax national income  Top 10% | share' --> 'pretax_nat_income_top10'
#The final two characters are the country id, so it is specific to the country and will not pivot as needed
income_top10 <- mutate(income_top10, concept = 'pretax_nat_income_top10')
income_mid40 <- mutate(income_mid40, concept = 'pretax_nat_income_mid40')
income_bot50 <- mutate(income_bot50, concept = 'pretax_nat_income_bot50')
income_top01 <- mutate(income_top01, concept = 'pretax_nat_income_top01')

#bind all the dataframes by row, then pivot to create country-year observations
#note that when pivoting by c(country,year), the percentile column is lost. This is not an issue because the percentile is unique to the concept variable and does not add add. info
wid_merged <- bind_rows(income_top10, income_bot50, income_mid40, income_top01) %>%
  filter(country != 'null') %>% #remove null entries
  mutate(country = as.character(country), percentile = as.character(percentile)) %>% #change country and percentile data type from factor to character
  pivot_wider(id_cols = c(country, year), names_from = concept, values_from = value)


#check for duplicates of country-year observations
n_occur <- data.frame(table(wid_merged$country, wid_merged$year))
print(n_occur[n_occur$Freq > 1,])
# no duplicates were found

#Save prep script as an rds file if desired
saveRDS(wid_merged, file="PREPPED_WID.rds")

