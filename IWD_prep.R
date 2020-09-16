#######################################################
# Interstate War Data 1816-2019 (version 1.2) - Dan Reiter, Allan C. Stam, and Michael C. Horowitz
# Data Source: https://dataverse.harvard.edu/dataset.xhtml?persistentId=doi:10.7910/DVN/CZGAO2
# Codebook (Version 1): https://journals.sagepub.com/doi/suppl/10.1177/0022002714553107
# Update Information (1.1): https://journals.sagepub.com/doi/suppl/10.1177/2053168016683840
# Author: Clayton Strauch
# Created: 23 June 2020
#######################################################

#Load libraries and set working directory 
library(tidyr)
library(dplyr)
library(readxl)
getwd()

#Import data (EXCEL file)
#Note that -9 is how the authors listed a missing value hence the na parameter with empty string and -9
iwd <- read_excel('data/IWD v 1.2_rawdata_CS_06232020.xlsx', na = c('','-9'))

#### PREP DATASET #####################################
#Select desired variables #Removes version, dates (besides year), and adversaries/allies
iwd <- iwd %>%
  select(COW_v4_id:year, countryname1 = init_name, init_ccode, countryname2 = target_name, target_ccode, joiner)

#Save final dataframe as RDS file if desired
saveRDS(iwd, file="PREPPED_IWD.rds")


