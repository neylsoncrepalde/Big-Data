# Migration Network by year
# Doutorado em Sociologia
# SEA Populações
# Neylson Crepalde

library(readr)
library(magrittr)
library(dplyr)

bd <- read_csv2("~/Documentos/Neylson Crepalde/Doutorado/sea_populacoes/Seminario Big Data/migration_residence.csv",
                na = "..")
for (col in 10:43){
  bd[[col]] %<>% as.character
  bd[[col]] = recode(bd[[col]], "0" = "NA")
  bd[[col]] %<>% as.integer
}

# extraindo as redes por ano
mig.2013 = bd[,c(1:9,44,45,43)]
mig.2012 = bd[,c(1:9,44,45,42)]
mig.2011 = bd[,c(1:9,44,45,41)]
mig.2010 = bd[,c(1:9,44,45,40)]
mig.2009 = bd[,c(1:9,44,45,39)]
mig.2008 = bd[,c(1:9,44,45,38)]
mig.2007 = bd[,c(1:9,44,45,37)]
mig.2006 = bd[,c(1:9,44,45,36)]
mig.2005 = bd[,c(1:9,44,45,35)]
mig.2004 = bd[,c(1:9,44,45,34)]
mig.2003 = bd[,c(1:9,44,45,33)]

anos = list(mig.2003, mig.2004, mig.2005, mig.2006, mig.2007, mig.2008, mig.2009, mig.2010, mig.2011, mig.2012, mig.2013)
# 2003
rede.2003 = data.frame()
for (row in 1:length(mig.2003$Type)){
  if (mig.2003$Type[row] == "Emigrants"){
    rede.2003[row,1] = mig.2003$country[row]
    rede.2003[row,2] = mig.2003$OdName[row]
    rede.2003[row,3] = mig.2003$`2003`[row]
  }
  
  if (mig.2003$Type[row] == "Immigrants"){
    rede.2003[row,1] = mig.2003$OdName[row]
    rede.2003[row,2] = mig.2003$country[row]
    rede.2003[row,3] = mig.2003$`2003`[row]
  }
}
#View(rede.2003)
rede.2003 %<>% na.omit

# 2004
rede.2004 = data.frame()
for (row in 1:length(mig.2004$Type)){
  if (mig.2004$Type[row] == "Emigrants"){
    rede.2004[row,1] = mig.2004$country[row]
    rede.2004[row,2] = mig.2004$OdName[row]
    rede.2004[row,3] = mig.2004$`2004`[row]
  }
  
  if (mig.2004$Type[row] == "Immigrants"){
    rede.2004[row,1] = mig.2004$OdName[row]
    rede.2004[row,2] = mig.2004$country[row]
    rede.2004[row,3] = mig.2004$`2004`[row]
  }
}
#View(rede.2004)
rede.2004 %<>% na.omit

# 2005
rede.2005 = data.frame()
for (row in 1:length(mig.2005$Type)){
  if (mig.2005$Type[row] == "Emigrants"){
    rede.2005[row,1] = mig.2005$country[row]
    rede.2005[row,2] = mig.2005$OdName[row]
    rede.2005[row,3] = mig.2005$`2005`[row]
  }
  
  if (mig.2005$Type[row] == "Immigrants"){
    rede.2005[row,1] = mig.2005$OdName[row]
    rede.2005[row,2] = mig.2005$country[row]
    rede.2005[row,3] = mig.2005$`2005`[row]
  }
}
#View(rede.2005)
rede.2005 %<>% na.omit

# 2006
rede.2006 = data.frame()
for (row in 1:length(mig.2006$Type)){
  if (mig.2006$Type[row] == "Emigrants"){
    rede.2006[row,1] = mig.2006$country[row]
    rede.2006[row,2] = mig.2006$OdName[row]
    rede.2006[row,3] = mig.2006$`2006`[row]
  }
  
  if (mig.2006$Type[row] == "Immigrants"){
    rede.2006[row,1] = mig.2006$OdName[row]
    rede.2006[row,2] = mig.2006$country[row]
    rede.2006[row,3] = mig.2006$`2006`[row]
  }
}
#View(rede.2006)
rede.2006 %<>% na.omit

# 2007
rede.2007 = data.frame()
for (row in 1:length(mig.2007$Type)){
  if (mig.2007$Type[row] == "Emigrants"){
    rede.2007[row,1] = mig.2007$country[row]
    rede.2007[row,2] = mig.2007$OdName[row]
    rede.2007[row,3] = mig.2007$`2007`[row]
  }
  
  if (mig.2007$Type[row] == "Immigrants"){
    rede.2007[row,1] = mig.2007$OdName[row]
    rede.2007[row,2] = mig.2007$country[row]
    rede.2007[row,3] = mig.2007$`2007`[row]
  }
}
#View(rede.2007)
rede.2007 %<>% na.omit

# 2008
rede.2008 = data.frame()
for (row in 1:length(mig.2008$Type)){
  if (mig.2008$Type[row] == "Emigrants"){
    rede.2008[row,1] = mig.2008$country[row]
    rede.2008[row,2] = mig.2008$OdName[row]
    rede.2008[row,3] = mig.2008$`2008`[row]
  }
  
  if (mig.2008$Type[row] == "Immigrants"){
    rede.2008[row,1] = mig.2008$OdName[row]
    rede.2008[row,2] = mig.2008$country[row]
    rede.2008[row,3] = mig.2008$`2008`[row]
  }
}
#View(rede.2008)
rede.2008 %<>% na.omit

# 2009
rede.2009 = data.frame()
for (row in 1:length(mig.2009$Type)){
  if (mig.2009$Type[row] == "Emigrants"){
    rede.2009[row,1] = mig.2009$country[row]
    rede.2009[row,2] = mig.2009$OdName[row]
    rede.2009[row,3] = mig.2009$`2009`[row]
  }
  
  if (mig.2009$Type[row] == "Immigrants"){
    rede.2009[row,1] = mig.2009$OdName[row]
    rede.2009[row,2] = mig.2009$country[row]
    rede.2009[row,3] = mig.2009$`2009`[row]
  }
}
#View(rede.2009)
rede.2009 %<>% na.omit

# 2010
rede.2010 = data.frame()
for (row in 1:length(mig.2010$Type)){
  if (mig.2010$Type[row] == "Emigrants"){
    rede.2010[row,1] = mig.2010$country[row]
    rede.2010[row,2] = mig.2010$OdName[row]
    rede.2010[row,3] = mig.2010$`2010`[row]
  }
  
  if (mig.2010$Type[row] == "Immigrants"){
    rede.2010[row,1] = mig.2010$OdName[row]
    rede.2010[row,2] = mig.2010$country[row]
    rede.2010[row,3] = mig.2010$`2010`[row]
  }
}
#View(rede.2010)
rede.2010 %<>% na.omit

# 2011
rede.2011 = data.frame()
for (row in 1:length(mig.2011$Type)){
  if (mig.2011$Type[row] == "Emigrants"){
    rede.2011[row,1] = mig.2011$country[row]
    rede.2011[row,2] = mig.2011$OdName[row]
    rede.2011[row,3] = mig.2011$`2011`[row]
  }
  
  if (mig.2011$Type[row] == "Immigrants"){
    rede.2011[row,1] = mig.2011$OdName[row]
    rede.2011[row,2] = mig.2011$country[row]
    rede.2011[row,3] = mig.2011$`2011`[row]
  }
}
#View(rede.2011)
rede.2011 %<>% na.omit

# 2012
rede.2012 = data.frame()
for (row in 1:length(mig.2012$Type)){
  if (mig.2012$Type[row] == "Emigrants"){
    rede.2012[row,1] = mig.2012$country[row]
    rede.2012[row,2] = mig.2012$OdName[row]
    rede.2012[row,3] = mig.2012$`2012`[row]
  }
  
  if (mig.2012$Type[row] == "Immigrants"){
    rede.2012[row,1] = mig.2012$OdName[row]
    rede.2012[row,2] = mig.2012$country[row]
    rede.2012[row,3] = mig.2012$`2012`[row]
  }
}
#View(rede.2012)
rede.2012 %<>% na.omit

# 2013
rede.2013 = data.frame()
for (row in 1:length(mig.2013$Type)){
  if (mig.2013$Type[row] == "Emigrants"){
    rede.2013[row,1] = mig.2013$country[row]
    rede.2013[row,2] = mig.2013$OdName[row]
    rede.2013[row,3] = mig.2013$`2013`[row]
  }
  
  if (mig.2013$Type[row] == "Immigrants"){
    rede.2013[row,1] = mig.2013$OdName[row]
    rede.2013[row,2] = mig.2013$country[row]
    rede.2013[row,3] = mig.2013$`2013`[row]
  }
}
#View(rede.2013)
rede.2013 %<>% na.omit