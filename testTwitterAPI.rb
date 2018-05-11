#https://github.com/sferik/twitter
require_relative 'lib/twitterClient'

client = TwitterClient.new

keyword='#Infinitywar'

num_of_tweet = client.count(keyword)
