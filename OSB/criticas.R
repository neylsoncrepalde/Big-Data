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

consumer_key <- "XXXXXXXXXXXXXXXXXX"
consumer_secret <- "XXXXXXXXXXXXXXXXXXXXXXXXXX"
access_token <- "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
access_secret <- "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"

setup_twitter_oauth(consumer_key,
                    consumer_secret,
                    access_token,
                    access_secret)

tweets <- searchTwitter("crítica+concerto+estadão", n=100)
bd <- ldply(tweets, function(t) t$toDataFrame() )
