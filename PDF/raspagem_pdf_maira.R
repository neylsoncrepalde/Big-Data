#Raspagem PDFs
#Dados Maíra Lobato
#Script: Neylson Crepalde
#TESTES

link <- "http://www.compos.org.br/biblioteca/retoricaproced_full_3268.pdf"
download.file(link, "artigo.pdf", method = "wget")

library(tm)
artigo <- readPDF(control = list(text = "-layout"))(elem = list(uri = "artigo.pdf"),
                                                   language = "pt", id = "id1")
artigo <- as.character(artigo)
artigo[1:50]

ref = grep("Referências", artigo)
referencias <- artigo[ref:length(artigo)]

#############################
# Fazendo a raspagem
is.number <- function(x) grepl("[[:digit:]]", x)

raspa.pdf <- function(){
  ref.final = c()
  contador = 1
  for (i in referencias){
  cat(contador)
  
  if (i == "" | substr(i, 1,1) == " " | substr(i, 1,1) == "\f"){
    next
  }
  
  if (substr(i, 1,2) == toupper(substr(i, 1,2))){
        if (is.number(substr(i, 1,1)) == TRUE){
          ref.final[contador-1] <- paste(ref.final[contador-1], i)
        }
        else{
          ref.final[contador] <- i
          contador = contador + 1
        }
  }
  
  else{
    ref.final[contador-1] <- paste(ref.final[contador-1], i)
  }
}
cat("Terminou, sô jegue...")
return(ref.final)
}

refs <- raspa.pdf()
print(refs)

