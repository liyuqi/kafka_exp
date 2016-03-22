# -*- coding: utf-8 -*-

# python kafka_producer.py
# --broker-list
# --messages
# --threads
# --message-size
# --batch-size
# --ompression --topic

import sys, getopt
import time
import logging
from pykafka import KafkaClient
from datetime import date,datetime

logger = logging.getLogger('pykafka.cluster')
logger.setLevel(logging.DEBUG)


client = KafkaClient(hosts="172.28.128.22:9092,172.28.128.23:9092,172.28.128.24:9092" )
# client = KafkaClient(hosts="172.28.128.218:9092" )

print(client.topics)
topic = client.topics['perf11']

# create logger


f = file('/home/vagrant/CGW11_pgw_processed_01_20151105020743.cdr.gz.csv')
# t0 = time.time()
'''同步producer
t0 = time.time()
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
    # linger_ms=0.001,
    # block_on_queue_full=True,
    # sync=True,
    delivery_reports=True
) as producer:
    count=0
    while True:
        line = f.readline()
        if len(line) == 0:  # adjust this or bring lots of RAM ;)
            t2 = time.time()
            # print 'produce time ,nMsg.sec'
            print 'duration.sec, nMsg ,nMsg.sec'
            print '{}, {}'.format((t2-t0),count,count/(t2-t0))
            break
        if count%10000 == 0:
            print "count: " + str(count)
        count+=1
        producer.produce(line, partition_key='{}'.format(count))
    # t1 = time.time()
    # print 'duration.sec'
    # print '{}'.format((t1-t0))
    f.close()
'''
'''非同步producer'''

t0 = time.time()
count = 0
with topic.get_producer(
    # cluster,
    # topic,
    # partitioner=<function random_partitioner>,
    # compression=0,
    # max_retries=3,
    # retry_backoff_ms=100,
    # required_acks=1,
    # ack_timeout_ms=10000,
    # max_queued_messages=100000,
    # min_queued_messages=70000,
    # linger_ms=5000,
    # block_on_queue_full=True,
    sync=False,
    delivery_reports=False
) as producer:
    # exception_count = 0
    while True:
        line = f.readline()
        if len(line) == 0:  # adjust this or bring lots of RAM ;)
            t2 = time.time()
            # print 'produce time ,nMsg.sec'
            print 'nMsg, duration.sec, nMsg.sec'
            # print '{}, {}, {}'.format(count,(t2-t0),count/(t2-t0))
            print("{}, {:.2f}, {:.2f}".format(count,(t2-t0),count/(t2-t0)))
            break
        # if count%10000 == 0:
        #     print "count: " + str(count)
        count+=1
        producer.produce(line, partition_key='{}'.format(count))
    # t1 = time.time()
    # print 'duration.sec'
    # print '{}'.format((t1-t0))
    f.close()

t1 = time.time()

'''
with topic.get_producer(delivery_reports=True) as producer:
    # for file in target dir
    # produce message averagely to two topic
    message_cursor = 0
    for file_order, filename in enumerate(files):
        source_file = original_dir + filename
        # produce messages
        with open(source_file, "r") as f:
            for line in f:
                message_cursor += 1
                producer.produce('message:{0}'.format(line.strip()), partition_key='{}'.format(message_cursor))

        print("file: {0} , produce to kafka topic: cep_storm done.".format(filename))
        print("current message #: {0}".format(message_cursor))

t1 = time.time()
'''
print 'nMsg, duration.sec, nMsg.sec'
print("{}, {:.2f}, {:.2f}".format(count,(t1-t0),count/(t1-t0)))

# print 'duration.sec'
# print '{}'.format((t1-t0))
# print datetime.now().strftime("%Y%m%d %H:%M:%S.%f")

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

'''
Exception in thread Thread-6 (most likely raised during interpreter shutdown):Exception in thread Thread-4 (most likely raised during interpreter shutdown):
Traceback (most recent call last):
  File "/usr/lib/python2.7/threading.py", line 810, in __bootstrap_inner
  File "/usr/lib/python2.7/threading.py", line 763, in run
  File "/usr/local/lib/python2.7/dist-packages/pykafka/handlers.py", line 150, in worker

 Exception in thread Thread-8 (most likely raised during interpreter shutdown):Exception in thread Thread-3 (most likely raised during interpreter shutdown):Traceback (most recent call last):
  File "/usr/lib/python2.7/Queue.py", line 174, in get  File "/usr/lib/python2.7/threading.py", line 810, in __bootstrap_inner
 Exception in thread Thread-2 (most likely raised during interpreter shutdown):
Traceback (most recent call last):
Exception in thread Thread-7 (most likely raised during interpreter shutdown):  File "/usr/lib/python2.7/threading.py", line 810, in __bootstrap_inner



  File "/usr/lib/python2.7/threading.py", line 763, in run
  File "/usr/lib/python2.7/threading.py", line 763, in run  File "/usr/local/lib/python2.7/dist-packages/pykafka/handlers.py", line 150, in worker

<type 'exceptions.TypeError'>: 'NoneType' object is not callable  File "/usr/local/lib/python2.7/dist-packages/pykafka/producer.py", line 436, in queue_reader
  File "/usr/local/lib/python2.7/dist-packages/pykafka/producer.py", line 490, in flush
  File "/usr/lib/python2.7/threading.py", line 167, in acquire

Traceback (most recent call last):
<type 'exceptions.TypeError'>: 'NoneType' object is not callablevagrant@BT2016Realtime03:~/kafka_exp/test011401/test0201$ python pro-file1.py
No handlers could be found for logger "pykafka.cluster"
{'perf11': None, 'perf31': None, 'perf71': None, 'perf51': None, 'pyperf11': None, 'perf91': None}
'''