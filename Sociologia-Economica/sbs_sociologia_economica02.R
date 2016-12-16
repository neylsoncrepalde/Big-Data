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

# Medidas descritivas
keys = soc.econ$keyword %>% tolower
keys = keys %>% gsub('(à|á|ã)','a',.) %>% gsub('(é|ê|è)','e',.) %>% gsub('í','i',.) %>%
  gsub('(ó|ö|ò|ô|õ)','o',.) %>% gsub('(ú|ù|ü)','u',.)

library(wordcloud)
pal = brewer.pal(8,"Dark2")
wordcloud(keys, min.freq = 2, random.order = F, colors = pal)

tabela.key = table(keys) %>% as.data.frame(., stringsAsFactors=F)
tabela.key = arrange(tabela.key, desc(Freq))

library(ggplot2)
ggplot(tabela.key[1:10,], aes(reorder(keys, Freq), Freq) )+geom_bar(stat = "identity")+
  coord_flip()+labs(y="",x="")+theme_bw()
