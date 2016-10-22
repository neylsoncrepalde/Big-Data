# Analises de redes migratorias
# Doutorado em Sociologia
# SEA Populações
# Neylson Crepalde

library(readr)
library(maps)
library(statnet)
library(igraph)
library(intergraph)
library(dplyr)
library(magrittr)

setwd("~/Documentos/Neylson Crepalde/Doutorado/sea_populacoes/Seminario Big Data/")

#####################################################################################
# ANALISES

paises.latlon = read_csv2("~/Documentos/Neylson Crepalde/Doutorado/sea_populacoes/Seminario Big Data/paises_latlon.csv")
rede.total = read_csv2("~/Documentos/Neylson Crepalde/Doutorado/sea_populacoes/Seminario Big Data/rede_total.csv") 
rede.latlon = read_csv2("~/Documentos/Neylson Crepalde/Doutorado/sea_populacoes/Seminario Big Data/rede_latlon.csv")

paises.latlon %<>% as_data_frame
rede.total %<>% as_data_frame
rede.latlon %<>% as_data_frame

View(rede.latlon)

g.ll = graph_from_edgelist(as.matrix(rede.latlon[,1:2]))
weight = rede.latlon$weight
class(weight)
E(g.ll)$weight = weight
g.ll

name = data.frame(V(g.ll)$name, stringsAsFactors = F)
latlon = left_join(name, paises.latlon, by=c("V.g.ll..name"="paises"))
#View(latlon)
latlon = latlon[-79,]
#View(cbind(name, latlon))

V(g.ll)$lat = latlon$lat
V(g.ll)$lon = latlon$lon

# plotando a rede
indeg = igraph::degree(g.ll, mode = "in")
coords = tk_coords(1)

png("migration_network.png", width = 1920, height = 1080)
plot(g.ll, vertex.size=indeg/40, edge.arrow.size=.3, edge.curved=T, 
     vertex.label.cex=indeg/220, layout=coords,
     edge.color = adjustcolor('grey',.2),
     vertex.label.color=adjustcolor('black', .8),
     vertex.color=adjustcolor('red', .6))
title(main = "Migration Flows", xlab="1980-2013\nSize = Indegree")
dev.off()

simple = simplify(g.ll)
n = asNetwork(simple)


# Plotando a rede no mapa

#pdf("migration.pdf", width=12, height=8)
png("migration.png", width = 1024, height = 768)
map("world", col="#f2f2f2", fill=TRUE, bg="white", lwd=0.08)
# plot the network using the geo coordinates
plot.network(n,  # pass in the network
             # don't erase the map before drawing the network
             new=FALSE, 
             # get coordiantes from vertices and pass in as 2-col matrix
             coord=cbind(n%v%'lon',n%v%'lat'),  
             # ---- all the rest of these are optional to make it look nice ------
             # set a semi-transparent edge color
             edge.col=adjustcolor('#AA555555', .3),
             # specifiy an edge width scaled as fraction of total co-occurence
             edge.lwd=rede.latlon$weight/10000000000,
             # making edges curve
             usecurve=F,
             edge.curve=.1,
             # set the vertex size
             vertex.cex=0.1,
             # set arrow size
             arrowhead.cex=0.5,
             # set a semi transparent vertex color
             vertex.col='#AA555555',
             vertex.border='white',
             # please don't jitter the points around
             jitter=FALSE)

title(main="Migration flows")
dev.off()

# Plotando com fundo preto
pal <- colorRampPalette(c("#333333", "white", "#1292db"))
colors <- pal(100)
colindex <- round( (E(g.ll)$weight) * length(colors) )
colindex = colindex/sd(colindex)

png("migration_black.png", width = 1024, height = 768)
map("world", col="#191919", fill=TRUE, bg="#000000", lwd=0.08)
# plot the network using the geo coordinates
plot.network(n,  # pass in the network
             # don't erase the map before drawing the network
             new=FALSE, 
             # get coordiantes from vertices and pass in as 2-col matrix
             coord=cbind(n%v%'lon',n%v%'lat'),  
             # ---- all the rest of these are optional to make it look nice ------
             # set a semi-transparent edge color
             edge.col=adjustcolor(colors[colindex], .3),
             # specifiy an edge width scaled as fraction of total co-occurence
             edge.lwd=rede.latlon$weight/10000000000,
             # making edges curve
             usecurve=F,
             edge.curve=.1,
             # set the vertex size
             vertex.cex=0.1,
             # set arrow size
             arrowhead.cex=0.5,
             # set a semi transparent vertex color
             vertex.col='#AA555555',
             vertex.border='white',
             # please don't jitter the points around
             jitter=FALSE)

title(main="Migration flows", col.main=adjustcolor("white", .6))
dev.off()

########################
# plotando a rede no espaço vazio
indeg = sna::degree(n, cmode = "indegree")
png("migration_network.png", width = 1024, height = 768)
plot.network(n, mode="fruchtermanreingold",
             # put labels
             displaylabels=T,
             label.cex=indeg*.006,
             label.color=adjustcolor('grey', .3),
             edge.col=adjustcolor('grey', .4),
             # specifiy an edge width scaled as fraction of total co-occurence
             edge.lwd=rede.latlon$weight/10000000000,
             # making edges curve
             usecurve=F,
             edge.curve=.1,
             # set the vertex size
             vertex.cex=indeg*.01,
             # set arrow size
             arrowhead.cex=1,
             # set a semi transparent vertex color
             vertex.col=adjustcolor('red', .6),
             vertex.border='white')
title(main="Migration Flows", xlab="1980 - 2013\nSize = Indegree")
dev.off()

# Plotando com IGRAPH

png("migration_black_igraph.png", width = 1920, height = 1080)
map("world", col="#191919", fill=TRUE, bg="#000000", lwd=0.08)
# plot the network using the geo coordinates
plot(g.ll,  # pass in the network
     # don't erase the map before drawing the network
     add=TRUE,
     # don't rescale
     rescale = F,
     # don't show labels
     vertex.label=NA,
     # get coordiantes from vertices and pass in as 2-col matrix
     layout=cbind(V(g.ll)$lon,V(g.ll)$lat),  
     # ---- all the rest of these are optional to make it look nice ------
     # set a semi-transparent edge color
     edge.color=adjustcolor("#5F9EA0", .05),
     edge.width=3,
     # making edges curve
     edge.curved=T,
     # set the vertex size
     vertex.size=10,
     # set arrow size
     edge.arrow.size=1,
     # set a semi transparent vertex color
     vertex.color='white',
     vertex.frame.color='white')

title(main="Migration flows", col.main=adjustcolor("white", .7))
dev.off()

