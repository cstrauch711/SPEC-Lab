#####################################################
# Bjørnskov-Rode Regime Data Prep
# This is an update and expansion of Cheibub, Gandhi and Vreeland's DD dataset by Christian Bjørnskov and Martin Rode for the SPEC Lab Database
# Data Source: http://www.christianbjoernskov.com/bjoernskovrodedata/
# Created by: Clayton Strauch
# Created: 12 June 2020
# Last Edited by: CS
# Last Edited: 16 June 2020
# Notes: 'brrd' is the abbreviation of 'Bjørnskov-Rode Regime Data'
#####################################################

# Load Libraries & set working directory
library(dplyr)
library(readxl)

# Import data: One EXCEL file and select the first two sheets by name as individual data frames
# Note that the filepath variables must be loaded into env. at this point
# Note that the creators of this dataset left spaces between variables, so when imported, new blank columns appear with format "..##" with all values missing
# Note that the creators of this dataset reused variable names often (i.e. year), so R renamed them with suffixes with format "...#"
brrd_regime <- as.data.frame(read_excel("data/Bjornskov-Rode-integrated-dataset-v2.2_CS_06152020.xlsx", sheet = "Regime characteristics", col_names = TRUE))
brrd_coup <- as.data.frame(read_excel("data/Bjornskov-Rode-integrated-dataset-v2.2_CS_06152020.xlsx", sheet = "Coups", col_names = TRUE))

# PREP FOR REGIME DATA ##########################################

#select desired categories while also renaming them
brrd_regime <- brrd_regime %>%
  select(country, year, dd_regime = 'DD regime',
         dd_category = 'DD category', monarchy_binary = Monarchy, commonwealth_binary = Commonwealth,
         female_monarch_binary = 'Female monarch (0: No; 1: Yes)', democracy_binary = Democracy,
         presidential_binary = Presidential, communist_binary = Communist, colony_binary = Colony,
         election_system = 'Election system')


# PREP FOR COUP DATA ############################################
#select desired categories while also renaming them
brrd_coup <- brrd_coup %>%
  filter(!is.na(country)) %>% #this removes summations found at the bottom of data that are not observations
  select(country, year = 'year...3', n_failed_coups = "Failed coups",
         n_success_coups = "Successful coups", n_all_coups = "All coups", 
         first_coup_occured = 'First coup', first_coup_year = "year...11",
         first_coup_month = "month...12", first_coup_type = "Type...13",
         second_coup_occured = "Second coup", third_coup_occured = "Third coup")


####### MERGE REGIME & COUP DATA #####################

brrd_merged <- full_join(brrd_regime, brrd_coup, by = c('country', 'year'))

#check for duplicates of country years
n_occur <- data.frame(table(brrd_merged$country, brrd_regime$year))
print(n_occur[n_occur$Freq > 1,])
# no duplicates were found

#Save prepped dataset as dataframe file if desired
saveRDS(brrd_merged, file="PREPPED_BRRD_CS_06152020.rds")





