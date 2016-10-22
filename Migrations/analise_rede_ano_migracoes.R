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

plot(g.2003, vertex.size=5, vertex.label.cex=.7, edge.arrow.size=.3, 
     edge.width=log(E(g.2003)$weight), edge.color=adjustcolor("grey70", .4))

matrix = as_adjacency_matrix(g.2003, attr = "weight")
View(as.matrix(matrix))

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
plot(network.extract(longnet, at=10), vertex.cex= sna::degree(longnet, cmode="indegree")/70)

# fazendo a animação
compute.animation(longnet, animation.mode = 'kamadakawai',
                  slice.par=list(start=0, end=10, interval=1, 
                                 aggregate.dur=1, rule='any'))
render.d3movie(longnet, usearrows = T, 
               displaylabels = F,
               bg="#ffffff", vertex.border="#333333",
               vertex.cex = sna::degree(longnet, cmode="indegree")/70,
               vertex.col = adjustcolor('red', .6),
               edge.col = adjustcolor('#55555599', .6),
               vertex.tooltip = paste("<b>Country:</b>", (longnet %v% "vertex.names")),
               launchBrowser=T, filename="longitudinal.html")

###################
# Modelizando a transformacao em 10 anos por configuracoes endogenas

formation = formula(~edges+mutual+gwesp(1,fixed=T)+gwidegree(1,fixed=T)+
                     gwodegree(1,fixed=T)+transitive)
dissolution = formation

#model = stergm(longnet, formation=formation, dissolution=dissolution,
#              estimate="CMLE", control=control.stergm(parallel = 8, parallel.type = "PSOCK"))
summary(model)
#mcmc.diagnostics(model) # Excelente estimação

#gof = gof(model)
par(mfrow=c(1,4))
#plot(gof)
par(mfrow=c(1,1))

#texreg(model, center = F, caption.above = T, caption = "Temporal ERGM",
#       custom.model.names = "2003 - 2013", digits = 3, single.row = T)


