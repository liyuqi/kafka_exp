# Apache Kafka Cookbook, Saurabh Minni, 2015-12
-----

Table of Contents


### 4: MANAGING KAFKA
####    4.1  Introduction
####    4.2 * Consumer offset checker             kafka.tools.ConsumerOffsetChecker 
####    4.3  Understanding dump log segments     kafka.tools.DumpLogSegments
####    4.4  Exporting the ZooKeeper offsets     kafka.tools.ExportZkOffsets
####    4.5  Importing the ZooKeeper offsets     kafka.tools.ImportZkOffsets 
####    4.6  Using GetOffsetShell                kafka.tools.GetOffsetShell
####    4.7  Using the JMX tool                  kafka.tools.JmxTool
####    4.8  Using the Kafka migration tool      kafka.tools.KafkaMigrationTool
####    4.9 * The MirrorMaker tool                kafka.tools.MirrorMaker
####    4.10 Replay Log Producer                 kafka.tools.ReplayLogProducer
####    4.11 Simple Consumer Shell               kafka.tools.SimpleConsumerShell
####    4.12 State Change Log Merger             kafka.tools.StateChangeLogMerger
####    4.13 Updating offsets in Zookeeper       kafka.tools.UpdateOffsetsInZK
####    4.14 Verifying consumer rebalance        kafka.tools.VerifyConsumerRebalance


### 4: MANAGING KAFKA
####    4.1 Introduction
####    4.2 kafka.tools.ConsumerOffsetChecker 檢查offset

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



####    4.3 kafka.tools.DumpLogSegments 抓取log segment

```bash
$ kafka-run-class.sh kafka.tools.DumpLogSegments --deep-iteration -files /tmp/kafka-logs/cep_storm-1/00000000000000000000.log | head
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

####    4.4 kafka.tools.ExportZkOffsets 匯出 zk offset

參數

--zkconnect
--group
--help
--output

####    4.5 kafka.tools.ImportZkOffsets 匯入 zk offset
####    4.6 kafka.tools.GetOffsetShell
####    4.7 kafka.tools.JmxTool

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



####    4.8 kafka.tools.KafkaMigrationTool 版本升級
####    4.9 kafka.tools.MirrorMaker 鏡像 topic

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

####    4.10 kafka.tools.ReplayLogProduce 重作 log pd

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


####    4.11 kafka.tools.SimpleConsumerShel 簡易 cs
####    4.12 kafka.tools.StateChangeLogMerger 合併 log 狀態

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

Option                                 | Description
------                                 | -----------
--end-time <end timestamp in the       | The latest timestamp of state change
  format java.text.                    |   log entries to be merged (default:
  SimpleDateFormat@f17a63e7>           |   9999-12-31 23:59:59,999)
--logs <file1,file2,...>               | Comma separated list of state change
                                       |   logs or a regex for the log file
                                       |   names
--logs-regex <for example: /tmp/state- | Regex to match the state change log
  change.log*>                         |   files to be merged
--partitions <0,1,2,...>               | Comma separated list of partition ids
                                       |   whose state change logs should be
                                       |   merged
--start-time <start timestamp in the   | The earliest timestamp of state change
  format java.text.                    |   log entries to be merged (default:
  SimpleDateFormat@f17a63e7>           |   0000-00-00 00:00:00,000)
--topic <topic>                        | The topic whose state change logs
                                       |   should be merged



####    4.13 kafka.tools.UpdateOffsetsInZK 更新 zk offset

```bash

```

####    4.14 kafka.tools.VerifyConsumerRebalance 驗證 cs 平衡

### 5: INTEGRATING KAFKA WITH JAVA
####    5.1 Introduction
####    5.2 Writing a simple producer
####    5.3 Writing a simple consumer
####    5.4 Writing a high-level consumer
####    5.5 *    Writing a producer with message partitioning
####    5.6 Multithreaded consumers in Kafka


-----