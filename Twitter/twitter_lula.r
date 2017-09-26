# Buscando tweets com LULA
# 16/03/2016, 22:57
# Neylson Crepalde
###########################

library(twitteR)
library(wordcloud)
library(tm)
library(plyr)

# Coloca as chaves
consumer_key <- "XXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
consumer_secret <- "XXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
access_token <- "XXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
access_secret <- "XXXXXXXXXXXXXXXXXXXXXXXXXXXXX"

# Estabelece a conexão
setup_twitter_oauth(consumer_key,
                    consumer_secret,
                    access_token,
                    access_secret)

# Faz a busca e coloca num objeto bd
tweets <- searchTwitter("#bolsonaro", n=200)
bd <- ldply(tweets, function(t) t$toDataFrame() )
View(bd)

# Extrai o texto dos tweets
text <- sapply(tweets, function(x) x$getText())

# Tira links
text <- gsub("(f|ht)tp(s?)://(.*)[.][a-z]+", "", text)
text <- gsub("https", "", text)
text <- gsub("http", "", text)
grep("http", text)

# Prepara o Corpus para análise
head(text)
texto = text
texto = iconv(text, from="UTF-8", to="latin1")
head(texto)
conteudo = texto %>% tolower %>% removePunctuation %>% 
  removeWords(., stopwords('pt'))

# Monta wordclouds
wordcloud(enc2native(conteudo), min.freq = 2, max.words = 100, random.order = F)

library(RColorBrewer)
pal2 <- brewer.pal(8,"Dark2")
wordcloud(enc2native(conteudo), min.freq=2,max.words=100, random.order=F, colors=pal2)
title(xlab = "Twitter, 26/09/2017, 15:00")

# Análise de clusterização
corpus <- Corpus(VectorSource(enc2native(conteudo)))
tdm <- TermDocumentMatrix(corpus)
tdm <- removeSparseTerms(tdm, sparse = 0.97)
df <- as.data.frame(as.matrix(tdm))
dim(df)
df.scale <- scale(df)
d <- dist(df.scale, method = "euclidean")
fit <- hclust(d)
plot(fit)
fit.ward2 <- hclust(d, method = "ward.D2")
plot(fit.ward2)

rect.hclust(fit.ward2, h=15)

# Se quisermos trabalhar com análise de redes sociais
library(igraph)
matriz <- as.matrix(df)
g <- graph_from_incidence_matrix(matriz)
is.bipartite(g)
g
plot(g, vertex.size=4, vertex.label=V(g)$name, vertex.color=as.numeric(V(g)$type))
g2 <- bipartite_projection(g, which = "FALSE")
plot(g2, edge.width=log(E(g2)$weight), vertex.shape="none")
