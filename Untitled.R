setwd("/Users/gaokangning/Desktop/Program/R projects")
con <- dbConnect(MySQL(),host="127.0.0.1",dbname="WBtest",user="root",password="root")
# install.packages("devtools")
# install.packages("data360r")
# install.packages("sqldf")
# install.packages("tidyverse")
# devtools::install_github("mrpsonglao/data360r")
library(RMySQL)
library(data360r)
library(ggplot2)
library(dplyr)
library(tidyverse)
# library(sqldf)
library(devtools)
#get data for dataset ID 51 in TCdata360
df <- get_data360(dataset_id = 51)
df_CHN <- filter(dataset,dataset[,2] == "China")
# (df_CHN,aes(x = df_CHN[3], y = df_CHN[2,5:21]))
lm(x = df_CHN[3], y = df_CHN[2,5:21])

geom_histogram(df_CHN,aes(x = df_CHN[3], y = df_CHN[2,5:21]))

#get data for countries USA, PHL in Govdata360
df2 <- get_data360(site = 'gov', country_iso3 = c('ABW'))
df_JPN <- get_data360(site = 'gov', country_iso3 = c('JPN', 'PHL'))


#get data for indicator IDs 944, 972 in TCdata360
df3 <- get_data360(indicator_id = c(944, 972))

#get data for indicator IDs 944, 972 in 2011-2013 in long format in TCdata360
df4 <- get_data360(indicator_id = c(944, 972),
                   timeframes = c(2011, 2012, 2013), output_type = 'long')


# search_360 --------------------------------------------------------------


#search a country's code in TCdata360
search_360('China', search_type = 'country')

#search for top 10 relevant indicator codes in TCdata360
search_360('GDP', search_type = 'indicator', limit_results = 10)

#search for top 10 indicators of a database in TCdata360
search_360('World Development Indicators', search_type = 'indicator', limit_results = 10)

#search for top 10 indicators of a data provider in TCdata360
search_360('WEF', search_type = 'indicator', limit_results = 10)

#search for top 10 relevant categories in Govdata360
search_360('Governance', site='gov', search_type = 'category', limit_results = 10)


# get_resources360 --------------------------------------------------------

#get all indicator metadata in Govdata360
df_indicators <- get_metadata360(site="gov", metadata_type = "indicators")

#get all country metadata in TCdata360
df_countries <- get_metadata360(metadata_type = 'countries')

#get all dataset metadata in TCdata360
df_datasets <- get_metadata360(metadata_type = 'datasets')


# case1 ------------------------------------------------------------


search_360("United States", search_type="country")
search_360("China", search_type="country")
#===join===
search1 <- search_360("woman business", search_type="indicator", limit_results = 5)
result1<- get_data360(indicator_id=search1$id, country_iso3="USA")



# case 2 ------------------------------------------------------------------

# search_360("men", search_type="indicator") %>% distinct(name,.keep_all=TRUE)
search_360("marriage", search_type="indicator")
result2 <- get_data360(indicator_id = c(204, 205), timeframes = c(2010:2016), output_type = 'long')
write.csv(result2, "Marriage_Age.csv",row.names = FALSE)
dbWriteTable(con,"Marriage_Age",format.data.frame(result2),overwrite = T,row.names = FALSE)

ggplot(result2, aes(x=Observation, cond=Indicator,fill=Indicator)) +
  geom_histogram(binwidth=.75, alpha=.25, position="identity")
# result2 %>% group_by("Observation","Indicator") 



# case 3 ------------------------------------------------------------------

result3 <- get_data360(indicator_id = c(204, 205), output_type = 'long') %>% 
  merge(select(get_metadata360(),iso3,region), by.x="Country ISO3", by.y="iso3") %>% 
  filter(!(region == "NAC"))
write.csv(result3, "Marriage_Age_Region.csv",row.names = FALSE)
dbWriteTable(con,"Marriage_Age_Region",format.data.frame(result),overwrite = T,row.names = FALSE)


ggplot(result3, aes(x=Observation, cond=Indicator, fill=Indicator)) +
  geom_density(alpha=.5) +
  facet_wrap(~region) +
  theme(legend.position="right") +
  scale_fill_manual(name="Gender",values=c("blue","red"), labels=c("boys","girls")) +
  ggtitle("Country-level Density of Legal Age for Marriage, by gender and region (WBL 2016)")



# case 4 Regression -------------------------------------------------------

search4 <- get_metadata360(metadata_type = "datasets")
result4<- get_data360(dataset_id=c(53), output_type = 'long') %>%
  filter(Period==c("2016-2017"))
# %>% filter("Subindicator Type" == "Value", !is.na(Observation))
result4_1 <- 
  filter(result4, result4$"Subindicator Type" == "Value", !is.na(Observation))
result4_2 <-
  as.data.frame(reshape2::acast(result4_1, result4_1$"Country ISO3" ~ result4_1$Indicator, value.var="Observation"))
write.csv(result4_2, "Regression.csv", row.names = FALSE)
dbWriteTable(con,"Regression",format.data.frame(result4_2),overwrite = T,row.names = FALSE)
chisq.test(result4_2$"1st pillar Institutions", result4_2$"Availability of latest technologies",simulate.p.value = FALSE)
qplot(result4_2$"1st pillar Institutions", result4_2$"Availability of latest technologies", data = result4_2)

