# SBS
# Juntando tudo

setwd("~/Documentos/Neylson Crepalde/Doutorado/GIARS/SBS_sociologia_economica")

library(readr)
library(magrittr)
library(dplyr)
library(descr)
library(igraph)
library(wordcloud)
library(ggplot2)

title =   read_csv('title.csv') %>% unique
keys =    read_csv('keys.csv') %>% unique
autores = read_csv('autores.csv')
refs =    read_csv('refs.csv')

head(title)
names(keys)
names(autores)
names(refs)

###############################################
# Medidas descritivas
# journal
tabela.journal = table(title$journal) %>% as.data.frame(., stringsAsFactors=F)
tabela.journal = arrange(tabela.journal, desc(Freq))
tabela.journal[1:11,]
ggplot(tabela.journal[1:11,], aes(reorder(Var1, Freq), Freq) )+geom_bar(stat = "identity")+
  coord_flip()+labs(y="",x="")+theme_bw()  #tamanho 500 X 350

# ANO
summary(title$year)
tabela.ano = table(title$year) %>% as.data.frame(., stringsAsFactors=F)
tabela.ano$Var1 %<>% as.Date(., "%Y")
ggplot(tabela.ano, aes(x=Var1, y=Freq))+geom_line()+labs(x='Anos',y='Artigos')+theme_bw() #500 X 350

#autores
tabela.autor = table(autores$author) %>% as.data.frame(., stringsAsFactors=F)
tabela.autor = arrange(tabela.autor, desc(Freq))
tabela.autor[1:21,]
ggplot(tabela.autor[1:21,], aes(x=reorder(Var1, Freq), y=Freq))+geom_bar(stat = "identity")+
  coord_flip()+labs(y="",x="")+theme_bw()  #tamanho 500 X 400


# Rede de coautorias
data1 = full_join(title, autores)
#View(data1)

m1 = data1[,c(1,4)] %>% as.matrix
rede2mode.autores = graph_from_edgelist(m1, directed = F)
bip = bipartite_mapping(rede2mode.autores)
V(rede2mode.autores)$type = bip$type
coautorias = bipartite_projection(rede2mode.autores, which = 'true')

graph.density(coautorias)
plot(coautorias, vertex.size=degree(coautorias), vertex.label=NA, layout=layout_in_circle)
title(xlab="Densidade = 0.002\nTamanho = Centralidade de Grau")

nomes = V(coautorias)$name %>% as.data.frame(., stringsAsFactors=F)
names(nomes) = "Var1"
publicou = left_join(nomes, tabela.autor)
head(nomes); head(publicou)
V(coautorias)$publicacoes = publicou$Freq
plot(coautorias, vertex.size=V(coautorias)$publicacoes, vertex.label=NA)
title(xlab="Densidade = 0.002\nTamanho = Publicações")

#################################
#Freq das palavras chave
# Medidas descritivas
keys.vec = keys$keyword %>% tolower
keys.vec = keys.vec %>% gsub('(à|á|ã)','a',.) %>% gsub('(é|ê|è)','e',.) %>% gsub('í','i',.) %>%
  gsub('(ó|ö|ò|ô|õ)','o',.) %>% gsub('(ú|ù|ü)','u',.)

pal = brewer.pal(8,"Dark2")
wordcloud(keys.vec, min.freq = 5, random.order = F, colors = pal)

tabela.key = table(keys.vec) %>% as.data.frame(., stringsAsFactors=F)
tabela.key = arrange(tabela.key, desc(Freq))

ggplot(tabela.key[1:10,], aes(reorder(keys.vec, Freq), Freq) )+geom_bar(stat = "identity")+
  coord_flip()+labs(y="",x="")+theme_bw() #tamanho 500 X 350

## Juntando os bancos para montar a rede
data2 = full_join(data1, keys)
#View(data2)

# Rede de palavras-chave
data2$keyword = data2$keyword %>% tolower
data2$keyword = data2$keyword %>% gsub('(à|á|ã)','a',.) %>% gsub('(é|ê|è)','e',.) %>% gsub('í','i',.) %>%
  gsub('(ó|ö|ò|ô|õ)','o',.) %>% gsub('(ú|ù|ü)','u',.)

m2 = data2[,c(1,5)] %>% as.matrix
rede2mode.keys = graph_from_edgelist(m2, directed = F)
bip = bipartite_mapping(rede2mode.keys)
V(rede2mode.keys)$type = bip$type
palavras.chave = bipartite_projection(rede2mode.keys, which='true')
V(palavras.chave)$shape = "none"
plot(palavras.chave, vertex.label.cex=degree(palavras.chave)/60,
     edge.width=(E(palavras.chave)$weight)/10, 
     vertex.label.color=adjustcolor('blue',.7),
     edge.color=adjustcolor('grey',.5),
     layout=layout_with_mds)
title(xlab="Layout = Escalonamento Multidimensional")

################################
# Medidas descritivas das citações
data3 = full_join(data1, refs)
#View(data3)

data3 = mutate(data3,
               refsemponto = tm::removePunctuation(ref))
#limpando alguns
#sel.bourdieu = grep("(B|b)(o|O)(u|U)(r|R)(d|D)(i|I)(e|E)(u|U) (p|P)",data3$refsemponto)
#data3$refsemponto[sel.bourdieu] = "BOURDIEU Pierre"
#sel.bourdieu2 = grep("(B|b)(o|O)(u|U)(r|R)(d|D)(i|I)(e|E)(u|U)",data3$refsemponto)
#jerome = grep("Jer", data3$refsemponto[sel.bourdieu2])
#data3$refsemponto[sel.bourdieu2][-jerome] = "BOURDIEU Pierre"

#sel.swedberg = grep("S(w|W)(e|E)(d|D)(b|B)(e|E)(r|R)(g|G)",data3$refsemponto)
#data3$refsemponto[sel.swedberg] = "SWEDBERG Richard"
#sel.granovetter = grep("G(r|R)(a|A)(n|N)(o|O)(v|V)(e|E)(t|T)(t|T)(e|E)(r|R)",data3$refsemponto)
#ellen = grep("Ellen", data3$refsemponto)
#sel.granovetter = sel.granovetter[-which(sel.granovetter %in% ellen == T)]
#data3$refsemponto[sel.granovetter] = "GRANOVETTER Mark"

#sel.sen = grep("S(e|E)(n|N) A",data3$refsemponto)
#data3$refsemponto[data3$refsemponto=="SEN A"] = "SEN Amartya"
#data3$refsemponto[data3$refsemponto=="SEN A K"] = "SEN Amartya"
#data3$refsemponto[data3$refsemponto=="Sen A"] = "SEN Amartya"
#data3$refsemponto[data3$refsemponto=="Sen Amartya"] = "SEN Amartya"

#sel.piola = grep("P(i|I)(o|O)(l|L)(a|A)",data3$refsemponto)
#data3$refsemponto[sel.piola] = "PIOLA Sérgio"

#sel.weber = grep("W(e|E)(b|B)(e|E)(r|R)",data3$refsemponto)
#florence = grep("W(e|E)(b|B)(e|E)(r|R) F",data3$refsemponto[sel.weber])
#data3$refsemponto[sel.weber][-florence][-19] = "WEBER Max"

#sel.marx = grep("M(a|A)(r|R)(x|X)", data3$refsemponto)
#data3$refsemponto[sel.marx][-c(18,25)] = "MARX Karl"

#sel.singer = grep("S(i|I)(n|N)(g|G)(e|E)(r|R)", data3$refsemponto)
#singer.outros = grep("S(i|I)(n|N)(g|G)(e|E)(r|R) (A|M|H)",data3$refsemponto[sel.singer])
#data3$refsemponto[sel.singer][-singer.outros][-1] = "SINGER Paul"

data3$refsemponto %<>% tolower

tabela.ref = table(data3$refsemponto) %>% as.data.frame(., stringsAsFactors=F)
tabela.ref = arrange(tabela.ref, desc(Freq))
tabela.ref[1:20,]



# Rede de citações
m3 = data3[,c(4,5)] %>% as.matrix

citacoes = graph_from_edgelist(m3, directed=T)
indeg = degree(citacoes, mode = "in")
ggplot(NULL, aes(indeg))+geom_histogram(col="white")+theme_bw()+labs(x='',y='')

plot(citacoes, vertex.size=indeg/15,
     vertex.label.cex=(indeg+1)/120, 
     edge.arrow.size=.1,
     edge.color=adjustcolor('grey',.5),
     vertex.color=adjustcolor('red',.4),
     vertex.label.color=adjustcolor('blue', .8))
