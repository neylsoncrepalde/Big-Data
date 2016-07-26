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

filters = {"track": ["keyword"]} #replace with the keyword that you want
r = api.request('statuses/filter', filters).get_iterator()
out = open("collected_tweets.txt","w")

for item in r:
    itemString = json.dumps(item)
    out.write(itemString + '\n')
