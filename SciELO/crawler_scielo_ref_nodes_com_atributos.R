#teste XML
#construindo redes de coautoria da Revista Estudos Feministas SCIELO
#Neylson Crepalde
#==========================================================================

library(XML)

url.scielo <- "http://www.scielo.br/scielo.php?script=sci_issues&pid=0104-026X&lng=pt&nrm=iso"

pagina <- readLines(url.scielo) #le as linhas do codigo fonte e guarda no objeto pagina um vetor character
pagina <- htmlParse(pagina) #diz ao R que o vetor ? um HTML
pagina <- xmlRoot(pagina) #tira o que esta fora das tags maiores

links <- getNodeSet(pagina,"//font[@color]/a[@href]") #Pegando as tags de interesse atrav?s da tag mae e guardando em links
links <- xmlSApply(links, xmlGetAttr, name = "href") #pegando o atributo da tag que interessa: o link. Guarda em links
links.numeros.scielo <- unlist(links)[2:length(links)] #deslista



links.artigos.scielo <- c() #cria um vetor vazio para armazenar os links dos artigos dentro de cada edicao
for (i in links.numeros.scielo){ #loop para cada link fa?a isto:
  pagina <- readLines(i)         #leia as linhas do link da iteracao
  pagina <- htmlParse(pagina)    #diz ao R que ? um HTML
  pagina <- xmlRoot(pagina)      #tira o que est? fora das tags principais
  links <- getNodeSet(pagina,"//div[@align='left']/a[@href]") #pega as tags a que tenha um atributo href e que tenha como 
  #mae a tag div que tenha atributo align=left
  links <- xmlSApply(links, xmlGetAttr, name = "href") #pega o atributo href das tags
  links <- grep("arttext", links, value = T)           #limpa a lista mantendo somente os links que tem arttext no meio
  links.artigos.scielo <- c(links.artigos.scielo, links)   #guarda tudo no objeto links.artigos.scielo
}   
links.artigos.scielo <- unlist(links.artigos.scielo) #deslista!!!



#==============================================================================
# Montando um Data Frame autores instituicoes
#==============================================================================

contador = 1            #criando um contador
links.problema = c()    #criando um vetor para links com problema
links.sem.xref = c()
links.sem.kwd = c()
dados.autores.completo <- data.frame()   #criando um data.frame vazio para por os links bons
titulos.keywords <- data.frame()   #criando um data.frame vazio para os titulos anos e kwds

for (j in links.artigos.scielo[1:100]){  #loop para cada iteracao j (link de artigo) faca isto:
  cat(paste(as.character(contador), '\n'))              #imprima o contador atual
  pagina <- readLines(j)       #leia as linhas do link
  pagina <- htmlParse(pagina)  #diz ao R que ? HTML
  link.xml <- getNodeSet(pagina,"//a[@target='xml']")  #pega toda tag a que tem um atributo target=xml
  link.xml <- xmlSApply(link.xml, xmlGetAttr, name = "href") #pega o atributo href, o link
  pagina.xml <- readLines(link.xml)                          #l? as linhas da lista de links e guarda em paginas.xml
  
  # Algumas paginas estao com problemas no Parse
  # O codigo abaixo testa se o Parse funciona
  # Se nao funciona, armazena o link com problema em "links.problema"
  # Caso contrario, segue com o programa
  
  erro <- try(xmlParse(pagina.xml), silent=TRUE) #guarda no vetor erro o teste silencioso (sem warning) se xmlParse d? certo na pagina da iteracao
  if ('try-error' %in% class(erro)){  #se o objeto invisivel de classe try-error for encontrado no vetor que guarda o teste
    links.problema = c(links.problema, j) #mande o n?mero da iteracao para o vetor links.problema concatenando
  }
  else {                                 #do contrario
    pagina.xml <- xmlParse(pagina.xml)   #diga ao R que e um XML
    pagina.xml <- xmlRoot(pagina.xml)    # limpe o que esta fora das tags principais
    
    autores.sobrenomes <- getNodeSet(pagina.xml, "//contrib/name/surname")
    autores.sobrenomes <- xmlSApply(autores.sobrenomes, xmlValue)
    autores.nomes <- getNodeSet(pagina.xml, "//contrib/name/given-names")
    autores.nomes <- xmlSApply(autores.nomes, xmlValue)
    xref <- getNodeSet(pagina.xml, "//xref")
    
    if (length(xref)==0){    #se o objeto for encontrado no vetor que guarda o teste
      links.sem.xref = c(links.sem.xref, j)    #mande o n?mero da iteracao para o vetor links.sem.resumo
    }
    else{    #do contrario
    
    autores.aff <- xmlSApply(xref, xmlGetAttr, name = "rid")
    autores.df <- as.data.frame(cbind(autores.nomes, autores.sobrenomes, autores.aff), stringsAsFactors = F)
    
    institution <- getNodeSet(pagina.xml, "//aff")
    institution.name <- xmlSApply(institution, xmlValue)
    rid <- xmlSApply(institution, xmlGetAttr, name = "id")
    institution.df <- as.data.frame(cbind(rid, institution.name), stringsAsFactors = F)
  
    keywords <- getNodeSet(pagina.xml, "//kwd-group//kwd[@lng='en']")
    if (length(keywords)==0){    #se o objeto for encontrado no vetor que guarda o teste
      links.sem.kwd = c(links.sem.kwd, j)    #mande o n?mero da iteracao para o vetor links.sem.resumo
    }
    else{    #do contrario
    keywords <- xmlSApply(keywords, xmlValue)
    keywords <- as.data.frame(keywords)
    
    titulos <- getNodeSet(pagina.xml,"//article-meta/title-group/article-title[@xml:lang='en']")
    # pega a tag article-title que tem um atributo xml:lan="en" esta dentro de title-group dentro de article-meta e dentro de front
    titulos <- xmlSApply(titulos, xmlValue) #pega o valor da tag e guarda no vetor
    if(length(titulos)==0){
      titulos <- getNodeSet(pagina.xml,"//article-meta/title-group/article-title[@xml:lang='pt']")
      #pega o titulo em pt ao inves disso
      titulos <- xmlSApply(titulos, xmlValue)
    }
    titulos <- data.frame(titulos)
   
    ano <- getNodeSet(pagina.xml, "//article-meta//pub-date[@pub-type='pub']/year")
    ano <- xmlSApply(ano, xmlValue)
    ano <- data.frame(ano)
    
    
    titulos.ano <- cbind(titulos, ano)
    titulos.ano.kwd <- merge(titulos.ano, keywords)
    
    if (autores.df$autores.aff==institution.df$rid){
        autores.instituicoes <- merge(autores.df, institution.df, by.x = "autores.aff", by.y = "rid")
    }
    else{
      autores.df <- autores.df[,1:2]
      institution.df <- institution.df[,2]
      autores.instituicoes <- merge(autores.df, institution.df)
    }
      
    dados.autores <- merge(autores.instituicoes, titulos.ano)
    
    #ultimo condicional criado para resolver problemas de colunas diferentes
    if (contador>5){
      if (ncol(dados.autores)!=ncol(dados.autores.completo)){
        dados.autores <- dados.autores[,2:6]
        names(dados.autores) <- names(dados.autores.completo)
      }
    }
    
    dados.autores.completo <- rbind(dados.autores.completo, dados.autores, deparse.level = 1)
    titulos.keywords <- rbind(titulos.keywords, titulos.ano.kwd)
      }
    }
  }
  contador = contador+1
}

View(dados.autores.completo)
View(titulos.keywords)


########################################################################################
# Montando a rede
########################################################################################

edge.list <- mutate(dados.autores.completo,
                    autores = paste(autores.nomes, autores.sobrenomes)) %>% 
  select(autores, titulos)

head(edge.list)

library(igraph)

g <- graph_from_edgelist(as.matrix(edge.list), directed = F)
map <- bipartite_mapping(g)
V(g)$type <- map$type
is.bipartite((g))

V(g)$shape <- c("circle","square")[V(g)$type+1]
V(g)$color <- c("orange","steel blue")[V(g)$type+1]
plot(g, vertex.size=5, vertex.label=NA, edge.color="black")

proj <- bipartite_projection(g)

par(mfrow=c(1,2))
plot(proj$proj1, vertex.size=3, vertex.label=NA, layout=layout_in_circle,
     main='Rede de coautoria na revista\n"Estudos Feministas"', xlab='Densidade = 0.0013')
plot(proj$proj1, vertex.size=3, vertex.label=NA, layout=layout_with_fr,
     main='Rede de coautoria na revista\n"Estudos Feministas"', xlab='Densidade = 0.0013')
par(mfrow=c(1,1))
graph.density(proj$proj1)
hist(degree(proj$proj1), col='green', main='Histograma do grau\nEstudos Feministas', xlab='Grau', ylab='')

