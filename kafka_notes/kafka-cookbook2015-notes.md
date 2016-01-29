# Apache Kafka Cookbook, Saurabh Minni, 2015-12
-----

Table of Contents

### 1: INITIATING KAFKA
####    Introduction
####    Setting up multiple Kafka brokers

編輯server.properties

```bash
> vi config/server-1.properties
broker.id=1
port=9092
log.dir=/tmp/kafka-logs-1
zookeeper=172.28.128.22:2181,172.28.128.23:2181,172.28.128.24:2181

> vi config/server-2.properties
broker.id=2
port=9092
log.dir=/tmp/kafka-logs-2
zookeeper=172.28.128.22:2181,172.28.128.23:2181,172.28.128.24:2181

> vi config/server-3.properties
broker.id=3
port=9092
log.dir=/tmp/kafka-logs-3
zookeeper=172.28.128.22:2181,172.28.128.23:2181,172.28.128.24:2181
```
啟動server

```> bin/kafka-server-start.sh	config/server-1.properties	&```

```> bin/kafka-server-start.sh	config/server-2.properties	&```
####    Creating topics

建立topic

```> bin/kafka-topics.sh --describe --zookeeper 172.28.128.22:2181,172.28.128.23:2181,172.28.128.24:2181 --topic kafkatest```

```> bin/kafka-topics.sh --describe --zookeeper 172.28.128.22:2181,172.28.128.23:2181,172.28.128.24:2181 --partition 1 --replication-factor 3 --topic kafkatest31```

列表topic

```bash
> bin/kafka-topics.sh --list --zookeeper 172.28.128.22:2181,172.28.128.23:2181,172.28.128.24:2181
kafkatest
kafkatest31
```
描述topic

```bash
> bin/kafka-topics.sh --describe --zookeeper 172.28.128.22:2181,172.28.128.23:2181,172.28.128.24:2181 --topic kafkatest
Topic:	kafkatest		Partition:	0		Leader:	0		Replicas:	0			Isr:	0
 
> bin/kafka-topics.sh --describe --zookeeper 172.28.128.22:2181,172.28.128.23:2181,172.28.128.24:2181 --topic kafkatest31
Topic:	kafkatest		Partition:	0		Leader:	2		Replicas:	2,0,1		Isr:	2,0,1
```

####    Sending some messages from the console

新增message (produce)

```bash
> bin/kafka-console-producer.sh --broker-list 172.28.128.22:9092,172.28.128.23:9092,172.28.128.24:9092 --topic kafkatest
First message
Second message
```

param   參數說明             |description        |sample
--- | --- | ---
--broker-list               |zookeeper servers  |hostname:port
--topic                     |topic 名稱          |kafkatest
--sync                      |指定傳送方式(同步)
--compression-codec         |壓縮方式            |none,default:gzip,snappy,lz4
--batch-size                |非sync時的傳送
--message-send-max-retries  |broker無回應時,重傳數
--retry-backoff-ms          |leader重選的初始時間

####    Consuming from the console

消費message (consume)

```bash
> bin/kafka-console-consumer.sh --zookeeper localhost:2181 --topic kafkatest --from-beginning
First message
Second message
```

param   參數說明p81          |description    |sample
--- | --- | ---
--fetch-size                |   訂閱byte量
--socket-buffer-size        |TCP接收byte量
--autocommit.interval.ms    |offset保留時間
--max-messages              |               |default:無限大
--skip-message-on-error     |               |default:直接skip

### 2: CONFIGURING BROKERS
####    Introduction
####    Configuring the basic settings
####    Configuring threads and performance
####    Configuring the log settings
####    Configuring the replica settings
####    Configuring the ZooKeeper settings
####    Configuring other miscellaneous parameters
編輯server.properties

```bash
> vi server.properties
############################# Server Basics #############################
# kafka-server-start.sh ../config/server.properties
broker.id=0
delete.topic.enable=true

############################# Replica setting #############################
#default.replication.factor=1 
#replica.lag.time.max.ms=10000 
#replica.lag.max.messages=4000 
#replica.fetch.max.bytes=1048576 
#replica.fetch.wait.max.ms=500 
#num.replica.fetchers=1 
#replica.high.watermark.checkpoint.interval.ms=5000 
#fetch.purgatory.purge.interval.requests=1000 
#producer.purgatory.purge.interval.requests=1000 
#replica.socket.timeout.ms=30000 
#replica.socket.receive.buffer.bytes=65536

############################# Socket Server Settings #############################
listeners=PLAINTEXT://:9092
port=9092
#host.name=localhost
#advertised.host.name=<hostname routable by clients>
#advertised.port=<port accessible by clients>
#message.max.bytes=1000000
num.network.threads=3
num.io.threads=8
num.partitions=3
#background.threads=10
#queued.max.requests=500 
socket.send.buffer.bytes=102400
socket.receive.buffer.bytes=102400
socket.request.max.bytes=104857600

############################# Log Basics #############################
log.dirs=/tmp/kafka-logs
num.recovery.threads.per.data.dir=1

############################# Log Flush Policy #############################
#log.index.interval.bytes=4096
#log.flush.interval.messages=10000
#log.flush.interval.ms=1000

############################# Log Retention Policy #############################
log.segment.bytes=1073741824
log.retention.hours=24
#log.retention.bytes=1073741824,-1
log.retention.check.interval.ms=300000

log.cleaner.enable=false
#log.cleaner.threads=1
#log.cleaner.backoff.ms=1
#log.cleanup.policy=delete,compact
#log.cleanup.interval.mins=10

############################# Zookeeper #############################
# server. e.g. "172.28.128.22:2181,172.28.128.23:2181,172.28.128.24:2181".
zookeeper.connect=172.28.128.22:2181,172.28.128.23:2181,172.28.128.24:2181
zookeeper.connection.timeout.ms=6000
#zookeeper.session.timeout.ms=6000 
#zookeeper.sync.time.ms=2000

############################# miscellaneous param #############################
#auto.create.topics.enable=true 
#controlled.shutdown.enable=true 
#controlled.shutdow#n.max.retries=3 
#controlled.shutdown.retry.backoff.ms=5000 
#auto.leader.rebalance.enable=true 
#leader.imbalance.per.broker.percentage=10
#leader.imbalance.check.interval.seconds=300 
#offset.metadata.max.bytes=4096 
#max.connections.per.ip=Int.MaxValue 
#connections.max.idle.ms=600000 
#unclean.leader.election.enable=true 

#offsets.topic.num.partitions=50 
#offsets.topic.retention.minutes=1440
#offsets.retention.check.interval.ms=600000
#offsets.topic.replication.factor=3 
#offsets.topic.segment.bytes=104857600 
#offsets.load.buffer.size=5242880
#offsets.commit.required.acks=-1 
#offsets.commit.timeout.ms=5000
```

### 3: CONFIGURING A PRODUCER AND CONSUMER
####    Introduction

benchmark ref [https://gist.github.com/jkreps/c7ddb4041ef62a900e6c]

####    Configuring the basic settings for producer
####    Configuring the thread and performance for producer

編輯producer.properties

```bash
> vi producer.properties
############################# Producer Basics #############################
metadata.broker.list=172.28.128.22:9092,172.28.128.23:9092,172.28.128.24:9092

#request.required.acks=0
#request.timeout.ms=10000

#partitioner.class=
producer.type=sync
compression.codec=none
serializer.class=kafka.serializer.DefaultEncoder
#compressed.topics=

############################# Async Producer #############################
#queue.buffering.max.ms=
#queue.buffering.max.messages=
#queue.enqueue.timeout.ms=
#batch.num.messages=
#send.buffer.bytes=102400

############################# Thread and Performance #############################
       # producer.type=sync 
       # serializer.class=kafka.serializer.DefaultEncoder 
#key.serializer.class=kafka.serializer.DefaultEncoder 
#partitioner.class=kafka.producer.DefaultPartitioner 
#message.send.max.retries=3 
#retry.backoff.ms=100
#topic.metadata.refresh.interval.ms=600000 
#client.id=my_client
```

####    Configuring the basic settings for consumer
####    Configuring the thread and performance for consumer
####    Configuring the log settings for consumer
####    Configuring the ZooKeeper settings for consumer
####    Other configurations for consumer

編輯producer.properties

```bash
> vi consumer.properties

############################# Consumer Basics #############################
zookeeper.connect=172.28.128.22:2181,172.28.128.23:2181,172.28.128.24:2181
#zookeeper.connection.timeout.ms=6000
#zookeeper.session.timeout.ms=6000 
#zookeeper.sync.time.ms=2000
group.id=1
consumer.id=1
#consumer.timeout.ms=5000

############################# Thread and Performance #############################
#socket.timeout.ms=30000
#socket.receive.buffer.bytes=65536 
#fetch.message.max.bytes=1048576 
#queued.max.message.chunks=2 
#fetch.min.bytes=1 
#fetch.wait.max.ms=100
#consumer.timeout.ms=-1

############################# Consumer Log Setting #############################
#auto.commit.enable=true 
#auto.commit.interval.ms=60000 
#rebalance.max.retries=4
#rebalance.backoff.ms=2000
#refresh.leader.backoff.ms=200 
#auto.offset.reset=largest 
#partition.assignment.strategy=range

############################# Consumer Offset Setting #############################
#offsets.storage=zookeeper 
#offsets.channel.backoff.ms=6000
#offsets.channel.socket.timeout.ms=6000 
#offsets.commit.max.retries=5
#dual.commit.enabled=true 
```

### 4: MANAGING KAFKA
####    Introduction
####    Consumer offset checker

```bash
$ kafka-run-class.sh kafka.tools.ConsumerOffsetChecker --broker-info --group cep_group_1 --topic cep_storm --zookeeper 172.28.128.22:2181,172.28.128.23:2181,172.28.128.24:2181
Group           Topic                          Pid Offset          logSize         Lag             Owner
cep_group_1     cep_storm                      0   0               0               0               none
cep_group_1     cep_storm                      1   0               1085587         1085587         none
cep_group_1     cep_storm                      2   0               0               0               none
BROKER INFO
5 -> BT2016Realtime01:9092
6 -> BT2016Realtime02:9092
0 -> BT2016Realtime03:9092
```

參數
--group
--zookeeper
--topic
--broker-info
--help

####    Understanding dump log segments

```bash
$ kafka-run-class.sh kafka.tools.DumpLogSegments --deep-iteration -fil /tmp/kafka-logs/cep_storm-1/00000000000000000000.log | head
Starting offset: 0
offset: 0 position: 0 isvalid: true payloadsize: 301 magic: 0 compresscodec: NoCompressionCodec crc: 778931605 keysize: 3
offset: 1 position: 330 isvalid: true payloadsize: 330 magic: 0 compresscodec: NoCompressionCodec crc: 1631761393 keysize: 3
offset: 2 position: 689 isvalid: true payloadsize: 330 magic: 0 compresscodec: NoCompressionCodec crc: 2307025110 keysize: 3
offset: 3 position: 1048 isvalid: true payloadsize: 343 magic: 0 compresscodec: NoCompressionCodec crc: 2040659066 keysize: 3
offset: 4 position: 1420 isvalid: true payloadsize: 330 magic: 0 compresscodec: NoCompressionCodec crc: 3057583804 keysize: 3
```

參數
--deep-iteration
--files
--max-message-size
--print-data-log
--verify-index-only

####    Exporting the ZooKeeper offsets

參數

--zkconnect
--group
--help
--output

####    Importing the ZooKeeper offsets
####    Using GetOffsetShell
####    Using the JMX tool

```bash
$ bin/kafka-run-class.sh kafka.tools.JmxTool --jmx-url service:jmx:rmi:///jndi/rmi://127.0.0.1:9999/jmxrmi
```

####    Using the Kafka migration tool
####    The MirrorMaker tool

```bash
$ bin/kafka-run-class.sh kafka.tools.MirrorMaker --consumer.config config/consumer.config --producer.config config/producer.config -whitelist mytesttopic
```

####    Replay Log Producer
####    Simple Consumer Shell
####    State Change Log Merger

```bash
$ bin/kafka-run-class.sh kafka.tools.StateChangeLogMerger --log-regex	/tmp/state-change.log* --partitions 0,1,2 --topic	statelog
```

參數
--end-time
--logs
--logs-regex
--partitions
--start-time
--topic

####    Updating offsets in Zookeeper

```bash

```

####    Verifying consumer rebalance

### 5: INTEGRATING KAFKA WITH JAVA
####    Introduction
####    Writing a simple producer
####    Writing a simple consumer
####    Writing a high-level consumer
####    *    Writing a producer with message partitioning
####    Multithreaded consumers in Kafka

### 6: OPERATING KAFKA
####    Introduction
####    *    Adding and removing topics
####    Modifying topics
####    *   Implementing a graceful shutdown
####    Balancing leadership
####    *   Mirroring data between Kafka clusters
####    Expanding clusters
####    Increasing the replication factor
####    Checking the consumer position
####    Decommissioning brokers

### 7: INTEGRATING KAFKA WITH THIRD-PARTY PLATFORMS
####    Introduction
####    Using Flume
####    Using Gobblin
####    Using Logstash
####    Configuring Kafka for real-time
####    Integrating Spark with Kafka
####    Integrating Storm with Kafka
####    Integrating Elasticsearch with Kafka
####    Integrating SolrCloud with Kafka
### 8: MONITORING KAFKA
####    Introduction
####    Monitoring server stats
####    Monitoring producer stats

-----