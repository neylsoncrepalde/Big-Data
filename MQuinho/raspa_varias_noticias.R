####################################
# Raspando várias páginas de notícia
# Big Data - MQuinho 2017
# Neylson Crepalde
####################################

library(XML)
library(magrittr)

url_base = readLines("http://g1.globo.com/economia/") %>% htmlParse %>% xmlRoot

link = getNodeSet(url_base, "//div[@class='feed-post-body']//div[@class='feed-text-wrapper']//a[@href]")
links = xmlSApply(link, xmlGetAttr, name="href") %>% unlist
links

contador = 1
links.problema = c()
dados = data.frame()

for (link in links){
  cat(paste0(contador, '\n'))
  
  pagina = readLines(link) %>% htmlParse %>% xmlRoot
  
  titulo = getNodeSet(pagina, "//h1[@itemprop='headline']")
  titulo = xmlSApply(titulo, xmlValue)
  
  subtitulo = getNodeSet(pagina, "//h2[@class='content-head__subtitle']")
  subtitulo = xmlSApply(subtitulo, xmlValue)
  
  data = getNodeSet(pagina, "//time[@itemprop='datePublished']")
  data = xmlSApply(data, xmlValue)
  
  autor = getNodeSet(pagina, "//p[@class='content-publication-data__from']")
  autor = xmlSApply(autor, xmlValue)
  
  erro <- try( data.frame(titulo, subtitulo, autor, data) ) 
  if ('try-error' %in% class(erro)){
    links.problema = c(links.problema, link)
    contador = contador + 1
    next
  }
  else {
  bd = data.frame(titulo, subtitulo, autor, data)
  dados = rbind(dados, bd)
  
  contador = contador+1
  }
}
print("CABÔ!!!")
View(dados)
