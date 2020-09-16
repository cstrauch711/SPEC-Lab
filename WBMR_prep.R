########################################
# This is the data prep for bilateral migration remittance
# Data Source: World Bank
# Data source URL: https://www.worldbank.org/en/topic/migrationremittancesdiasporaissues/brief/migration-remittances-data
# Created by Clayton Strauch on 09 July 2020
# Data timeframe: 2010-2017
# Suffix: WBMR (World Bank Migration Remittance)
# Note that country that sends money is country1. Country that recieves money is country2
#######################################

#Load libraries and set working directory
library(dplyr)
library(tidyr)
library(readxl)
getwd()

#This function preps each excel file into proper country-country format #Year is added later on
clean <- function(df) {
  names(df)[1] <- "country1" #using base R to rename because the first column does not have the same name in each file, but is always the first variable
  df <- data.frame(df, check.names = FALSE) %>%
    filter(!is.na(country1) & !grepl('notes|total|remittance', country1, ignore.case = TRUE)) %>% #remove observations that are metadata from file
    pivot_longer(cols = !(country1), names_to = "country2", values_to = "migrant_remittance") %>%
    mutate(country1 = as.character(country1), country2 = as.character(country2), migrant_remittance = as.numeric(migrant_remittance))
  return(df)
}

#Import each excel file. Note that the first row is metadata, so it is skipped. 
#The second row is variable names, so col_names is true and col_type is specified as chr because it guesses incorrectly --> numeric are made numeric later
wbmr2010 <- read_excel("data/WBMR/BilateralRemittanceMatrix2010.xlsx", skip = 1, col_names = TRUE, col_types = "text")
wbmr2011 <- read_excel("data/WBMR/BilateralRemittanceMatrix2011.xlsx", skip = 1, col_names = TRUE, col_types = "text")
wbmr2012 <- read_excel("data/WBMR/BilateralRemittanceMatrix2012.xlsx", skip = 1, col_names = TRUE, col_types = "text")
wbmr2013 <- read_excel("data/WBMR/BilateralRemittanceMatrix2013.xlsx", skip = 1, col_names = TRUE, col_types = "text")
wbmr2014 <- read_excel("data/WBMR/BilateralRemittanceMatrix2014.xlsx", skip = 1, col_names = TRUE, col_types = "text")
wbmr2015 <- read_excel("data/WBMR/BilateralRemittanceMatrix2015.xlsx", skip = 1, col_names = TRUE, col_types = "text")
wbmr2016 <- read_excel("data/WBMR/BilateralRemittanceMatrix2016.xlsx", skip = 1, col_names = TRUE, col_types = "text")
wbmr2017 <- read_excel("data/WBMR/BilateralRemittanceMatrix2017.xlsx", skip = 1, col_names = TRUE, col_types = "text")

#Create a list of all the unprepped data frames
wbmr <- list("2010" = wbmr2010, "2011" = wbmr2011, "2012" = wbmr2012, "2013" = wbmr2013,
            "2014" = wbmr2014, "2015" = wbmr2015, "2016" = wbmr2016, "2017" = wbmr2017)

#Apply the clean function to all the data frames in the list above and bind them together by rows creating the year column in the process.
wbmr <- lapply(wbmr, clean) %>%
 bind_rows(.id="year") %>%
  mutate( year = as.numeric(year))

#Save final dataframe as an RDS file if desired
saveRDS(wbmr, file="PREPPED_WBMR.rds")





