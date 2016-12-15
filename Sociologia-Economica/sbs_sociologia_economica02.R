# SBS
# vendo as keywords

library(readr)
keys.df = read_csv('~/Documentos/Neylson Crepalde/Doutorado/GIARS/SBS_sociologia_economica/keywords_df.csv')

library(descr)
library(magrittr)

keys = keys.df$keyword %>% unique

selecao = grep("(e|E)con(ô|o)m", keys.df$keyword)

soc.econ = keys.df[selecao,]
