#!/usr/bin/env bash

#####=============================================== clean data
sudo rm -r /usr/local/zk_dir/version*
sudo rm -r /tmp/kafka-logs/*
ps aux | grep kafka | cut -c 120
rm -r /var/run/\$\{\{app_name\}\}.pid

#####=============================================== service start stop
zkServer.sh stop
zkServer.sh start

JMX_PORT=10211 kafka-server-start.sh ~/swap/liyu_workspace/kafka-properties/server-z1-b0-p1.properties &
JMX_PORT=10151 kafka-server-start.sh ~/kafka_exp/kafka-properties/server-z3-b5-p3.properties &
JMX_PORT=10161 kafka-server-start.sh ~/kafka_exp/kafka-properties/server-z3-b6-p3.properties &
JMX_PORT=10171 kafka-server-start.sh ~/kafka_exp/kafka-properties/server-z3-b7-p3.properties &

kafka-server-start.sh kafka_exp/kafka-properties/server-z3-b5-p3.properties &
kafka-server-start.sh kafka_exp/kafka-properties/server-z3-b6-p3.properties &
kafka-server-start.sh kafka_exp/kafka-properties/server-z3-b7-p3.properties &
kafka-server-stop.sh ~/kafka_exp/kafka-properties/server-z3-b2-p3.properties

#####=============================================== kafka manager
# cd kafka-manager-1.3.0.4
cd kafka-manager-1.3.0.4/bin
sudo ./kafka-manager -Dconfig.file=../conf/application.conf -Dhttp.port=9001 -java-home /usr/java/jdk1.8.0_60 &

#####=============================================== topic --list --describe --alter --delete
kafka-topics.sh --list --zookeeper 172.28.128.22:2181,172.28.128.23:2181,172.28.128.24:2181
kafka-topics.sh --describe --zookeeper 172.28.128.22:2181,172.28.128.23:2181,172.28.128.24:2181 --topic kafkatest
kafka-topics.sh --describe --zookeeper 172.28.128.22:2181,172.28.128.23:2181,172.28.128.24:2181 --topic cep_storm


kafka-topics.sh --create --zookeeper 172.28.128.22:2181,172.28.128.23:2181,172.28.128.24:2181 --partitions 1 --replication-factor 1 --topic kafkatest
kafka-topics.sh --create --zookeeper 172.28.128.22:2181,172.28.128.23:2181,172.28.128.24:2181 --partitions 1 --replication-factor 1 --topic cep_storm

kafka-topics.sh --create --zookeeper 172.28.128.22:2181,172.28.128.23:2181,172.28.128.24:2181 --partitions 1 --replication-factor 1 --topic perf11
kafka-topics.sh --create --zookeeper 172.28.128.22:2181,172.28.128.23:2181,172.28.128.24:2181 --partitions 1 --replication-factor 2 --topic perf12
kafka-topics.sh --create --zookeeper 172.28.128.22:2181,172.28.128.23:2181,172.28.128.24:2181 --partitions 1 --replication-factor 3 --topic perf13
kafka-topics.sh --create --zookeeper 172.28.128.22:2181,172.28.128.23:2181,172.28.128.24:2181 --partitions 3 --replication-factor 1 --topic perf31
kafka-topics.sh --create --zookeeper 172.28.128.22:2181,172.28.128.23:2181,172.28.128.24:2181 --partitions 3 --replication-factor 2 --topic perf32
kafka-topics.sh --create --zookeeper 172.28.128.22:2181,172.28.128.23:2181,172.28.128.24:2181 --partitions 3 --replication-factor 3 --topic perf33

#kafka-topics.sh --alter --zookeeper 172.28.128.22:2181,172.28.128.23:2181,172.28.128.24:2181 --topic cep_storm --config replication-factor=1,partitions=3
#kafka-topics.sh --delete --zookeeper 172.28.128.22:2181,172.28.128.23:2181,172.28.128.24:2181 --topic cep_storm
kafka-topics.sh --describe --zookeeper 172.28.128.22:2181,172.28.128.23:2181,172.28.128.24:2181 --topic cep_storm



#####=============================================== simple produce/consume
##### produce
$ JMX_PORT=10102 kafka-console-producer.sh --broker-list 172.28.128.22:9092,172.28.128.23:9092,172.28.128.24:9092 --topic kafkatest
$ kafka-console-producer.sh --broker-list 172.28.128.22:9092,172.28.128.23:9092,172.28.128.24:9092 --topic kafkatest < file

##### consume
$ kafka-console-consumer.sh --zookeeper localhost:2181 --topic kafkatest
$ kafka-console-consumer.sh --zookeeper localhost:2181 --topic kafkatest --from-beginning
$ kafka-console-consumer.sh --bootstrap-server localhost:9092 --topic kafkatest --new-consumer --consumer.config consumer.properties




#####=============================================== perftest
kafka-producer-perf-test.sh --broker-list 172.28.128.22:9092,172.28.128.23:9092,172.28.128.24:9092 --messages 50000000 -compression-codec 0 --topic perf11 >> perf50kk-pd-0307-18.csv
kafka-producer-perf-test.sh --broker-list 172.28.128.22:9092,172.28.128.23:9092,172.28.128.24:9092 --messages 50000000 -compression-codec 0 --topic perf12 >> perf50kk-pd-0307-18.csv
kafka-producer-perf-test.sh --broker-list 172.28.128.22:9092,172.28.128.23:9092,172.28.128.24:9092 --messages 50000000 -compression-codec 0 --topic perf13 >> perf50kk-pd-0307-18.csv
kafka-producer-perf-test.sh --broker-list 172.28.128.22:9092,172.28.128.23:9092,172.28.128.24:9092 --messages 50000000 -compression-codec 0 --topic perf31 >> perf50kk-pd-0307-18.csv
kafka-producer-perf-test.sh --broker-list 172.28.128.22:9092,172.28.128.23:9092,172.28.128.24:9092 --messages 50000000 -compression-codec 0 --topic perf32 >> perf50kk-pd-0307-18.csv
kafka-producer-perf-test.sh --broker-list 172.28.128.22:9092,172.28.128.23:9092,172.28.128.24:9092 --messages 50000000 -compression-codec 0 --topic perf33 >> perf50kk-pd-0307-18.csv

kafka-consumer-perf-test.sh --zookeeper 172.28.128.22:2181,172.28.128.23:2181,172.28.128.24:2181   --messages 50000000 --threads 1 --topic perf11 >> perf50kk-cs-0307-18.csv
kafka-consumer-perf-test.sh --zookeeper 172.28.128.22:2181,172.28.128.23:2181,172.28.128.24:2181   --messages 50000000 --threads 1 --topic perf12 >> perf50kk-cs-0307-18.csv
kafka-consumer-perf-test.sh --zookeeper 172.28.128.22:2181,172.28.128.23:2181,172.28.128.24:2181   --messages 50000000 --threads 1 --topic perf13 >> perf50kk-cs-0307-18.csv
kafka-consumer-perf-test.sh --zookeeper 172.28.128.22:2181,172.28.128.23:2181,172.28.128.24:2181   --messages 50000000 --threads 1 --topic perf31 >> perf50kk-cs-0307-18.csv
kafka-consumer-perf-test.sh --zookeeper 172.28.128.22:2181,172.28.128.23:2181,172.28.128.24:2181   --messages 50000000 --threads 1 --topic perf32 >> perf50kk-cs-0307-18.csv
kafka-consumer-perf-test.sh --zookeeper 172.28.128.22:2181,172.28.128.23:2181,172.28.128.24:2181   --messages 50000000 --threads 1 --topic perf33 >> perf50kk-cs-0307-18.csv


kafka-producer-perf-test.sh --broker-list 172.28.128.22:9092,172.28.128.23:9092,172.28.128.24:9092 --messages 100000 --threads 1 --message-size 200 -compression-codec 0 --topic kafkatest
kafka-producer-perf-test.sh --broker-list 172.28.128.22:9092,172.28.128.23:9092,172.28.128.24:9092 --messages 500000 --threads 8 --message-size 100 --batch-size 100 --compression-codec 0 --topic perf11
> kafka_exp/kafka_test_case/perf11-pd-5ww-012101.csv
kafka-consumer-perf-test.sh --zookeeper 172.28.128.22:2181,172.28.128.23:2181,172.28.128.24:2181 --messages 100000 --threads 1 --topic ktest
> kafka_exp/kafka_test_case/perf11-cs-5ww-012101.csv


##### produce sample result
#         開始|      結束|     訊息size|                總size| 每秒?MB|                 總筆數|     每秒?筆
#  start.time| end.time| message.size| total.data.sent.in.MB| MB.sec| total.data.sent.in.nMsg|   nMsg.sec
#    02:10:30| 02:19:20|          100|               4768.37| 8.9941|                50000000| 94309.9061
#
##### consume
#         開始|      結束|    訊息size|                總size|  每秒?MB|                總筆數|       每秒?筆
#  start.time| end.time| fetch.size|   data.consumed.in.MB|   MB.sec| data.consumed.in.nMsg|     nMsg.sec
#    02:22:22| 02:22:29|    1048576|              277.9675| 137.8123|               2914700| 1445066.9311







#============================================== cook test =============================================================#

####    4.2  Consumer offset checker             kafka.tools.ConsumerOffsetChecker
kafka-consumer-offset-checker.sh --broker-info --group test-consumer-group3 --topic cep_storm --zookeeper localhost:2181
kafka-run-class.sh kafka.tools.ConsumerOffsetChecker --broker-info --group test-consumer-group --zookeeper 172.28.128.22:2181,172.28.128.23:2181,172.28.128.24:2181
# Group           Topic                          Pid Offset          logSize         Lag             Owner
# test-consumer-group kafkatest                      0   66668           31093322        31026654        none
# test-consumer-group kafkatest                      1   2599805         28656474        26056669        none
# BROKER INFO
# 5 -> BT2016Realtime01:9092
# 0 -> BT2016Realtime03:9092#

####    4.3  Understanding dump log segments     kafka.tools.DumpLogSegments
kafka-run-class.sh kafka.tools.DumpLogSegments --deep-iteration -files /tmp/kafka-logs/cep_storm-1/00000000000000000000.log | head
# Starting offset: 0
# offset: 0 position: 0 isvalid: true payloadsize: 301 magic: 0 compresscodec: NoCompressionCodec crc: 778931605 keysize: 3
# offset: 1 position: 330 isvalid: true payloadsize: 330 magic: 0 compresscodec: NoCompressionCodec crc: 1631761393 keysize: 3
# offset: 2 position: 689 isvalid: true payloadsize: 330 magic: 0 compresscodec: NoCompressionCodec crc: 2307025110 keysize: 3
# offset: 3 position: 1048 isvalid: true payloadsize: 343 magic: 0 compresscodec: NoCompressionCodec crc: 2040659066 keysize: 3
# offset: 4 position: 1420 isvalid: true payloadsize: 330 magic: 0 compresscodec: NoCompressionCodec crc: 3057583804 keysize: 3

####    4.4  Exporting the ZooKeeper offsets     kafka.tools.ExportZkOffset
kafka-run-class.sh kafka.tools.ExportZkOffsets --group test-consumer-group --zkconnect 172.28.128.22:2181,172.28.128.23:2181,172.28.128.24:2181  --output-file ~/kafka_exp/kafka-exception/out.txt
# head  ~/kafka_exp/kafka-exception/out.txt
# /consumers/test-consumer-group/offsets/kafkatest/0:33334
# /consumers/test-consumer-group/offsets/kafkatest/1:287048
# /consumers/test-consumer-group/offsets/kafkatest/2:33332

####    4.5  Importing the ZooKeeper offsets     kafka.tools.ImportZkOffsets
kafka-run-class.sh kafka.tools.ImportZkOffsets --zkconnect 172.28.128.22:2181,172.28.128.23:2181,172.28.128.24:2181  --input-file ~/kafka_exp/kafka-exception/out.txt

####    4.6  Using GetOffsetShell                kafka.tools.GetOffsetShell
kafka-run-class.sh kafka.tools.GetOffsetShell --time -1 --broker-list localhost:9092 --topic kafkatest
# kafkatest:0:31093322
# kafkatest:1:28656474
kafka-run-class.sh kafka.tools.GetOffsetShell --time -2 --broker-list localhost:9092 --topic kafkatest
# kafkatest:0:0
# kafkatest:1:0

####    4.7  Using the JMX tool                  kafka.tools.JmxTool

####    4.8  Using the Kafka migration tool      kafka.tools.KafkaMigrationTool
####    4.9  The MirrorMaker tool                kafka.tools.MirrorMaker
kafka-run-class.sh kafka.tools.MirrorMaker --consumer.config kafka_exp/kafka-properties/consumer-z3.properties --producer.config kafka_exp/kafka-properties/producer-z3.properties --whitelist kafkatest2
####    4.10 Replay Log Producer                 kafka.tools.ReplayLogProducer
kafka-run-class.sh kafka.tools.ReplayLogProducer --sync --broker-list localhost:9092 --inputtopic kafkatest --outputtopic kafkatest2 --zookeeper localhost:2181
####    4.11 Simple Consumer Shell               kafka.tools.SimpleConsumerShell
kafka-run-class.sh kafka.tools.SimpleConsumerShell --max-messages 50 --offset -2 --partition 0 --print-offsets --topic kafkatest --broker-list 172.28.128.22:9092,172.28.128.23:9092,172.28.128.24:9092
# next offset = 1
# next offset = 2
# next offset = 3
# ...
# next offset = 50

####    4.12 State Change Log Merger             kafka.tools.StateChangeLogMerger
####    4.13 Updating offsets in Zookeeper       kafka.tools.UpdateOffsetsInZK
kafka-run-class.sh kafka.tools.UpdateOffsetsInZK earliest kafka_exp/kafka-properties/consumer-z3.properties kafkatest
# updating partition 0 with new offset: 0
# updated the offset for 1 partitions

####    4.14 Verifying consumer rebalance        kafka.tools.VerifyConsumerRebalance
kafka-run-class.sh kafka.tools.VerifyConsumerRebalance --zookeeper.connect localhost:2181 --group test-consumer-group


####    6.2  Adding and removing topics              > bin/kafka-topics.sh --create
####    6.3  Modifying topics                        > bin/kafka-topics.sh --alter
####    6.4  Implementing a graceful shutdown        > bin/kafka-server-stop.sh
####    6.5  Balancing leadership                    > bin/kafka-preferred-replica-election.sh
kafka-preferred-replica-election.sh --zookeeper localhost:2181
# Successfully started preferred replica election for partitions Set([__consumer_offsets,32], [__consumer_offsets,16], [kafkatest,0],

kafka-reassign-partitions.sh --zookeeper localhost:2181 --topics-to-move-json kafka_exp/kafka-properties/reassign/topics-to-move.json --broker-list "777" --generate
# Current partition replica assignment
# {"version":1,"partitions":[{"topic":"kafkatest","partition":0,"replicas":[5]}]}

# Proposed partition reassignment configuration
# {"version":1,"partitions":[{"topic":"kafkatest","partition":0,"replicas":[777]}]}

kafka-reassign-partitions.sh --zookeeper localhost:2181 --reassignment-json-file kafka_exp/kafka-properties/reassign/custom-reassignment.json --execute
# Current partition replica assignment
# {"version":1,"partitions":[{"topic":"kafkatest","partition":0,"replicas":[5]}]}
#
# Save this to use as the --reassignment-json-file option during rollback
# Successfully started reassignment of partitions {"version":1,"partitions":[{"topic":"kafkatest","partition":0,"replicas":[777]}]}

kafka-reassign-partitions.sh --zookeeper localhost:2181 --reassignment-json-file kafka_exp/kafka-properties/reassign/custom-reassignment.json --verify
# Status of partition reassignment:
# Reassignment of partition [kafkatest,0] completed successfully
kafka-topics.sh --describe --zookeeper 172.28.128.22:2181,172.28.128.23:2181,172.28.128.24:2181 --topic kafkatest
#Topic:kafkatest PartitionCount:1        ReplicationFactor:1     Configs:
#        Topic: kafkatest        Partition: 0    Leader: 777     Replicas: 777   Isr: 777


####    6.7  Expanding clusters                      > bin/kafka-reassign-partitions.sh
####    6.8  Increasing the replication factor       > bin/kafka-reassign-partitions.sh
####    6.10 Decommissioning brokers                 > bin/kafka-reassign-partitions.sh
####    6.6  Mirroring data between Kafka clusters   > bin/kafka-run-class.sh kafka.tools.MirrorMaker
####    6.9  Checking the consumer position          > bin/kafka-run-class.sh kafka.tools.ConsumerOffsetChecker



#============================================= kafka manager ===========================================================#
$ cd kafka-manager-1.3.0.4/bin
$ sudo ./kafka-manager -Dconfig.file=../conf/application-z3.conf -Dhttp.port=9009 &
-java-home /usr/lib/java/jdk1.8.0_66/


#=============================================== other test ===========================================================#

$ kafka-run-class.sh kafka.tools.ReplayLogProducer --sync --broker-list 172.28.128.22:9092,172.28.128.23:9092,172.28.128.24:9092 --inputtopic kafk       atest --outputtopic ktest --zookeeper 172.28.128.22:2181,172.28.128.23:2181,172.28.128.24:2181
[2016-01-21 06:46:38,844] ERROR consumer thread timing out (kafka.tools.ReplayLogProducer$ZKConsumerThread)
kafka.consumer.ConsumerTimeoutException
        at kafka.consumer.ConsumerIterator.makeNext(ConsumerIterator.scala:69)
        at kafka.consumer.ConsumerIterator.makeNext(ConsumerIterator.scala:33)
        at kafka.utils.IteratorTemplate.maybeComputeNext(IteratorTemplate.scala:66)
        at kafka.utils.IteratorTemplate.hasNext(IteratorTemplate.scala:58)
        at scala.collection.Iterator$class.foreach(Iterator.scala:750)
        at kafka.utils.IteratorTemplate.foreach(IteratorTemplate.scala:32)
        at scala.collection.IterableLike$class.foreach(IterableLike.scala:72)
        at kafka.consumer.KafkaStream.foreach(KafkaStream.scala:25)
        at kafka.tools.ReplayLogProducer$ZKConsumerThread.run(ReplayLogProducer.scala:140)

