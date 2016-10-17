# criticas
# Neylson Crepalde

################################################
### Ouvinte Critico - CONCERTO #################
################################################

library(XML)
library(RCurl)

url <- "http://www.concerto.com.br/ouvintepassado.asp"
page <- readLines(url)
page <- htmlParse(page)
page


################################################
### TWITTER ####################################
################################################

library(twitteR)
library(wordcloud)
library(tm)
library(plyr)

consumer_key <- "zZqautC9KVJXXcNAWVtOp0ipZ"
consumer_secret <- "QYccdNmLoLpSje7wFgY2GXo1qXofj4qIxK6fJPTrw1xHKqd5ou"
access_token <- "3036885015-RwYnJZAvbTnL6OBbkzgN3QGDPlhN5WtDQBp8ZdL"
access_secret <- "8duOLfdbJqbHem69FHzJD63hKEBCLDv0mesPLiB4v4dJ3"

setup_twitter_oauth(consumer_key,
                    consumer_secret,
                    access_token,
                    access_secret)

tweets <- searchTwitter("crítica+concerto+estadão", n=100)
bd <- ldply(tweets, function(t) t$toDataFrame() )