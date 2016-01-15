from pykafka import KafkaClient
client = KafkaClient(hosts="127.0.0.1:9092")
print("%s" % client.topics)
topic = client.topics['kafkatest']


consumer = topic.get_simple_consumer(consumer_group="exp1",
                                       zookeeper_connect='127.0.0.1:2181',
                                       consumer_timeout_ms=500,
                                       auto_commit_enable=False)

consumer2 = topic.get_simple_consumer(consumer_group="exp1",
                                       zookeeper_connect='127.0.0.1:2181',
                                       consumer_timeout_ms=500,
                                       auto_commit_enable=False)
for message1 in consumer1:
	if message1 is not None:
		print message.offset, message.value

# consumer2 = topic.get_balanced_consumer(consumer_group="exp1",
#                                        zookeeper_connect='127.0.0.1:2181',
#                                        consumer_timeout_ms=500,
#                                        auto_commit_enable=False)
#
# cursor = 0
# for message in consumer2:
#     if message is not None:
#         print message.offset, message.value
#     else:
#         print "no more message"
#         break
#     cursor += 1
#     if cursor > 3:
#         break
#consumer.commit_offsets()