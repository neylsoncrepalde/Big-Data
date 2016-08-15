# -*- coding: utf-8 -*-
from urllib.request import urlopen
from urllib.error import HTTPError
from bs4 import BeautifulSoup

def getTitle(url):
    try:    
        html = urlopen(url)
    except HTTPError as e:
        return None
    try:
        bsObj = BeautifulSoup(html.read())
        title = bsObj.body.h1
    except AttributeError as e:
        return None
    return title

title = getTitle("http://www.pythonscraping.com/pages/page1.html")
if title == None:
    print("Title not found")
else:
    print(title)
    

# Buscando num html por atributos das tags

html = urlopen("http://www.pythonscraping.com/pages/warandpeace.html")
bsObj = BeautifulSoup(html)

nameList = bsObj.findAll("span", {"class": "green", "class": "red"})
for name in nameList:
    print(name.get_text())
    
# Buscando tags filhas (children)

html = urlopen("http://www.pythonscraping.com/pages/page3.html")
bsObj = BeautifulSoup(html)

for child in bsObj.find("table", {"id": "giftList"}).children:
    print(child)
    
#Printando as linhas de uma tabela onde a primeira linha é título
for sibling in bsObj.find("table", {"id": "giftList"}).tr.next_siblings:
    print(sibling)


