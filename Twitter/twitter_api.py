# -*- coding: utf-8 -*-
'''
Geting tweets with TwitterAPI
@author: 'Neylson Crepalde'
version: 3.5.2
'''
from TwitterAPI import TwitterAPI
import json

api = TwitterAPI(consumer_key='zZqautC9KVJXXcNAWVtOp0ipZ',
                         consumer_secret='QYccdNmLoLpSje7wFgY2GXo1qXofj4qIxK6fJPTrw1xHKqd5ou',
                         access_token_key='3036885015-RwYnJZAvbTnL6OBbkzgN3QGDPlhN5WtDQBp8ZdL',
                         access_token_secret='8duOLfdbJqbHem69FHzJD63hKEBCLDv0mesPLiB4v4dJ3')

filters = {"track": ["big data"]}
r = api.request('statuses/filter', filters).get_iterator()
saida = open("tweets_teste2.txt","w")

for item in r:
    itemString = json.dumps(item)
    saida.write(itemString + '\n')
