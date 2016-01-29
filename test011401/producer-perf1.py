# -*- coding: utf-8 -*-

# python kafka_producer.py
# --broker-list
# --messages
# --threads
# --message-size
# --batch-size
# --ompression --topic

import time
import logging
from pykafka import KafkaClient
from datetime import date,datetime

client = KafkaClient(hosts="localhost:9092" )

print(client.topics)
topic = client.topics['kafkatest']


# t0 = time.time()
'''同步producer'''

# with topic.get_sync_producer(
	#cluster=,
	#partitioner=<function random_partitioner>,
	# compression=0,
	# max_retries=3,
	# retry_backoff_ms=100,
	# required_acks=0,
	#ack_timeout_ms=10000,
	# max_queued_messages=100000,
	# min_queued_messages=70000,
	# linger_ms=1000,
	# block_on_queue_full=True,
	# sync=False,
	#delivery_reports=False
# ) as producer:
# 	for i in range(100):
# 		producer.produce(str('85,0,40187421,466977200122266,2015-11-05 01:59:55,3587160516678701,886989305765,103.2.218.49,103.2.216.227'))
# 		# print("before #",i)
# 		# producer.produce(datetime.now().strftime("%Y%m%d %H:%M:%S")+' test message '+str(i))
# 		print("after #",i)

# t1 = time.time()
# client.ensure_topic_exists('kafkatest')


t0 = time.time()
'''非同步producer'''
with topic.get_producer(delivery_reports=True) as producer:
    count = 0
    while True:
        count += 1
        producer.produce(str(count)+"85,0,40187421,466977200122266,2015-11-05 01:59:55,3587160516678701,886989305765,103.2.218.49,103.2.216.227",
        	partition_key='{}'.format(count))
        if count % 10**5 == 0:  # adjust this or bring lots of RAM ;)
            while True:
                try:
                    msg, exc = producer.get_delivery_report(block=False)
                    if exc is not None:
                        print 'Failed  {} {}: {}'.format(
                            msg.partition_key, repr(exc))
                    else:
                        print 'Success {} {}'.format(
                            datetime.now().strftime("%Y%m%d %H:%M:%S"),msg.partition_key)
                except Queue.Empty:
                    break

t1 = time.time()
print (t1-t0)


# kafka-producer-perf-test.sh
# --broker-list 172.28.128.22:9092,172.28.128.23:9092,172.28.128.24:9092
# --messages 100000
# --threads 1
# --message-size 100
# --batch-size 200
# -compression-codec 0
# --topic ktest
#
# produce
#         開始|      結束|     訊息size|                總size| 每秒?MB|                 總筆數|     每秒?筆
#  start.time| end.time| message.size| total.data.sent.in.MB| MB.sec| total.data.sent.in.nMsg|   nMsg.sec
#    02:10:30| 02:19:20|          100|               4768.37| 8.9941|                50000000| 94309.9061
#
# consume
#        開始|     結束|    訊息size|                總size|  每秒?MB|                總筆數|       每秒?筆
#  start.time| end.time| fetch.size|   data.consumed.in.MB|   MB.sec| data.consumed.in.nMsg|     nMsg.sec
#    02:22:22| 02:22:29|    1048576|              277.9675| 137.8123|               2914700| 1445066.9311
#