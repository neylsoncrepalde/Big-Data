#####################################
# Coletando feeds de notícias
# Script: Neylson Crepalde
#####################################

# Pacotes necessários
library(feedeR)
library(magrittr)

#Função para busca de feed no Google News
search.gnews <- function(chave=""){
  key = gsub(" ","+", chave)
  url <- "https://news.google.com/news?cf=all&hl=pt-BR&pz=1&ned=pt-BR_br&q=chavedebusca&output=rss"
  url.busca <- gsub("chavedebusca", key, url)
  return(url.busca)
}

search.gnews(c("greve","geral","no","brasil"))
news <- feed.extract(search.gnews("greve geral"), encoding = "UTF-8")

class(news)
news$items %>% View

# Extrainda feeds do google sobre Ciência e Tecnologia
# Link coletado no navegador
cet <- feed.extract("https://news.google.com/news?cf=all&hl=pt-BR&pz=1&ned=pt-BR_br&q=greve+geral&output=rss")
View(cet$items)

# Extraindo feeds do G1
# Link coletado no navegador (direcionamento)
g1 <- feed.extract("http://pox.globo.com/rss/g1/", encoding = "UTF-8")

# Raspando várias seções do Estado de Minas
urls <- c("http://www.em.com.br/rss/noticia/especiais/eleicoes/2016/rss.xml",
          "http://www.em.com.br/rss/noticia/economia/rss.xml",
          "http://www.em.com.br/rss/noticia/especiais/educacao/rss.xml",
          "http://www.em.com.br/rss/noticia/especiais/educacao/enem/rss.xml")

em = list()

for (i in urls){
  f <- feed.extract(i, encoding="UTF-8")
  em$title = c(em$title, f$title)
  em$link  = c(em$link, f$link)
  em$updated = c(em$updated, f$updated)
  em$items = rbind(em$items, f$items)
}

em$items %>% View
