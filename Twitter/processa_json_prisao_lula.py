#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sat Apr  7 10:54:03 2018

@author: neylson
"""

import json
from json import JSONDecodeError
import pandas as pd
import time

file = open('prisao_lula_tweets3.txt', 'r')

jsonFile = file.readlines()

ex = json.loads(jsonFile[0])
bdex = pd.DataFrame.from_dict(ex)
bdex['user_name'] = bdex['user']['screen_name']
bdex['user_favourites_count'] = bdex['user']['favourites_count']
bdex['user_followers_count'] = bdex['user']['followers_count']
bdex['user_id'] = bdex['user']['id']
bdex['user_id_str'] = bdex['user']['id_str']

print('Quantidade de tweets a serem processados: ' + str(len(jsonFile)))
print('\n')
time.sleep(5)
print('Processando...')

tweets = bdex.loc[['user_mentions']]
erros = []

for i in range(10):
    print(i)
    try:
        l = json.loads(jsonFile[i])
    except JSONDecodeError:
        continue
    try:
        bd = pd.DataFrame.from_dict(l)
    except ValueError:
        erros.append(i)
        continue
    try:
        bd['user_name'] = bd['user']['screen_name']
    except KeyError:
        erros.append(i)
        continue
    bd['user_favourites_count'] = bd['user']['favourites_count']
    bd['user_followers_count'] = bd['user']['followers_count']
    bd['user_id'] = bd['user']['id']
    bd['user_id_str'] = bd['user']['id_str']
    pd.concat([tweets, bd.loc[['user_mentions']]], ignore_index=True)

tweets.shape

print('Número de tweets com erro: ' + str(len(erros)))
print('Dimensões do banco de tweets coletado: ' + str(tweets.shape))

