# -*- coding: utf-8 -*-
"""
Foursquare
"""

access_token= 'ONM43ZWUY5GIXMH3U3Y1AIMLBHMU1RT0PIVGYTV2WHXDZM3O'
client_id = '225V5Z3K2K2TXP2VAP0IVUHFHQYFRH35W4LSAMW5C4UEACAG'
client_secret = '3TXRXN0EC0LYBSK21V5SOVBZZST4E1LQ15WNZ2PDT5E2A103'

import foursquare

client = foursquare.Foursquare(access_token=access_token)
client.users()
client.users.friends()

ana = client.users('115482689')
ana['user']['homeCity']

amanda = client.users('88912001')
amanda['user']['friends']