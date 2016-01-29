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



#---------------------------------------------------------------------------------

# Consumer

from kafka import KafkaConsumer

# To consume latest messages and auto-commit offsets
consumer = KafkaConsumer('my-topic',
                         group_id='my-group',
                         bootstrap_servers=['localhost:9092'])
for message in consumer:
    # message value and key are raw bytes -- decode if necessary!
    # e.g., for unicode: `message.value.decode('utf-8')`
    print ("%s:%d:%d: key=%s value=%s" % (message.topic, message.partition,
                                          message.offset, message.key,
                                          message.value))

# consume earliest available messages, dont commit offsets
KafkaConsumer(auto_offset_reset='earliest', enable_auto_commit=False)

# consume json messages
KafkaConsumer(value_deserializer=lambda m: json.loads(m.decode('ascii')))

# consume msgpack
KafkaConsumer(value_deserializer=msgpack.unpackb)

# StopIteration if no message after 1sec
KafkaConsumer(consumer_timeout_ms=1000)

# Subscribe to a regex topic pattern
consumer = KafkaConsumer()
consumer.subscribe(pattern='^awesome.*')

# Use multiple consumers in parallel w/ 0.9 kafka brokers
# typically you would run each on a different server / process / CPU
consumer1 = KafkaConsumer('my-topic',
                          group_id='my-group',
                          bootstrap_servers='my.server.com')
consumer2 = KafkaConsumer('my-topic',
                          group_id='my-group',
                          bootstrap_servers='my.server.com')