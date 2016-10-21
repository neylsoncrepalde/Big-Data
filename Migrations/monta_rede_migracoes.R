# Migration Network
# Doutorado em Sociologia
# SEA Populações
# Neylson Crepalde

library(readr)
library(magrittr)
library(dplyr)

bd <- read_csv2("~/Documentos/Neylson Crepalde/Doutorado/sea_populacoes/Seminario Big Data/migration_residence.csv",
                na = "..")
View(bd)

rede.total = data.frame()
for (row in 1:length(bd$Type)){
  if (bd$Type[row] == "Emigrants"){
    rede.total[row,1] = bd$country[row]
    rede.total[row,2] = bd$OdName[row]
    rede.total[row,3] = sum(bd[row,10:43], na.rm = T)
  }
  
  if (bd$Type[row] == "Immigrants"){
    rede.total[row,1] = bd$OdName[row]
    rede.total[row,2] = bd$country[row]
    rede.total[row,3] = sum(bd[row,10:43], na.rm = T)
  }
}
View(rede.total)

########################################################
# Montando as redes
########################################################
library(maps)
library(geosphere)
library(ggmap)

#separando os nomes dos paises
paises = c( levels(as.factor(rede.total[[1]])), levels(as.factor(rede.total[[2]])))
paises = unique(paises)
paises[53] = "Cote D'Ivoire"
china = grep("China", paises)
paises[china] = "China"
paises = unique(paises)

#Pegando latlon para cada pais
paises.latlon[,1] = data.frame(paises, stringsAsFactors = F)

for (pais in 1:length(paises)){
  latlon = geocode(paises[pais])
  
  paises.latlon[pais,2] = latlon$lat
  paises.latlon[pais,3] = latlon$lon
}

# Travou no 165. Vamos continuar daqui
View(paises.latlon)
paises.latlon[165,1] = "Reunion"

for (pais in 166:length(paises)){
  latlon = geocode(paises[pais])
  
  paises.latlon[pais,2] = latlon$lat
  paises.latlon[pais,3] = latlon$lon
}

nas = which(is.na(paises.latlon[,2]))
for (i in nas){print(paises.latlon[i,1])}
paises.latlon[25,1] = "Bolivia"
paises.latlon[53,1] = "Korea"
paises.latlon[130,1] = "Micronesia"
paises.latlon[162,1] = "Korea"

for (pais in nas){
  latlon = geocode(paises.latlon[pais,1])
  
  paises.latlon[pais,2] = latlon$lat
  paises.latlon[pais,3] = latlon$lon
}

which(is.na(paises.latlon[,2]))
paises.latlon[89,1]
vaticano = geocode("Vatican")
paises.latlon[89,2] = vaticano$lat
paises.latlon[89,3] = vaticano$lon

which(is.na(paises.latlon[,2]))
names(paises.latlon) = c("paises","lat","lon")
write.csv2(paises.latlon, "~/Documentos/Neylson Crepalde/Doutorado/sea_populacoes/Seminario Big Data/paises_latlon.csv",
           row.names = F)
paises.latlon = read_csv2("~/Documentos/Neylson Crepalde/Doutorado/sea_populacoes/Seminario Big Data/paises_latlon.csv")


names(rede.total) = c("from","to","weight")
head(paises.latlon)
dim(paises.latlon)

rede.latlon = data.frame(rede.total, stringsAsFactors = F)

#Corrigindo os nomes dos paises
bolivia = grep("Bolivia", rede.latlon[,1])
rede.latlon[bolivia,1] = "Bolivia"
bolivia = grep("Bolivia", rede.latlon[,2])
rede.latlon[bolivia,2] = "Bolivia"

korea = grep("Korea", rede.latlon[,1])
rede.latlon[korea,1] = "Korea"
korea = grep("Korea", rede.latlon[,2])
rede.latlon[korea,2] = "Korea"

micronesia = grep("Micronesia", rede.latlon[,1])
rede.latlon[micronesia,1] = "Micronesia"
micronesia = grep("Micronesia", rede.latlon[,2])
rede.latlon[micronesia,2] = "Micronesia"

china = grep("China", rede.latlon[,1])
rede.latlon[china,1] = "China"
china = grep("China", rede.latlon[,2])
rede.latlon[china,2] = "China"

reunion = grep("union", rede.latlon[,1])
rede.latlon[reunion,1] = "Reunion"
reunion = grep("union", rede.latlon[,2])
rede.latlon[reunion,2] = "Reunion"

cote.divoire = grep("d'Ivoire", rede.latlon[,1])
rede.latlon[cote.divoire,1] = "Cote D'Ivoire"
cote.divoire = grep("d'Ivoire", rede.latlon[,2])
rede.latlon[cote.divoire,2] = "Cote D'Ivoire"

# Tirando Unknown e Total
unknown1 = grep("Unknown", rede.latlon[,1])
unknown2 = grep("Unknown", rede.latlon[,2])
rede.latlon = rede.latlon[-c(unknown1,unknown2),]

total1 = grep("Total", rede.latlon[,1])
total2 = grep("Total", rede.latlon[,2])
rede.latlon = rede.latlon[-c(total1,total2),]

# Fazendo os joins
rede.latlon = left_join(x=rede.latlon, y=paises.latlon, by=c("from"="paises"))
names(rede.latlon)[4:5] = c("from.lat","from.lon")
rede.latlon = left_join(x=rede.latlon, y=paises.latlon, by=c("to"="paises"))
names(rede.latlon)[6:7] = c("to.lat","to.lon")

#View(rede.latlon)

write.csv2(rede.total, "~/Documentos/Neylson Crepalde/Doutorado/sea_populacoes/Seminario Big Data/rede_total.csv",
           row.names = F)
write.csv2(rede.latlon, "~/Documentos/Neylson Crepalde/Doutorado/sea_populacoes/Seminario Big Data/rede_latlon.csv",
           row.names = F)