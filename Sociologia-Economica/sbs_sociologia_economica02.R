# SBS
# vendo as keywords

setwd('~/Documentos/Neylson Crepalde/Doutorado/GIARS/SBS_sociologia_economica')

library(readr)
keys.df = read_csv('keywords_df.csv')
View(keys.df)
library(descr)
library(magrittr)
library(dplyr)

#keys = keys.df$keyword %>% unique

selecao = grep("(e|E)con(ô|o)m", keys.df$keyword)

soc.econ = keys.df[selecao,]
#write.table(soc.econ, 'artigos_soc_econ.csv', sep=';', row.names = F)
soc.econ$keyword %>% unique %>% length
