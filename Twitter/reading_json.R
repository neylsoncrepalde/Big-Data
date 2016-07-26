#Reading in JSON file with tweets
#Neylson Crepalde

library(jsonlite)

#this should put data into a data.frame
dat <- fromJSON(sprintf("[%s]", paste(readLines("~/Documentos/Neylson Crepalde/Doutorado/GIARS/Big Data SNA/tweets_teste.txt"), collapse=",")))
