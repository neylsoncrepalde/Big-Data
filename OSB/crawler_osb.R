# Coletando artistas que participaram da OSB
# Neylson Crepalde
#=================================================

library(XML)
library(plyr)


#Montando a lista de links para captura
urlbase <- "http://www.osb.com.br/concertoseingressos/concerto.aspx?c=2"
links <- c()

# O primeiro link (188) deu problema. Tem que ser coletado manualmente.

for (i in 189:329){
  url = paste(urlbase, i, sep="")
  links = c(links, url)
  
}

head(links)
length(links)

#=================================================================
#=================================================================
#Capturando o conte?do dos links

contador <- 1
dados <- data.frame()
#links.problema <- c()

for (j in 1:length(links)){
  print(contador)
  
  pagina <- readLines(links[j])

  pagina <- htmlParse(pagina)
  pagina <- xmlRoot(pagina)
  
  #data <- getNodeSet(pagina, "//*[@id='ctl00_ctl00_Corpo_Corpo_ConteudoDatas']/div/div[1]/table/tbody/tr/td")
  #data <- xmlApply(data, xmlValue)
  
  
  artista <- getNodeSet(pagina, "//a[@class='ConteudoDestaque HandCursor']")
  artista <- xmlApply(artista, xmlValue)
  
  #competencia <- getNodeSet(pagina, "//span[@class='ConteudoNormal']")
  #competencia <- xmlApply(competencia, xmlValue)
  
  artista.vetor <- as.data.frame(cbind(artista), stringsAsFactors = T)
  #data.frame <- merge(artista.competencia, data)
  
  dados <- rbind(dados, artista.vetor)
  
  contador <- contador+1
}

# A captura termina aqui.
#=========================================================


dados[,2] <- "OSB"
head(dados)
dados[[1]] <- as.factor(dados[[1]])

tabela <- cbind(dados[[1]], dados[[2]])
class(tabela[[2]])
tabela[[1]] <- as.factor(tabela[[1]])
class(tabela[[1]])

dados <- unique(dados)
View(dados)


write.table(tabela, "C:/Users/neyls/Documents/Neylson Crepalde/Doutorado/rede_artistas_osb.csv", sep = ";",
            row.names = F, col.names = F)

