# -*- coding: utf-8 -*-
# Raspando dados de universidades Mineiras
from urllib.request import urlopen
from urllib.error import HTTPError
from bs4 import BeautifulSoup
import os
import csv

def pegalinks(url):
    try:    
        html = urlopen(url)
    except HTTPError as e:
        return None
    bsObj = BeautifulSoup(html.read(), 'lxml')
    links = []
    for link in bsObj.findAll("a"):
        links.append(link.get('href'))
    links_validos = []
    for link in links:
        if link[:11] == 'minasgerais':
            links_validos.append(link)
        else:
            continue
    print('Lista de links pronta!')
    return links_validos

paginas = pegalinks('http://www.altillo.com/pt/universidades/brasil/estado/minasgerais.asp')
paginas_completas = []
for pagina in paginas:
    item = ('http://www.altillo.com/pt/universidades/brasil/estado/'+ pagina)
    paginas_completas.append(item)
print(paginas_completas)

def tipoTag(bsObj):
    return type(bsObj.blockquote)
    
def pega_nome(link):
    nome = link[66:]
    inst = nome[:-4]
    return inst.replace("_"," ")
    
os.chdir('/home/neylson/Documentos/Neylson Crepalde/Doutorado/GIARS/Antonio')
saida = open('universidades.csv', 'w')
export = csv.writer(saida, quoting=csv.QUOTE_NONNUMERIC)

#Entrando em todas as paginas
for pagina in paginas_completas:
    try:    
        html = urlopen(pagina)
    except HTTPError as e:
        print('Page not found')
    bsObj = BeautifulSoup(html.read(), 'lxml')
    cursos = []
    for child in bsObj.find('blockquote').findAll('p'):
        if type(child) == tipoTag(bsObj):
            print(pega_nome(pagina))
            print(child.get_text())
            export.writerow([pega_nome(pagina), child.get_text()])
        else:
            print(pega_nome(pagina))
            print(child)
            export.writerow([pega_nome(pagina), child])
