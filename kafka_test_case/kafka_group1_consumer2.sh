
# kafka_test_case
# same group id 1
# diff consumer 1,2

# start kafka server
$ kafka-server-start.sh ../config/server.properties

# topic
$ kafka-topics.sh --create --zookeeper localhost:2181 -replication-factor 1 --partitions 1 --topic kafkatest

# view topic
$ kafka-topics.sh --describe --zookeeper localhost:2181 --topic kafkatest
$ kafka-topics.sh --list --zookeeper localhost:2181

# produce
$ kafka-console-producer.sh --broker-list localhost:9092 --topic kafkatest
$ kafka-console-producer.sh --broker-list localhost:9092 --topic kafkatest --producer.config client-ssl.properties
$ python kafka_exp/simple.py  # keep produce message : 20160115 02:54:43 test message 10

# consume
$ kafka-console-consumer.sh --zookeeper localhost:2181 --topic kafkatest
$ kafka-console-consumer.sh --zookeeper localhost:2181 --topic kafkatest

## default consumer
$ kafka-console-consumer.sh --zookeeper localhost:2181 --topic kafkatest --from-beginning
$ kafka-console-consumer.sh --zookeeper localhost:2181 --topic kafkatest --from-beginning
20160115 02:53:57 test message 1
20160115 02:54:02 test message 2
20160115 02:54:07 test message 3
...
20160115 03:10:25 test message 198
20160115 03:10:30 test message 199
20160115 03:10:35 test message 200

## g1c1 consume
$ kafka-console-consumer.sh --bootstrap-server localhost:9092 --topic kafkatest --new-consumer --consumer.config kafka_exp/kafka-properties/consumer-g1-c1.properties
[2016-01-15 03:09:49,959] WARN The configuration consumer.id = 1 was supplied but isn't a known config. (org.apache.kafka.clients.consumer.ConsumerConfig)
[2016-01-15 03:09:49,960] WARN The configuration zookeeper.connect = 127.0.0.1:2181 was supplied but isn't a known config. (org.apache.kafka.clients.consumer.ConsumerConfig)
[2016-01-15 03:09:49,960] WARN The configuration zookeeper.connection.timeout.ms = 6000 was supplied but isn't a known config. (org.apache.kafka.clients.consumer.ConsumerConfig)
20160115 03:09:50 test message 191
20160115 03:10:20 test message 197
20160115 03:10:25 test message 198
20160115 03:10:30 test message 199
20160115 03:10:35 test message 200
^CProcessed a total of 6 messages

## g1c2 consume
$ kafka-console-consumer.sh --bootstrap-server localhost:9092 --topic kafkatest --new-consumer --consumer.config kafka_exp/kafka-properties/consumer-g1-c2.properties
[2016-01-15 03:09:58,031] WARN The configuration consumer.id = 2 was supplied but isn't a known config. (org.apache.kafka.clients.consumer.ConsumerConfig)
[2016-01-15 03:09:58,032] WARN The configuration zookeeper.connect = 127.0.0.1:2181 was supplied but isn't a known config. (org.apache.kafka.clients.consumer.ConsumerConfig)
[2016-01-15 03:09:58,033] WARN The configuration zookeeper.connection.timeout.ms = 6000 was supplied but isn't a known config. (org.apache.kafka.clients.consumer.ConsumerConfig)
20160115 03:09:55 test message 192
20160115 03:10:00 test message 193
20160115 03:10:05 test message 194
20160115 03:10:10 test message 195
20160115 03:10:15 test message 196
^CProcessed a total of 6 messages

# check consumer offset
$ kafka-run-class.sh kafka.tools.ConsumerOffsetChecker --zkconnect localhost:2181 --group test-consumer-group

# monitor with kafka-manager
$ sudo ./kafka-manager \
-Dconfig.file=../conf/application.conf \
-Dhttp.port=9001 \
-java-home /usr/lib/java/jdk1.8.0_66/


# monitor with jconsole (JMX)
JMX_PORT=10101	bin/kafka-server-start.sh	config/server.properties
JMX_PORT=10102	bin/kafka-console-producer.sh	--broker-list	localhost:9092	--topic	kafkatest
JMX_PORT=10103	bin/kafka-console-producer.sh	--broker-list	localhost:9092	--topic	kafkatest