# Wikipedia Data Mining
# Script para a tese de Neylson Crepalde

library(WikipediR)
library(XML)
library(RCurl)

content <- page_content("en", "wikipedia", page_name = "Fabio_Mechetti")
content2 <- page_content("en", "wikipedia", page_name = "Marin_Alsop")
texto <- content$parse$text$`*`
texto2<- content2$parse$text$`*`

base <- "https://en.wikipedia.org/wiki/"
nome <- "Fabio Mechetti"
url <- paste(base, nome, sep="")

#pagina <- readLines(url)
#linhas <- grep("Orchestra", pagina)
#rank <- pagina[linhas]
#rank1 <- rank[1]
#rank2 <- rank[2]


library(stringi)
library(stringr)
words <- stri_count_words(texto)
frango <- stri_extract_all_words(texto, simplify = T)

frango <- as.vector(frango)

dados <- c()
orc <- c()
for (i in 1:length(frango)){

    if (frango[i]=="Orchestra"){
    orc[i] <- paste(frango[i-2], frango[i-1], frango[i], sep = " ")
    dados <- c(dados, orc[i])
  }
  else{
    print("pula")
  }
}
dados

for (i in 1:length(frango)){
  
  if (frango[i]=="Symphony"){
    orc[i] <- paste(frango[i-1], frango[i], sep = " ")
    dados <- c(dados, orc[i])
  }
  else{
    print("pula")
  }
}

for (i in 1:length(frango)){
  
  if (frango[i]=="Philharmonic"){
    orc[i] <- paste(frango[i-1], frango[i], sep = " ")
    dados <- c(dados, orc[i])
  }
  else{
    print("pula")
  }
}

dados

edges <- cbind(nome, dados)
edges <- unique(edges)

# programar a mineracao de dados com lapply numa funcao e fazer 
# tudo com lapply novamente
