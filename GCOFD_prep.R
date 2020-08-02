####################################################
# Data prep for Chinese Bilateral Aid/Loans
#
# Author: Clayton Strauch       # Created: 23 July 2020
# Last updated: 23 July 2020    # By: CS
#
# Data Source: https://www.aiddata.org/data/chinese-global-official-finance-dataset #Codebook and data zipped together
# Year Range: 2000-2014
#
# Suffix: GCOFD ('Global Chinese Official Financial Dataset' Paper Title)
# Notes: China is always country1 (repcountry), recipient is country2 (parcountry)
####################################################

# Load libraries and append_ID functions and set working directory
library(dplyr)
library(tidyr)
library(readxl)
setwd("C://Users/Clayton/Desktop/SPEC_local/")

# Import Data from EXCEL file with first row as variable names
# Select desired variables and rename donor and recipient to country1 and country2
gcofd <- read_excel( "data/GlobalChineseOfficialFinanceDataset_v1.0.xlsx", col_names = TRUE) %>%
  filter( umbrella == 0 ) %>% #Filter out umbrella projects
  select(country1 = donor, year, recipient_count, country2 = recipient_condensed,
         usd_defl_2014, is_cofinanced, loan_type, grant_element) %>%
  arrange(year, country2) %>% 
  mutate(grant_amount = usd_defl_2014 * grant_element * 0.01) %>% #Calc. amount in USD(2014) of loan that is grant based
  group_by(year, country2) %>%
  summarise( total_loan_grant = sum(usd_defl_2014, na.rm=T), #total loan (inclusive of grant loans) amount to a country in a year
          total_grant = sum(grant_amount, na.rm=T), #total grant amount to a country in a year
          n_projects = n(), #total number of proejects to a country in a year
          n_projects_cofinanced = sum(is_cofinanced == TRUE), #number of projects that were cofinanced to a country in a year
          n_projects_concessional = sum(loan_type == 'Concessional'), #number of loans that are concessional
          n_projects_nonconcessional = sum(loan_type == 'Non-Concessional' | loan_type == 'Non-concessional'), #number of loans that are not concessional
          n_projects_interestfree = sum(loan_type == 'Interest-Free') ) %>% #number of loans that are interest-free
  mutate( country1 = 'China' ) #bring back country1 variable of 'China' that was removed in summarize

#Save final dataframe as an RDS file if desired
saveRDS(gcofd, file="PREPPED_GCOFD.rds")







