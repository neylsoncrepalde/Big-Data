# -*- coding: utf-8 -*-
# Raspando dados de universidades Mineiras
from urllib.request import urlopen
from urllib.error import HTTPError
from bs4 import BeautifulSoup

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

tipoTag = type(bsObj.blockquote)
#Entrando em todas as paginas
for pagina in paginas_completas[:2]:
    try:    
        html = urlopen(pagina)
    except HTTPError as e:
        print('Page not found')
    bsObj = BeautifulSoup(html.read(), 'lxml')
    cursos = []
    for child in bsObj.find('blockquote').descendants:
        if type(child) == tipoTag:
            print(child.get_text())
        else:
            print(child)
