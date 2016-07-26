# -*- coding: utf-8 -*-
'''
Geting tweets with TwitterAPI
@author: 'Neylson Crepalde'
version: 3.5.2
'''
from TwitterAPI import TwitterAPI
import json

api = TwitterAPI(consumer_key='XXXXXXXXXXXXXXXXXXXXXXXXX',
                         consumer_secret='XXXXXXXXXXXXXXXXXXXXXXXXX',
                         access_token_key='XXXXXXXXXXXXXXXXXXXXXXXXX-XXXXXXXXXXXXXXXXXXXXXXXXX',
                         access_token_secret='XXXXXXXXXXXXXXXXXXXXXXXXX')

filters = {"track": ["big data"]}
r = api.request('statuses/filter', filters).get_iterator()
saida = open("tweets_teste2.txt","w")

for item in r:
    itemString = json.dumps(item)
    saida.write(itemString + '\n')
