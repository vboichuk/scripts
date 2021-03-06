# -*- coding: UTF-8 -*-

import client
from datetime import datetime, timedelta
import re

from feedly_config import token

#ключевые слова для неинтересных новостей
bad_re  = re.compile(u'Deluge|redis|DotNext|haskell|Ruby|smarttv|Fedora|PHP|Oracle|SOAP|Go|node.js|yii|web-разработк|веб-разработк|веб-технол|Azure|css|поблагодарил|прокомментировал', re.IGNORECASE)

#ключевые слова для "хороших" новостей
good_re = re.compile(u'iOS|Android|Blender|GameDev|xcode|objective|appcode|cocos2d-x', re.IGNORECASE)

# создание объекта
feedly = client.FeedlyClient(token=token, sandbox=False)

'''
# получение списка каналов
user_subscriptions = feedly.get_user_subscriptions(token)
# проверка на успех
if (type(user_subscriptions) is dict) and (user_subscriptions.get('errorMessage') != None):
	print (user_subscriptions.get('errorMessage'))
	exit(1)
print (user_subscriptions)
'''

# dt = datetime.date(2014,1,1)
dt = datetime.now() - timedelta(days=14)
unixtime = (dt - datetime(1970,1,1)).total_seconds()

# список для хранения айдишников неинтересных записей
uninteresting_ids = []

# <tmp>
# список каналов для проверки
# elem = {'id': "feed/http://habrahabr.ru/rss/best/" }
user_subscriptions = [
	{'id': "feed/https://dev.by/rss" }
	#,{'id': "feed/http://lenta.ru/rss/news/russia/" }
	
]
# </tmp>

# цикл по каналам
for subscription in user_subscriptions:
	
	# идентификатор канала
	streamId = subscription['id']
	#print (streamId)
	
	# получение списка записей канала
	content = feedly.get_feed_content(token, streamId, True, None)
	items = content.get('items', [])
	print(streamId, " => (", len(items), ")")
	
	for item in items:
		published = item.get('published');
		if (published < unixtime):
			print ("old!   " + item.get('title'))
		else:
			print (item.get('title'))
			print (published)

		# uninteresting_ids.append(item.get('id'))
		#description = item.get('summary', {}).get('content')

print("removed ", len(uninteresting_ids), " items")

if (len(uninteresting_ids) > 0):
	feedly.mark_article_read(token, uninteresting_ids)