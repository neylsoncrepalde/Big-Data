###########################################
# Big Data e Sociologia Econômica no Brasil
# Silvio S. Higgins e Neylson Crepalde
###########################################

library(XML)
library(magrittr)

revistas = c('http://www.scielo.br/scielo.php?script=sci_issues&pid=0103-4979&lng=en&nrm=iso',
             'http://www.scielo.br/scielo.php?script=sci_issues&pid=0104-8333&lng=en&nrm=iso',
             'http://www.scielo.br/scielo.php?script=sci_issues&pid=0011-5258&lng=en&nrm=iso',
             'http://www.scielo.br/scielo.php?script=sci_issues&pid=0101-7330&lng=en&nrm=iso',
             'http://www.scielo.br/scielo.php?script=sci_issues&pid=0104-5970&lng=en&nrm=iso',
             'http://www.scielo.br/scielo.php?script=sci_issues&pid=0104-7183&lng=en&nrm=iso',
             'http://www.scielo.br/scielo.php?script=sci_issues&pid=0102-6445&lng=en&nrm=iso',
             'http://www.scielo.br/scielo.php?script=sci_issues&pid=0104-9313&lng=en&nrm=iso',
             'http://www.scielo.br/scielo.php?script=sci_issues&pid=0102-6909&lng=en&nrm=iso',
             'http://www.scielo.br/scielo.php?script=sci_issues&pid=0034-7701&lng=en&nrm=iso',
             'http://www.scielo.br/scielo.php?script=sci_issues&pid=0102-6992&lng=en&nrm=iso',
             'http://www.scielo.br/scielo.php?script=sci_issues&pid=1517-4522&lng=en&nrm=iso',
             'http://www.scielo.br/scielo.php?script=sci_issues&pid=0103-2070&lng=en&nrm=iso',
             'http://www.scielo.br/scielo.php?script=sci_issues&pid=2236-9996&lng=en&nrm=iso',
             'http://www.scielo.br/scielo.php?script=sci_issues&pid=1413-8123&lng=en&nrm=iso',
             'http://www.scielo.br/scielo.php?script=sci_issues&pid=0101-3300&lng=en&nrm=iso',
             'http://www.scielo.br/scielo.php?script=sci_issues&pid=0104-6276&lng=en&nrm=iso',
             'http://www.scielo.br/scielo.php?script=sci_issues&pid=0100-8587&lng=en&nrm=iso',
             'http://www.scielo.br/scielo.php?script=sci_issues&pid=0102-3098&lng=en&nrm=iso',
             'http://www.scielo.br/scielo.php?script=sci_issues&pid=0104-026X&lng=en&nrm=iso',
             'http://www.scielo.br/scielo.php?script=sci_issues&pid=0101-4714&lng=en&nrm=iso',
             'http://www.scielo.br/scielo.php?script=sci_issues&pid=1981-8122&lng=en&nrm=iso',
             'http://www.scielo.br/scielo.php?script=sci_issues&pid=1981-3821&lng=en&nrm=iso',
             'http://www.scielo.br/scielo.php?script=sci_issues&pid=0100-1574&lng=en&nrm=iso',
             'http://www.scielo.br/scielo.php?script=sci_issues&pid=0103-2186&lng=en&nrm=iso',
             'http://socialsciences.scielo.org/scielo.php?script=sci_issues&pid=1413-0580&lng=en&nrm=iso',
             'http://www.scielo.br/scielo.php?script=sci_issues&pid=1518-7012&lng=en&nrm=iso',
             'http://www.scielo.br/scielo.php?script=sci_issues&pid=1414-3283&lng=en&nrm=iso',
             'http://www.scielo.br/scielo.php?script=sci_issues&pid=0103-7331&lng=en&nrm=iso',
             'http://www.scielo.br/scielo.php?script=sci_issues&pid=0102-7182&lng=en&nrm=iso',
             'http://www.scielo.br/scielo.php?script=sci_issues&pid=0034-7590&lng=en&nrm=iso',
             'http://www.scielo.br/scielo.php?script=sci_issues&pid=0103-3352&lng=en&nrm=iso',
             'http://www.scielo.br/scielo.php?script=sci_issues&pid=1413-2478&lng=en&nrm=iso',
             'http://www.scielo.br/scielo.php?script=sci_issues&pid=0103-2003&lng=en&nrm=iso',
             'http://www.scielo.br/scielo.php?script=sci_issues&pid=0101-3157&lng=en&nrm=iso',
             'http://www.scielo.br/scielo.php?script=sci_issues&pid=0104-4478&lng=en&nrm=iso',
             'http://www.scielo.br/scielo.php?script=sci_issues&pid=1414-4980&lng=en&nrm=iso',
             'http://www.scielo.br/scielo.php?script=sci_issues&pid=0104-1290&lng=en&nrm=iso',
             'http://www.scielo.br/scielo.php?script=sci_issues&pid=0101-6628&lng=en&nrm=iso',
             'http://www.scielo.br/scielo.php?script=sci_issues&pid=1984-6487&lng=en&nrm=iso',
             'http://www.scielo.br/scielo.php?script=sci_issues&pid=1981-7746&lng=en&nrm=iso'
)

###############################
# Pegando todas as edições.

edicoes = c()
for (revista in revistas){
  pagina <- readLines(revista)
  pagina <- htmlParse(pagina) 
  pagina <- xmlRoot(pagina) 
  
  links <- getNodeSet(pagina,"//font[@color]/a[@href]")
  links <- xmlSApply(links, xmlGetAttr, name = "href")
  edicao <- unlist(links)[2:length(links)]
  edicoes <- c(edicoes, edicao)
}

################################
# Pegando todos os artigos

artigos = c()
for(ed in edicoes){
    pagina <- readLines(ed)
    pagina <- htmlParse(pagina)
    pagina <- xmlRoot(pagina)
    links <- getNodeSet(pagina,"//div[@align='left']/a[@href]")
    links <- xmlSApply(links, xmlGetAttr, name = "href")
    links <- grep("arttext", links, value = T)
    artigos <- c(artigos, links)
}   
artigos <- unlist(artigos)

# o df dos artigos está em "~/Documentos/Neylson Crepalde/Doutorado/GIARS/SBS_sociologia_economica/artigos_sociologia_scielo.csv"
