# Migration Network by year - ANALYSIS
# Doutorado em Sociologia
# SEA Populações
# Neylson Crepalde

setwd("~/Documentos/Neylson Crepalde/Doutorado/sea_populacoes/Seminario Big Data/")
source("~/Documentos/Neylson Crepalde/Doutorado/sea_populacoes/Seminario Big Data/monta_rede_ano_migracoes.R")

library(igraph)
library(statnet)
library(intergraph)
library(ndtv)
library(texreg)

#montando as redes
g.2003 = graph_from_edgelist(as.matrix(rede.2003[,1:2]))
g.2004 = graph_from_edgelist(as.matrix(rede.2004[,1:2]))
g.2005 = graph_from_edgelist(as.matrix(rede.2005[,1:2]))
g.2006 = graph_from_edgelist(as.matrix(rede.2006[,1:2]))
g.2007 = graph_from_edgelist(as.matrix(rede.2007[,1:2]))
g.2008 = graph_from_edgelist(as.matrix(rede.2008[,1:2]))
g.2009 = graph_from_edgelist(as.matrix(rede.2009[,1:2]))
g.2010 = graph_from_edgelist(as.matrix(rede.2010[,1:2]))
g.2011 = graph_from_edgelist(as.matrix(rede.2011[,1:2]))
g.2012 = graph_from_edgelist(as.matrix(rede.2012[,1:2]))
g.2013 = graph_from_edgelist(as.matrix(rede.2013[,1:2]))

# colocando os pesos
E(g.2003)$weight = rede.2003[,3]
E(g.2004)$weight = rede.2004[,3]
E(g.2005)$weight = rede.2005[,3]
E(g.2006)$weight = rede.2006[,3]
E(g.2007)$weight = rede.2007[,3]
E(g.2008)$weight = rede.2008[,3]
E(g.2009)$weight = rede.2009[,3]
E(g.2010)$weight = rede.2010[,3]
E(g.2011)$weight = rede.2011[,3]
E(g.2012)$weight = rede.2012[,3]
E(g.2013)$weight = rede.2013[,3]

#plot(g.2003, vertex.size=5, vertex.label.cex=.7, edge.arrow.size=.3, 
#     edge.width=log(E(g.2003)$weight), edge.color=adjustcolor("grey70", .4))

matrix = as_adjacency_matrix(g.2003, attr = "weight")
#View(as.matrix(matrix))

# Acrescentando IDH

idh = read_csv("HDI.csv", skip = 1)
View(idh)
nomes = as.data.frame(V(g.2013)$name, stringsAsFactors=F)
names(nomes) <- "Country"
names(idh)
nome_idh = left_join(nomes, idh, by=c("Country","Country"))
View(nome_idh)
nome_idh[36,3:12] <- idh[74,3:12]
nome_idh[42,3:12] <- idh[46,3:12]
nome_idh[136,3:12] <- idh[90,3:12]
nome_idh[48,3:12] = idh[40,3:12]
nome_idh[137,3:12] = idh[112, 3:12]
nome_idh[156,3:12] = idh[129,3:12]
nome_idh[173,3:12] = idh[179,3:12]
nome_idh[174,3:12] = idh[166,3:12]
nome_idh[175,3:12] = idh[180,3:12]
# Continua depois

g.2003 %<>% simplify
g.2004 %<>% simplify
g.2005 %<>% simplify
g.2006 %<>% simplify
g.2007 %<>% simplify
g.2008 %<>% simplify
g.2009 %<>% simplify
g.2010 %<>% simplify
g.2011 %<>% simplify
g.2012 %<>% simplify
g.2013 %<>% simplify


#####################################
# Montando o longitudinal

n.2003 = asNetwork(g.2003)
n.2004 = asNetwork(g.2004)
n.2005 = asNetwork(g.2005)
n.2006 = asNetwork(g.2006)
n.2007 = asNetwork(g.2007)
n.2008 = asNetwork(g.2008)
n.2009 = asNetwork(g.2009)
n.2010 = asNetwork(g.2010)
n.2011 = asNetwork(g.2011)
n.2012 = asNetwork(g.2012)
n.2013 = asNetwork(g.2013)

n.list = list(n.2003,n.2004,n.2005,n.2006,n.2007,n.2008,
              n.2009,n.2010,n.2011,n.2012,n.2013)
longnet = networkDynamic(network.list = n.list, vertex.pid = "vertex.names", create.TEAs = T)

# colocando o idh
names.long = longnet %v% "vertex.names"
names.long = as.data.frame(names.long, stringsAsFactors = F)
names(names.long) = "Country"
names.long = left_join(names.long, nome_idh, by="Country")
View(names.long)

idh.2013 = names.long$`2013`
seminfo = which(is.na(idh.2013)==T)
idh.2013[seminfo] = 0

idh.2013 = idh.2013 * 100
longnet %v% "HDI" = idh.2013

#plot(network.extract(longnet, at=10), vertex.cex= sna::degree(longnet, cmode="indegree")/70)

# fazendo a animação
#compute.animation(longnet, animation.mode = 'kamadakawai',
#                  slice.par=list(start=0, end=10, interval=1, 
#                                 aggregate.dur=1, rule='any'))
#render.d3movie(longnet, usearrows = T, 
#               displaylabels = F,
#               bg="#ffffff", vertex.border="#333333",
#               vertex.cex = sna::degree(longnet, cmode="indegree")/70,
#               vertex.col = adjustcolor('red', .6),
#               edge.col = adjustcolor('#55555599', .6),
#               vertex.tooltip = paste("<b>Country:</b>", (longnet %v% "vertex.names")),
#               launchBrowser=T, filename="longitudinal.html")

###################
# Modelizando a transformacao em 10 anos por configuracoes endogenas

formation = formula(~edges+mutual+gwesp(1,fixed=T)+gwidegree(1,fixed=T)+
                     gwodegree(1,fixed=T)+twopath+transitive+
                      nodeicov("HDI")+nodeocov("HDI")+absdiff("HDI"))
dissolution = formation

model = stergm(longnet, formation=formation, dissolution=dissolution,
              estimate="CMLE", control=control.stergm(parallel = 8, parallel.type = "PSOCK"))
summary(model)
mcmc.diagnostics(model) # Excelente estimação

gof = gof(model)
par(mfrow=c(1,4))
plot(gof)
par(mfrow=c(1,1))

texreg(model, center = F, caption.above = T, caption = "Temporal ERGM",
       custom.model.names = "2003 - 2013", digits = 3, single.row = T)

##########################################
# Modelizando apenas um ano (2013)
nomes.2013 = as.data.frame(n.2013 %v% "vertex.names", stringsAsFactors=F)
names(nomes.2013) = "Country"
intersecao =left_join(nomes.2013,nome_idh)
intersecao[[12]][ which(is.na(intersecao[[12]])) ] = 0
n.2013 %v% "HDI" = intersecao[[12]]

modelo1 <- formula(n.2013~edges+mutual+gwesp(1,fixed=T)+gwidegree(1,fixed=T)+
                     gwodegree(1,fixed=T)+twopath+transitive+
                     nodeicov("HDI")+nodeocov("HDI")+absdiff("HDI"))
summary.statistics(modelo1)
fit1 <- ergm(modelo1, control=control.ergm(main.method = "Stepping",
                                           parallel = 8, parallel.type = "PSOCK"))
mcmc.diagnostics(fit1)
summary(fit1)
gof1 = gof(fit1)
par(mfrow=c(1,4))
plot(gof1)
par(mfrow=c(1,1))

texreg(fit1, center = F, caption.above = T,
       custom.model.names = "ERGM - 2013", digits = 3, single.row = T)
