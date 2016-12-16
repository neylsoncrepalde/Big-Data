# SBS
# Juntando tudo

setwd("~/Documentos/Neylson Crepalde/Doutorado/GIARS/SBS_sociologia_economica")

library(readr)
library(magrittr)
library(dplyr)
library(descr)
library(igraph)

title =   read_csv('title.csv')
keys =    read_csv('keys.csv')
autores = read_csv('autores.csv')
refs =    read_csv('refs.csv')

head(title)
names(keys)
names(autores)
names(refs)

data1 = full_join(title, autores)
View(data1)
# Rede de coautorias
m1 = data1[,c(1,4)] %>% as.matrix
rede2mode.autores = graph_from_edgelist(m1, directed = F)
bip = bipartite_mapping(rede2mode.autores)
V(rede2mode.autores)$type = bip$type
coautorias = bipartite_projection(rede2mode.autores, which = 'true')
plot(coautorias, vertex.size=6, vertex.label=NA)


#################################
data2 = full_join(data1, keys)
View(data2)
# Rede de palavras-chave
m2 = data2[,c(1,5)] %>% as.matrix
rede2mode.keys = graph_from_edgelist(m2, directed = F)
bip = bipartite_mapping(rede2mode.keys)
V(rede2mode.keys)$type = bip$type
palavras.chave = bipartite_projection(rede2mode.keys, which='true')
V(palavras.chave)$shape = "none"
plot(palavras.chave, vertex.label.cex=degree(palavras.chave)/7,
     edge.width=(E(palavras.chave)$weight)/10)

################################
data3 = full_join(data1, refs)
View(data3)
# Rede de citações
data3 = mutate(data3,
       refsemponto = tm::removePunctuation(ref))

m3 = data3[,c(4,6)] %>% as.matrix
citacoes = graph_from_edgelist(m3, directed=T)
indeg = degree(citacoes, mode = "in")
plot(citacoes, vertex.size=indeg/4,
     vertex.label.cex=(indeg+1)/50, 
     edge.arrow.size=.3, 
     vertex.label.color=adjustcolor('blue', .8))