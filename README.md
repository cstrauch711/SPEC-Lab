# SPEC-Lab
This repository is a collection of data cleaning and prepping projects with R during my time working at the SPEC Lab at USC. The data concern international politics and economics from a variety of sources. I had a fantastic time working with the Social and Political Economy Lab (SPEC) as a research fellow in the summer of 2020. For further information about the lab, please visit their website: https://www.uscspec.org/

These projects were created during the summer of 2020 and involve political and economic data at the global scale to be later merged with a master database. Each project consists of one R script cleaning and prepping a dataset in the form of a CSV or EXCEL file(s). Each imported dataset must be cleaned and prepped individually as they are all formatted differently. They fall into one of two categories at the end:
  Unilateral: Data is in country-year format where each observation is data for a country in a given year. 
  Bilateral: Data is in a directed dyadic country-country-year format where each observation is data of a country directed to another country in a given year.
The individual data preps are then merged together to form the larger IPE (International Political Economy) database that is continually updated on the Harvard Dataverse: https://dataverse.harvard.edu/dataset.xhtml?persistentId=doi:10.7910/DVN/X093TV

This repository is organized by placing all R scripts and metadata in the main branch and the raw data files within the folder “data”.

Unilateral preps and acronyms:
  BRRD: Bjørnskov-Rode Regime Data. 
  IWD: Interstate War Data
  WID: World Inequality Database
Bilateral preps and acronyms:
  GCOFD: Global Chinese Office of Financial Development
  WBMR: World Bank Migration Remittance
