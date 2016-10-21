# UN - Migration Flows
# Doutorado em Sociologia
# SEA Populações
# Neylson Crepalde

library(gdata)
library(dplyr)

path <- "~/Documentos/Neylson Crepalde/Doutorado/sea_populacoes/Seminario Big Data/UN_MigFlow_All_Country/" #o caminho do diretorio (ajustar)
files <- list.files(path = path, pattern='[.]xlsx')    #lista os nomes dos arquivos
sites <- paste0(path,files)                           #cola as duas informacoes para realizar o loop

# Criando os data frames vazios para preencher e o contador
bd <- data.frame()
contador <- 1

##############################################################
# Efetuando a coleta de dados via for loop de RESIDENCE
for (i in 1:length(sites)){
  cat(contador)
  
  #importando os dados
  #E necessario ter o PERL instalado. Consultar https://www.perl.org/get.html
  df <- read.xls(sites[i], stringsAsFactors=F, sheet = 2, header=F)
  #View(df)
  
  df <- df[-c(1:8),]
  pais = df[1,1]
  pais = gsub("Reporting country: ", "", pais)
  criterion = df[2,1]
  criterion = gsub("Criterion: ", "", criterion)
  
  df <- mutate(df, country = pais, criterion = criterion)
  names(df)[1:43] = df[4,1:43]
  
  df = df[-c(1:4),]
  df = df[,-c(44:51)]
  
  bd = rbind(bd, df)
  contador=contador+1
}

write.csv2(bd, "~/Documentos/Neylson Crepalde/Doutorado/sea_populacoes/Seminario Big Data/migration_residence.csv", row.names = F)
