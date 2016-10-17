# Buscando tweets com LULA
# 16/03/2016, 22:57
# Neylson Crepalde

library(twitteR)
library(wordcloud)
library(tm)
library(plyr)

#necessary file for Windows
#download.file(url="http://curl.haxx.se/ca/cacert.pem", destfile="cacert.pem")

consumer_key <- "zZqautC9KVJXXcNAWVtOp0ipZ"
consumer_secret <- "QYccdNmLoLpSje7wFgY2GXo1qXofj4qIxK6fJPTrw1xHKqd5ou"
access_token <- "3036885015-RwYnJZAvbTnL6OBbkzgN3QGDPlhN5WtDQBp8ZdL"
access_secret <- "8duOLfdbJqbHem69FHzJD63hKEBCLDv0mesPLiB4v4dJ3"

setup_twitter_oauth(consumer_key,
                    consumer_secret,
                    access_token,
                    access_secret)

tweets <- searchTwitter("temer", n=2000)
bd <- ldply(tweets, function(t) t$toDataFrame() )
View(bd)

text <- sapply(tweets, function(x) x$getText())

corpus <- Corpus(VectorSource(text))
(f <- content_transformer(function(x) iconv(x, to='latin1', sub='byte')))
corpus <- tm_map(corpus, f)
corpus <- tm_map(corpus, content_transformer(tolower))
corpus <- tm_map(corpus, removePunctuation)
corpus <- tm_map(corpus, function(x)removeWords(x,stopwords("pt")))

wordcloud(corpus, min.freq = 2, max.words = 100, random.order = F)
library(RColorBrewer)
pal2 <- brewer.pal(8,"Dark2")
wordcloud(corpus, min.freq=2,max.words=100, random.order=F, colors=pal2)
title(xlab = "Twitter, 17/03/2016, 00:19")


tdm <- TermDocumentMatrix(corpus)
tdm <- removeSparseTerms(tdm, sparse = 0.95)
df <- as.data.frame(inspect(tdm))
dim(df)
df.scale <- scale(df)
d <- dist(df.scale, method = "euclidean")
fit <- hclust(d)
plot(fit)
fit.ward2 <- hclust(d, method = "ward.D2")
plot(fit.ward2)

rect.hclust(fit.ward2, h=50)

matriz <- as.matrix(df)

write.table(matriz, "C:/Users/neyls/Documents/Neylson Crepalde/Doutorado/GIARS/twitter/rede_lula_matriz.csv", sep = ";")

getwd()
source("C:/Users/neyls/AppData/Local/Pajek/PajekR.R")

library(igraph)
matriz <- as.matrix(df)
g <- graph_from_incidence_matrix(matriz)
is.bipartite(g)
g
plot(g, vertex.size=4, vertex.label=V(g)$name, vertex.color=as.numeric(V(g)$type))
g2 <- bipartite_projection(g, which = "FALSE")
plot(g2, edge.width=log(E(g2)$weight), vertex.shape="none")
