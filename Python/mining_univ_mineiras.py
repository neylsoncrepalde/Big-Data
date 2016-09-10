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

links = pegalinks('http://www.altillo.com/pt/universidades/brasil/estado/minasgerais.asp')
print(links)
