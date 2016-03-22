# Apache Kafka Cookbook, Saurabh Minni, 2015-12
-----

Table of Contents

### 1: INITIATING KAFKA
####    1.1 Introduction
####    1.2 Setting up multiple Kafka brokers

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
####    1.3 Creating topics

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

####    1.4 Sending some messages from the console

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

####    1.5 Consuming from the console

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
####    2.1 Introduction
####    2.2 Configuring the basic settings
####    2.3 Configuring threads and performance
####    2.4 Configuring the log settings
####    2.5 Configuring the replica settings
####    2.6 Configuring the ZooKeeper settings
####    2.7 Configuring other miscellaneous parameters
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
####    3.1 Introduction

benchmark ref [https://gist.github.com/jkreps/c7ddb4041ef62a900e6c]

####    3.2 Configuring the basic settings for producer
####    3.3 Configuring the thread and performance for producer

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

####    3.1 Configuring the basic settings for consumer
####    3.2 Configuring the thread and performance for consumer
####    3.3 Configuring the log settings for consumer
####    3.4 Configuring the ZooKeeper settings for consumer
####    3.5 Other configurations for consumer

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
####    4.1 Introduction
####    4.2 Consumer offset checker

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


```bash
$ kafka-run-class.sh kafka.tools.ConsumerOffsetChecker --zookeeper localhost:2181 --group test
Group           Topic                          Pid Offset          logSize         Lag             Owner
my-group        my-topic                       0   0               0               0               test_jkreps-mn-1394154511599-60744496-0
my-group        my-topic                       1   0               0               0               test_jkreps-mn-1394154521217-1a0be913-0
```

ConsumerOffsetChecker

Option                                 | Description
------                                 | -----------
--broker-info                          | Print broker info
--group                                | Consumer group.
--help                                 | Print this message.
--retry.backoff.ms <Integer>           | Retry back-off to use for failed offset queries. (default: 3000)
--socket.timeout.ms <Integer>          | Socket timeout to use when querying for offsets. (default: 6000)
--topic                                | Comma-separated list of consumer topics (all topics if absent).
--zookeeper                            | ZooKeeper connect string. (default:localhost:2181)


kafka-run-class.sh kafka.tools.GetOffsetShell


Option                                 | Description
------                                 | -----------
--broker-list <hostname:port,...,      | REQUIRED: The list of hostname and
  hostname:port>                       |   port of the server to connect to.
--max-wait-ms <Integer: ms>            | The max amount of time each fetch
                                       |   request waits. (default: 1000)
--offsets <Integer: count>             | number of offsets returned (default: 1)
--partitions <partition ids>           | comma separated list of partition ids.
                                       |   If not specified, it will find
                                       |   offsets for all partitions (default:
                                       |   )
--time <Long: timestamp/-1(latest)/-2  | timestamp of the offsets before that
  (earliest)>|
--topic <topic>                        | REQUIRED: The topic to get offset from.



####    4.3 Understanding dump log segments

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


Option                                 | Description
------                                 | -----------
--deep-iteration                       | if set, uses deep instead of shallow
                                       |   iteration
--files <file1, file2, ...>            | REQUIRED: The comma separated list of
                                       |   data and index log files to be dumped
--key-decoder-class                    | if set, used to deserialize the keys.
                                       |   This class should implement kafka.
                                       |   serializer.Decoder trait. Custom jar
                                       |   should be available in kafka/libs
                                       |   directory. (default: kafka.
                                       |   serializer.StringDecoder)
--max-message-size <Integer: size>     | Size of largest message. (default:
                                       |   5242880)
--print-data-log                       | if set, printing the messages content
                                       |   when dumping data logs
--value-decoder-class                  | if set, used to deserialize the
                                       |   messages. This class should
                                       |   implement kafka.serializer.Decoder
                                       |   trait. Custom jar should be
                                       |   available in kafka/libs directory.
                                       |   (default: kafka.serializer.
                                       |   StringDecoder)
--verify-index-only                    | if set, just verify the index log
                                       |   without printing its content

####    4.4 Exporting the ZooKeeper offsets

參數

--zkconnect
--group
--help
--output

####    4.5 Importing the ZooKeeper offsets
####    4.6 Using GetOffsetShell
####    4.7 Using the JMX tool

啟動jconsole

`> bin/kafka-run-class.sh	kafka.tools.JmxTool --jmx-url service:jmx:rmi:///jndi/rmi://127.0.0.1:9999/jmxrmi`

Option                                  |Description
------                                  |-----------
--attributes <name>                     |The whitelist of attributes to query.
                                        |  This is a comma-separated list. 
                                        |  If no attributes are specified all objects will be queried.
--date-format <format>                  |The date format to use for formatting the time field. See java.text.
                                        |  SimpleDateFormat for options.
--help                                  |Print usage information.
--jmx-url <service-url>                 |The url to connect to to poll JMX data. 
                                        |  See Oracle javadoc for
                                        |  JMXServiceURL for details. (default: service:jmx:rmi:///jndi/rmi://:9999/jmxrmi)
--object-name <name>                    |A JMX object name to use as a query.
                                        |  This can contain wild cards, and this option can be given multiple times to specify more than one query. 
                                        |  If no objects are specified all objects will be queried.
--reporting-interval <Integer: ms>      |Interval in MS with which to poll jmx stats. (default: 2000)



####    4.8 Using the Kafka migration tool
####    4.9 The MirrorMaker tool

```bash
$ bin/kafka-run-class.sh kafka.tools.MirrorMaker --consumer.config config/consumer.config --producer.config config/producer.config -whitelist mytesttopic
```

Option                                 | Description
------                                 | -----------
--blacklist <Java regex (String)>      | Blacklist of topics to mirror.
--consumer.config <config file>        | Consumer config to consume from a
                                       |   source cluster. You may specify
                                       |   multiple of these.
--help                                 | Print this message.
--new.producer                         | Use the new producer implementation.
--num.producers <Integer: Number of    | Number of producer instances (default:
  producers>                           |   1)
--num.streams <Integer: Number of      | Number of consumption streams.
  threads>                             |   (default: 1)
--producer.config <config file>        | Embedded producer config.
--queue.size <Integer: Queue size in   | Number of messages that are buffered
  terms of number of messages>         |   between the consumer and producer
                                       |   (default: 10000)
--whitelist <Java regex (String)>      | Whitelist of topics to mirror.

####    4.10 Replay Log Producer

`bin/kafka-run-class.sh kafka.tools.ReplayLogProducer`

Option                                 | Description
------                                 | -----------
--broker-list <hostname:port>          | REQUIRED: the broker list must be
                                       |   specified.
--inputtopic <input-topic>             | REQUIRED: The topic to consume from.
--messages <Integer: count>            | The number of messages to send.
                                       |   (default: -1)
--outputtopic <output-topic>           | REQUIRED: The topic to produce to
--property <producer properties>       | A mechanism to pass properties in the
                                       |   form key=value to the producer. This
                                       |   allows the user to override producer
                                       |   properties that are not exposed by
                                       |   the existing command line arguments
--reporting-interval <Integer: size>   | Interval at which to print progress
                                       |   info. (default: 5000)
--sync                                 | If set message send requests to the
                                       |   brokers are synchronously, one at a
                                       |   time as they arrive.
--threads <Integer: threads>           | Number of sending threads. (default: 1)
--zookeeper <zookeeper url>            | REQUIRED: The connection string for
                                       |   the zookeeper connection in the form
                                       |   host:port. Multiple URLS can be
                                       |   given to allow fail-over. (default:
                                       |   127.0.0.1:2181)


####    4.11 Simple Consumer Shell
####    4.12 State Change Log Merger

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

Option                                  Description
------                                  -----------
--end-time <end timestamp in the        The latest timestamp of state change
  format java.text.                       log entries to be merged (default:
  SimpleDateFormat@f17a63e7>              9999-12-31 23:59:59,999)
--logs <file1,file2,...>                Comma separated list of state change
                                          logs or a regex for the log file
                                          names
--logs-regex <for example: /tmp/state-  Regex to match the state change log
  change.log*>                            files to be merged
--partitions <0,1,2,...>                Comma separated list of partition ids
                                          whose state change logs should be
                                          merged
--start-time <start timestamp in the    The earliest timestamp of state change
  format java.text.                       log entries to be merged (default:
  SimpleDateFormat@f17a63e7>              0000-00-00 00:00:00,000)
--topic <topic>                         The topic whose state change logs
                                          should be merged



####    4.13 Updating offsets in Zookeeper

```bash

```

####    4.14 Verifying consumer rebalance

### 5: INTEGRATING KAFKA WITH JAVA
####    5.1 Introduction
####    5.2 Writing a simple producer
####    5.3 Writing a simple consumer
####    5.4 Writing a high-level consumer
####    5.5 *    Writing a producer with message partitioning
####    5.6 Multithreaded consumers in Kafka

### 6: OPERATING KAFKA
####    6.1 Introduction
####    6.2*    Adding and removing topics
####    6.3 Modifying topics
####    6.4 Implementing a graceful shutdown

`bin/kafka-server-stop.sh`

broker 參數
controlled.shutdown.enable=true

####    6.5 Balancing leadership

`bin/kafka-preferred-replica-election.sh`

####    6.6 Mirroring data between Kafka clusters

`bin/kafka-run-class.sh kafka.tools.MirrorMaker --consumer.config consumer.properties --producer.config producer.properties --whitelist testtopic`

####    6.7 Expanding clusters
####    6.8 Increasing the replication factor
####    6.9 Checking the consumer position



####    6.10 Decommissioning brokers

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
####    8.1 Introduction
####    8.2 Monitoring server stats
####    8.3 Monitoring producer stats

-----