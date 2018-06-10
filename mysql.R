# install.packages("RMySQL")
# library(RMySQL)
setwd("/Users/gaokangning/Desktop/Program/R projects")
con <- dbConnect(MySQL(),host="127.0.0.1",dbname="WBtest",user="root",password="root")
summary(con)
dbGetInfo(con)  
dbListTables(con)  

####way 1

dbWriteTable(con,"TCdata_51",format.data.frame(df),overwrite = T,row.names = FALSE)
dbWriteTable(con,"df_countries",format.data.frame(df_countries),overwrite = T,row.names = FALSE)
dbWriteTable(con,"df_datasets",format.data.frame(df_datasets),overwrite = T,row.names = FALSE)
dbWriteTable(con,"df_indicators",format.data.frame(df_indicators),overwrite = T,row.names = FALSE)


dbWriteTable(con,"df_ABW",format.data.frame(df2),overwrite = T,row.names = FALSE)
dbWriteTable(con,"df_datasets",format.data.frame(df_datasets),overwrite = T,row.names = FALSE)
dbWriteTable(con,"df_indicators",format.data.frame(df_indicators),overwrite = T,row.names = FALSE)








###way 2
# load data to csv --------------------------------------------------------
write.csv(df, "TCdata_51.csv", row.names=FALSE)
write.csv(df2, "GovByCountry_CHN.csv", row.names=FALSE)


# from csv to db ---------------------------------------------------------
dbSendQuery(con, "TRUNCATE TABLE TCdata_51")
dbSendQuery(con, "LOAD DATA LOCAL INFILE 'TCdata_51.csv' 
            INTO TABLE TCdata_51
            FIELDS TERMINATED by ','
            ENCLOSED BY '\"'
            LINES TERMINATED BY '\\n'")
