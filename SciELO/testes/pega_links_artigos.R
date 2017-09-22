###########################################
# Raspagem Revistas de Ciência Política
# Script: Neylson Crepalde
###########################################

setwd("~/Documentos/Bibliometria")

library(XML)
library(dplyr)

revistas = c('http://www.scielo.br/scielo.php?script=sci_issues&pid=0011-5258&lng=en&nrm=iso',
             'http://www.scielo.br/scielo.php?script=sci_issues&pid=0102-6909&lng=en&nrm=iso',
             'http://www.scielo.br/scielo.php?script=sci_issues&pid=0103-3352&lng=en&nrm=iso',
             'http://www.scielo.br/scielo.php?script=sci_issues&pid=0102-6445&lng=en&nrm=iso',
             'http://www.scielo.br/scielo.php?script=sci_issues&pid=0104-6276&lng=en&nrm=iso',
             'http://www.scielo.br/scielo.php?script=sci_issues&pid=1981-3821&lng=en&nrm=i'
)

###############################
# Pegando todas as edições.

edicoes = c()
for (revista in revistas){
  pagina <- readLines(revista)
  pagina <- htmlParse(pagina) 
  pagina <- xmlRoot(pagina) 
  
  links <- getNodeSet(pagina,"//font[@color]/a[@href]")
  links <- xmlSApply(links, xmlGetAttr, name = "href")
  edicao <- unlist(links)[2:length(links)]
  edicoes <- c(edicoes, edicao)
}

################################
# Pegando todos os artigos

artigos = c()
for(ed in edicoes){
  pagina <- readLines(ed)
  pagina <- htmlParse(pagina)
  pagina <- xmlRoot(pagina)
  links <- getNodeSet(pagina,"//div[@align='left']/a[@href]")
  links <- xmlSApply(links, xmlGetAttr, name = "href")
  links <- grep("arttext", links, value = T)
  artigos <- c(artigos, links)
}   
artigos <- unlist(artigos)
write.table(artigos, "artigos.txt", sep = "\n", row.names = F, col.names = F)
