###################################
# Raspando uma página de notícia
# Big Data - MQuinho 2017
# Neylson Crepalde
###################################

library(XML)
library(magrittr)

url = "https://g1.globo.com/mundo/noticia/confianca-do-comercio-avanca-em-setembro-apos-4-quedas-seguidas-aponta-fgv.ghtml"

pagina = readLines(link) %>% htmlParse %>% xmlRoot

titulo = getNodeSet(pagina, "//h1[@itemprop='headline']")
titulo = xmlSApply(titulo, xmlValue)

subtitulo = getNodeSet(pagina, "//h2[@class='content-head__subtitle']")
subtitulo = xmlSApply(subtitulo, xmlValue)

data = getNodeSet(pagina, "//time[@itemprop='datePublished']")
data = xmlSApply(data, xmlValue)

autor = getNodeSet(pagina, "//p[@class='content-publication-data__from']")
autor = xmlSApply(autor, xmlValue)

dados = data.frame(titulo, subtitulo, autor, data)
View(dados)
