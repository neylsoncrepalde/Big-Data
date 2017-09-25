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
tweets <- searchTwitter("temer", n=2000)
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
corpus <- Corpus(VectorSource(enc2native(text)))
corpus <- tm_map(corpus, content_transformer(tolower))
corpus <- tm_map(corpus, removePunctuation)
corpus <- tm_map(corpus, function(x)removeWords(x,stopwords("pt")))

# Monta wordclouds
wordcloud(enc2native(corpus), min.freq = 2, max.words = 100, random.order = F)
library(RColorBrewer)
pal2 <- brewer.pal(8,"Dark2")
wordcloud(enc2native(corpus), min.freq=2,max.words=100, random.order=F, colors=pal2)
title(xlab = "Twitter, 17/03/2016, 00:19")

# Análise de clusterização
tdm <- TermDocumentMatrix(corpus)
tdm <- removeSparseTerms(tdm, sparse = 0.95)
df <- as.data.frame(as.matrix(tdm))
dim(df)
df.scale <- scale(df)
d <- dist(df.scale, method = "euclidean")
fit <- hclust(d)
plot(fit)
fit.ward2 <- hclust(d, method = "ward.D2")
plot(fit.ward2)

rect.hclust(fit.ward2, h=50)

# Se quisermos trabalhar com análise de redes sociais
library(igraph)
matriz <- as.matrix(df)
g <- graph_from_incidence_matrix(matriz)
is.bipartite(g)
g
plot(g, vertex.size=4, vertex.label=V(g)$name, vertex.color=as.numeric(V(g)$type))
g2 <- bipartite_projection(g, which = "FALSE")
plot(g2, edge.width=log(E(g2)$weight), vertex.shape="none")
