# -*- coding: utf-8 -*-

from threading import Thread
import time
from pykafka import KafkaClient
import logging

# create logger
logger = logging.getLogger('pykafka.cluster')
logger.setLevel(logging.DEBUG)

client = KafkaClient(hosts='localhost:9092')  # 建立kafka連線client
print("%s" % client.topics)  # 列出有哪些topic
topic = client.topics['kafkatest']  # 取得指定的kafka_topic物件

'''simple consumer'''
# consumer = topic.get_simple_consumer(
# consumer_group="g001",
# consumer_timeout_ms=500,
# auto_offset_reset=OffsetType.LATEST
# )

'''balanced consumer'''
consumer = topic.get_balanced_consumer(
    # fetch_message_max_bytes=1048576,
    num_consumer_fetchers=9,
    # auto_commit_interval_ms=60000,
    # queued_max_messages=2000,
    # fetch_min_bytes=1,
    # fetch_wait_max_ms=100,
    # offsets_channel_backoff_ms=1000,
    # offsets_commit_max_retries=5,
    # auto_offset_reset=-2,
    # consumer_timeout_ms=-1,
    # rebalance_max_retries=5,
    # rebalance_backoff_ms=2000,
    # zookeeper_connection_timeout_ms=6000,
    # zookeeper=None,
    # auto_start=True,
    # reset_offset_on_start=False,
    # post_rebalance_callback=None,
    # use_rdkafka=False,
    consumer_group="g99",
    zookeeper_connect='localhost:2181',
    consumer_timeout_ms=500,
    auto_commit_enable=False
)  # 建立consumer

cursor = 0
start_timestamp = time.time()

for message in consumer:
    # message obj:
    # message.topic,
    # message.partition,
    # message.offset,
    # message.key,
    # message.value
    if message is not None:
        cursor += 1
        # print message.offset, message.value

    else:
        print "no more message"
        # break
    if cursor==1:
        print ".pt {}".format(message.partition)
    if cursor%10**3 == 0:
        print "consume #{0} .offset {1} ".format(
            cursor,
            message.offset,
            # message.value[0:8]
        )

    #if cursor >= 100000:
        # break
else:
    print("over")
end_timestamp = time.time()
print("spend {0} seconds consuming {1} messages".format(end_timestamp - start_timestamp, cursor))
# consumer.commit_offsets()  # 主動commit offset, auto_commit_enable=True的話就不用



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