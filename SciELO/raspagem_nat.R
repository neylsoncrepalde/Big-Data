###########################################
# Raspagem Revistas de Ciência Política
# Nathália Porto
# Script: Neylson Crepalde
###########################################

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




#########################################################
# Montando df com revista, ano, titulo, autores, keyword
#########################################################
contador = 2874
raspagem_nat = c()
links.problema = c()

for (artigo in artigos[2874:length(artigos)]){
  
  cat(paste0(contador, "\n"))
  pagina <- readLines(artigo)
  pagina <- htmlParse(pagina)
  link.xml <- getNodeSet(pagina,"//a[@target='xml']")
  link.xml <- xmlSApply(link.xml, xmlGetAttr, name = "href")
  pagina.xml <- readLines(link.xml)
  Encoding(pagina.xml) = "latin1"
  
  erro <- try(xmlParse(pagina.xml), silent=TRUE)
  if ('try-error' %in% class(erro)){
    links.problema = c(links.problema, artigo)
  }
  else {
    pagina.xml <- xmlParse(pagina.xml)
    pagina.xml <- xmlRoot(pagina.xml)
    
    # autores
    autores.sobrenomes <- getNodeSet(pagina.xml, "//contrib/name/surname")
    autores.sobrenomes <- xmlSApply(autores.sobrenomes, xmlValue)
    autores.nomes <- getNodeSet(pagina.xml, "//contrib/name/given-names")
    autores.nomes <- xmlSApply(autores.nomes, xmlValue)
    autores.df <- as.data.frame(cbind(autores.nomes, autores.sobrenomes), 
                                stringsAsFactors = F)
    
    # titulos
    titulos <- getNodeSet(pagina.xml,"//article-meta/title-group/article-title[@xml:lang='en']")
    # pega a tag article-title que tem um atributo xml:lan="en" esta dentro de title-group dentro de article-meta e dentro de front
    titulos <- xmlSApply(titulos, xmlValue) #pega o valor da tag e guarda no vetor
    if(length(titulos)==0){
      titulos <- getNodeSet(pagina.xml,"//article-meta/title-group/article-title[@xml:lang='pt']")
      #pega o titulo em pt ao inves disso
      titulos <- xmlSApply(titulos, xmlValue)
      if (length(titulos)==0){    # Se não tiver keyword
        contador = contador + 1
        next                                  # próxima iteração
      }
      else{    #do contrario
        titulos <- data.frame(titulos)
      }
    }
    titulos <- data.frame(titulos)
    
    # ano
    ano <- getNodeSet(pagina.xml, "//article-meta//pub-date[@pub-type='pub']/year")
    ano <- xmlSApply(ano, xmlValue)
    ano <- data.frame(ano)
    
    # revista
    revista <- getNodeSet(pagina.xml, "//journal-meta//journal-title")
    revista <- xmlSApply(revista, xmlValue)
    revista <- data.frame(revista)
    
    # palavras-chave
    keywords <- getNodeSet(pagina.xml, "//kwd-group//kwd[@lng='en']")
    if (length(keywords)==0){    # Se não tiver keyword
      contador = contador + 1
      next                                  # próxima iteração
    }
    else{    #do contrario
      keywords <- xmlSApply(keywords, xmlValue)
      keywords <- as.data.frame(keywords)
    }
    
    # Junta tudo num data.frame
    uma_linha = data.frame(revista, titulos, ano, stringsAsFactors = F)
    titulos.autores = merge(titulos, autores.df)
    titulos.keys = merge(titulos, keywords)
    quase_tudo = full_join(uma_linha, titulos.autores, by="titulos")
    tudo_junto = full_join(quase_tudo, titulos.keys, by="titulos")
    raspagem_nat = rbind(raspagem_nat, tudo_junto)
  }
  contador = contador+1
}

setwd('D:/Neylson Crepalde/Raspagem Ciência Política')
#readr::write_csv(raspagem_nat, "raspagem_nat1.csv") # Do 1 ao 498
#readr::write_csv(raspagem_nat, "raspagem_nat2.csv") # Do 499 ao 1745
#readr::write_csv(raspagem_nat, "raspagem_nat3.csv") # Do 1745 ao 2859
#readr::write_csv(raspagem_nat, "raspagem_nat4.csv") # Do 2861 ao 2872
#readr::write_csv(raspagem_nat, "raspagem_nat5.csv") # Do 2872 ao final

##############################
# Juntando os dfs exportados
library(readr)
data1 = read_csv("raspagem_nat1.csv")
data2 = read_csv("raspagem_nat2.csv")
data3 = read_csv("raspagem_nat3.csv")
data4 = read_csv("raspagem_nat4.csv")
data5 = read_csv("raspagem_nat5.csv")

completo = rbind(data1, data2, data3, data4, data5); dim(completo)
completo = unique(completo); dim(completo)

#write_csv(completo, "dados_raspagem_nat.csv")
