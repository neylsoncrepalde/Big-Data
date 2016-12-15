# -*- coding: utf-8 -*-
from urllib.request import urlopen
from urllib.error import HTTPError
import pandas as pd
from bs4 import BeautifulSoup
import os
import csv
import time

ini = time.time()

os.chdir('/home/neylson/Documentos/Neylson Crepalde/Doutorado/GIARS/SBS_sociologia_economica')

#Abrindo o arquivo para escrever os dados
saida = open('keywords_df.csv', 'w')
export = csv.writer(saida, quoting=csv.QUOTE_NONNUMERIC)
export.writerow(['link','keyword'])

artigos = pd.read_csv('artigos_sociologia_scielo.csv', sep=';', header=None)
artigos = artigos[0].tolist()

for url in artigos:
    
    pagina = urlopen(url)
    pagina = BeautifulSoup(pagina)
    
    for i in pagina.findAll("a", {"target":"xml"}):
        pagina_xml = i.get('href')
    
    xml = urlopen(pagina_xml)
    xml = BeautifulSoup(xml, "lxml-xml")
    
    keys = []
    for i in xml.findAll("kwd", {"lng":"pt"}):
        keys.append(i.get_text())
    
    for i in range(len(keys)):
        export.writerow([url, keys[i] ])

#por último
saida.close()

fim = time.time()
print("Tempo de execução: ", fim-ini)
