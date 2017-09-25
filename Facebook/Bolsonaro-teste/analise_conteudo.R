# Dados do Facebook
# MQuinho 2017
# Neylson Crepalde
#########################

# Carregando pacotes necessários
library(data.table)
library(tm)
library(wordcloud)
library(magrittr)

# Define o diretório de trabalho
# Mude para a pasta de trabalho onde você salvou os dados do Facebook
setwd('~/raspagem_face')

#lista os arquivos no diretório
list.files()

#lê os dados
coments = fread("page_211857482296579_2017_09_25_23_02_02_comments.tab",
                encoding="UTF-8")

#Exibe os primeiros casos dos comentários
head(coments$comment_message)

#Limpa os dados

conteudo = coments$comment_message %>% removePunctuation %>%
  removeWords(., stopwords('pt'))

# Monta a nuvem de palavras
wordcloud(enc2native(conteudo), min.freq=4, max.words = 100, random.order = F)

#----------------------
# Análise de conteúdo

corpus <- Corpus(VectorSource(enc2native(conteudo)))
tdm <- TermDocumentMatrix(corpus)
tdm <- removeSparseTerms(tdm, sparse = 0.98)
df <- as.data.frame(as.matrix(tdm))
dim(df)
df.scale <- scale(df)
d <- dist(df.scale, method = "euclidean")
fit.ward2 <- hclust(d, method = "ward.D2")
plot(fit.ward2)




