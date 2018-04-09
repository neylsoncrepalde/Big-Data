#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sat Apr  7 10:54:03 2018

@author: neylson
sintaxe:
python processa_json.py nomedoarquivo inicio fim
Já tem que saber o número total de tweets
"""

import json
from json import JSONDecodeError
import pandas as pd
import time
import sys
from multiprocessing import Pool

t1 = time.time()

file = open(str(sys.argv[1]), 'r')
#file = open('prisao_lula_tweets3.txt', 'r')
start = int(sys.argv[2])
end = int(sys.argv[3])

jsonFile = file.readlines()

ex = json.loads(jsonFile[start])
bdex = pd.DataFrame.from_dict(ex)
bdex['user_name'] = bdex['user']['screen_name']
bdex['user_favourites_count'] = bdex['user']['favourites_count']
bdex['user_followers_count'] = bdex['user']['followers_count']
bdex['user_id'] = bdex['user']['id']
bdex['user_id_str'] = bdex['user']['id_str']

print('Processando arquivo: ' + str(sys.argv[1]))
print('Quantidade de tweets a serem processados: ' + str(end-start))
print('\n')
time.sleep(2)
    
tweets = bdex.loc[['user_mentions']]

def processaJson(file):
    global bd
    global l
    try:
        l = json.loads(file)
    except JSONDecodeError:
        pass
    try:
        bd = pd.DataFrame.from_dict(l)
    except ValueError:
        pass
    try:
        bd['user_name'] = bd['user']['screen_name']
        bd['user_favourites_count'] = bd['user']['favourites_count']
        bd['user_followers_count'] = bd['user']['followers_count']
        bd['user_id'] = bd['user']['id']
        bd['user_id_str'] = bd['user']['id_str']

        return bd.loc[['user_mentions']]
    except (KeyError, NameError):
        pass

print('Definindo threads...')
p = Pool(4)

print('Processando...')
res = p.map(processaJson, jsonFile[start:end])

print('Juntando as linhas...')
for i in range(1, len(res)):
    print(i)
    tweets = tweets.append(res[i], ignore_index=True)


#print('Número de tweets com erro: ' + str(len(erros)))
print('Dimensões do banco de tweets coletado: ' + str(tweets.shape))

print('Exportando...')

tweets.to_csv(str(sys.argv[1])[:-4] + '_' + str(start) +
              '_' + str(end) + '.csv')

t2 = time.time()

print('Pronto!')
print('Tempo de execução: ' + str(t2 - t1) + ' segundos.')
