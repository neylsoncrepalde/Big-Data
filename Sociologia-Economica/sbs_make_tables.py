# -*- coding: utf-8 -*-
from urllib.request import urlopen
import pandas as pd
from bs4 import BeautifulSoup
import os
import csv

os.chdir('/home/neylson/Documentos/Neylson Crepalde/Doutorado/GIARS/SBS_sociologia_economica')

#Abrindo os arquivos
saida1 = open('title.csv','w')
export1 = csv.writer(saida1, quoting=csv.QUOTE_NONNUMERIC)
export1.writerow(['title','year','journal'])

saida2 = open('keys.csv','w')
export2 = csv.writer(saida2, quoting=csv.QUOTE_NONNUMERIC)
export2.writerow(['title','keyword'])

saida3 = open('autores.csv','w')
export3 = csv.writer(saida3, quoting=csv.QUOTE_NONNUMERIC)
export3.writerow(['title','author'])

saida4 = open('refs.csv','w')
export4 = csv.writer(saida4, quoting=csv.QUOTE_NONNUMERIC)
export4.writerow(['title','ref'])

#Começando a raspagem
artigos = pd.read_csv('artigos_soc_econ.csv', sep=';')
urls = artigos['link']

url_problema = []

contador = 0
for url in urls:
    print(contador)
    pagina = urlopen(url)
    pagina = BeautifulSoup(pagina, 'lxml')
        
    for i in pagina.findAll("a", {"target":"xml"}):
        pagina_xml = i.get('href')
        
    xml = urlopen(pagina_xml)
    xml = BeautifulSoup(xml, "lxml-xml")
        
    journal = xml.find("journal-title").get_text()
    try:
        title = xml.find("article-title", {"xml:lang":"pt"}).get_text()
    except AttributeError as e:
        title = xml.find("article-title", {"xml:lang":"en"}).get_text()
        
    year = xml.find("pub-date", {"pub-type":"pub"}).find("year").get_text()
    
    autores_sobrenomes = []
    for i in xml.front.find("contrib-group").findAll("surname"):
        autores_sobrenomes.append(i.get_text())
    
    autores_nomes = []
    for i in xml.front.find("contrib-group").findAll("given-names"):
        autores_nomes.append(i.get_text())
    
    autores = []
    for i in range(len(autores_sobrenomes)):
        autores.append( autores_sobrenomes[i] + ', ' + autores_nomes[i] )
    
    keys = []
    for i in xml.findAll("kwd", {"lng":"pt"}):
        keys.append(i.get_text())
    
    #Referências
    ref_sobrenomes = []
    try:
        for i in xml.back.findAll("surname"):
            ref_sobrenomes.append(i.get_text())
    except AttributeError as e:
        url_problema.append(url)
        contador = contador+1
        continue
    
    ref_nomes = []
    for i in xml.back.findAll("given-names"):
        ref_nomes.append(i.get_text())
        
    # Corrigindo problema de referências
    refs = []
    if len(ref_sobrenomes) == len(ref_nomes):
        for i in range(len(ref_sobrenomes)):
            x = ref_sobrenomes[i] + ', ' + ref_nomes[i]
            refs.append(x)
    else:
        for i in ref_sobrenomes:
            refs.append(i)
    
    # Escrevendo os dados
    export1.writerow([title, year, journal])
    
    for key in keys:
        export2.writerow([title, key])
    
    for autor in autores:
        export3.writerow([title, autor])
    
    for ref in refs:
        export4.writerow([title, ref])
        
    contador = contador+1

saida1.close()
saida2.close()    
saida3.close()
saida4.close()

print('Acabou!')
print(url_problema)
