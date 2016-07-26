
import simplejson as json

# Arquivo com Tweets
tweets_file = open('tweets_teste.txt', "r")

#le a linha do arquivo
tweet_json = tweets_file.readline()

#imprime a linha lida
print(tweet_json)
  
#remove espacos em branco
strippedJson = tweet_json.strip()
  
#converte uma string json em um objeto python
tweet = json.loads(strippedJson)
  
print(tweet['id']) # ID do tweet
print(tweet['created_at']) # data de postagem
print(tweet['text']) # texto do tweet
			  
print(tweet['user']['id']) # id do usuario que postou
print(tweet['user']['name']) # nome do usuario
print(tweet['user']['screen_name']) # nome da conta do usuario 




