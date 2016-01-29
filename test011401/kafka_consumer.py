# coding=utf-8

# python kafka_consumer.py
# --zookeeper
# --messages
# --threads
# --topic

from pykafka import KafkaClient

client = KafkaClient(hosts="127.0.0.1:9092")
# print("%s" % client.topics)
topic = client.topics['kafkatest']


consumer1 = topic.get_simple_consumer(
	# topic, cluster,
		consumer_group=None,
		partitions=None,
		fetch_message_max_bytes=1048576,
		num_consumer_fetchers=1,
		auto_commit_enable=False,
		auto_commit_interval_ms=60000,
		queued_max_messages=2000,
		fetch_min_bytes=1,
		fetch_wait_max_ms=100,
		offsets_channel_backoff_ms=1000,
		offsets_commit_max_retries=5,
		auto_offset_reset=-2,
		consumer_timeout_ms=-1,
		auto_start=True,
		reset_offset_on_start=False
)

consumer1 = topic.get_simple_consumer()
for message in consumer:
	if message is not None:
		print message.offset, message.value


consumer = topic.get_balanced_consumer(
	topic, cluster,
		consumer_group=,
		fetch_message_max_bytes=1048576,
		num_consumer_fetchers=1,
		auto_commit_enable=False,
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
		zookeeper_connect='127.0.0.1:2181',
		zookeeper=None,
		auto_start=True,
		reset_offset_on_start=False,
		post_rebalance_callback=None,
		use_rdkafka=False
)

# kafka-consumer-perf-test.sh
# --zookeeper 172.28.128.22:2181,172.28.128.23:2181,172.28.128.24:2181
# --messages 100000
# --threads 1
# --topic kafka
#
# produce
#         開始|      結束|     訊息size|                總size| 每秒?MB|                 總筆數|     每秒?筆
#  start.time| end.time| message.size| total.data.sent.in.MB| MB.sec| total.data.sent.in.nMsg|   nMsg.sec
#    02:10:30| 02:19:20|          100|               4768.37| 8.9941|                50000000| 94309.9061
#
# consume
#         開始|      結束|    訊息size|                總size|  每秒?MB|                總筆數|       每秒?筆
#  start.time| end.time| fetch.size|   data.consumed.in.MB|   MB.sec| data.consumed.in.nMsg|     nMsg.sec
#    02:22:22| 02:22:29|    1048576|              277.9675| 137.8123|               2914700| 1445066.9311

