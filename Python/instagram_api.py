# -*- coding: utf-8 -*-
from instagram.client import InstagramAPI
import requests
import simplejson as json

path = 'https://api.instagram.com/v1/users/self/media/recent/?access_token='
access_token = "1704527633.ab86d7c.cffcf78286a943e687753060750be7f0"
url = path+access_token+'&count=10'

r = requests.get(url)
r.url
dados = r.json()

type ( dados['data'][0]['location'] )


'''
WORK IN PROGRESS

path = 'https://api.instagram.com/v1/users/self/media/recent/?access_token='

access_token = "1704527633.ab86d7c.cffcf78286a943e687753060750be7f0"
client_secret = "2faac4fb03274ae798ab9fed5f79b018"
api = InstagramAPI(access_token=access_token, client_secret=client_secret)
recent_media, next_ = api.user_recent_media(user_id="1704527633", count=10)
for media in recent_media:
   print (media.caption.text)
   
   InstagramAPI.user_recent_media

print(path+access_token)
url = path+access_token+'&count=10'

media = urlopen(url=url)
media

   
  
curl -F 'client_id=ab86d7c65e804af3836b762a58b262ce' \
    -F 'client_secret=2faac4fb03274ae798ab9fed5f79b018' \
    -F 'grant_type=authorization_code' \
    -F 'redirect_uri=https://elfsight.com/service/generate-instagram-access-token/' \
    -F 'code=CODE' \
    https://api.instagram.com/oauth/access_token
'''
