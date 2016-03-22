# -*- coding: utf-8 -*-

# python kafka_producer.py
# --broker-list
# --messages
# --threads
# --message-size
# --batch-size
# --ompression --topic

import sys
import time
import logging
from pykafka import KafkaClient
from datetime import date,datetime



client = KafkaClient(hosts="172.28.128.22:9092,172.28.128.23:9092,172.28.128.24:9092" )

print(client.topics)
topic = client.topics['kafkatest']

# create logger
logger = logging.getLogger('pykafka.cluster')
logger.setLevel(logging.DEBUG)

f = file(filename)

t0 = time.time()
'''同步producer'''
'''
print datetime.now().strftime("%Y%m%d %H:%M:%S.%f")
with topic.get_sync_producer(
    # cluster=,
    # partitioner=<function random_partitioner>,
    # compression=0,
    # max_retries=3,
    # retry_backoff_ms=100,
    required_acks=0,
    # ack_timeout_ms=10000,
    # max_queued_messages=100000,
    # min_queued_messages=70000,
    linger_ms=0.001,
    # block_on_queue_full=True,
    # sync=True,
    delivery_reports=True
) as producer:
    for i in range(nMsg):
        producer.produce(str('85,0,40187421,466977200122266,2015-11-05 01:59:55,3587160516678701,886989305765,103.2.218.49,103.2.216.227'))
        # print("before #",i)
        # producer.produce(datetime.now().strftime("%Y%m%d %H:%M:%S.%f")+' test message '+str(i))
        # sys.stdout.write('.')
        # if i%10**2==0:
        #     print i
        if i%10**3==0: #每1000筆印一次
            print datetime.now().strftime("%Y%m%d %H:%M:%S.%f"), i
'''

'''非同步producer'''

with topic.get_producer(delivery_reports=True) as producer:
    count = 0
    exception_count = 0
    while True:
        count += 1
        producer.produce(str(count)+"85,0,40187421,466977200122266,2015-11-05 01:59:55,3587160516678701,886989305765,103.2.218.49,103.2.216.227",
            partition_key='{}'.format(count))
        if count % 10**3 == 0:  # adjust this or bring lots of RAM ;)
            while True:
                try:
                    msg, exc = producer.get_delivery_report(block=False)
                    if exc is not None:
                        print 'Failed  {} {}: {}'.format(
                            msg.partition_key, repr(exc))
                    else:
                        pass
                        #print 'Success {} {}'.format(
                        #datetime.now().strftime("%Y%m%d %H:%M:%S"),msg.partition_key)
                except:# Queue.Empty:
                    # exception_count +=1
                    # print datetime.now().strftime("%Y%m%d %H:%M:%S.%f"),' e:', exception_count, ' c:', count
                    t1 = time.time()
                    print 'produce time:{}'.format((t1-t0))
                    break

# Segmentation fault (core dumped)

t1 = time.time()
print 'produce time:{}'.format((t1-t0))
print datetime.now().strftime("%Y%m%d %H:%M:%S.%f")

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
# {flush.messages -> 9223372036854775807,
# segment.bytes -> 1073741824,
# preallocate -> false,
# cleanup.policy -> delete,
# delete.retention.ms -> 86400000,
# segment.ms -> 604800000,
# min.insync.replicas -> 1,
# file.delete.delay.ms -> 60000,
# retention.ms -> 604800000,
# max.message.bytes -> 1000012,
# index.interval.bytes -> 4096,
# segment.index.bytes -> 10485760,
# retention.bytes -> -1,
# segment.jitter.ms -> 0,
# min.cleanable.dirty.ratio -> 0.5,
# compression.type -> producer,
# unclean.leader.election.enable -> true,
# flush.ms -> 9223372036854775807}