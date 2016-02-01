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
# consumer = topic.get_simple_consumer(consumer_group="exp1",consumer_timeout_ms=500)

'''balanced consumer'''
consumer = topic.get_balanced_consumer(
    fetch_message_max_bytes=1048576,
    num_consumer_fetchers=1,
    auto_commit_interval_ms=60000,
    queued_max_messages=2000,
    fetch_min_bytes=1,
    fetch_wait_max_ms=100,
    offsets_channel_backoff_ms=1000,
    offsets_commit_max_retries=5,
    auto_offset_reset=-2,
    consumer_timeout_ms=-1,
    rebalance_max_retries=5,
    rebalance_backoff_ms=2000,
    zookeeper_connection_timeout_ms=6000,
    # zookeeper=None,
    auto_start=True,
    reset_offset_on_start=False,
    post_rebalance_callback=None,
    use_rdkafka=False,

    consumer_group="g2",
    zookeeper_connect='localhost:2181',
    consumer_timeout_ms=500,
    auto_commit_enable=True
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
    if cursor%10000 == 0:
        print("consume #{0} .topic {} .pt {} .offset {} .key {} .value {}".format(cursor,message.offset, message.value))

    #if cursor >= 100000:
        # break
else:
    print("over")
end_timestamp = time.time()
print("spend {0} seconds consuming {1} messages".format(end_timestamp - start_timestamp, cursor))
# consumer.commit_offsets()  # 主動commit offset, auto_commit_enable=True的話就不用
