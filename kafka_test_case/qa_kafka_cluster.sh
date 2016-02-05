#!/usr/bin/env bash

 sudo rm -r /usr/local/zk_dir/

zkServer.sh stop
zkServer.sh start


kafka-server-start.sh kafka_exp/kafka-properties/server-z3-b5-p3.properties &
kafka-server-start.sh kafka_exp/kafka-properties/server-z3-b6-p3.properties &
kafka-server-start.sh kafka_exp/kafka-properties/server-z3-b7-p3.properties &
kafka-server-stop.sh ~/kafka_exp/kafka-properties/server-z3-b2-p3.properties

#JMX=10151 kafka-server-start.sh kafka_exp/kafka-properties/server-z3-b5-p3.properties &
#JMX=10161 kafka-server-start.sh kafka_exp/kafka-properties/server-z3-b6-p3.properties &
#JMX=10171 kafka-server-start.sh kafka_exp/kafka-properties/server-z3-b7-p3.properties &
# cd kafka-manager-1.3.0.4
# kafka-manager-1.3.0.4/
./kafka-manager -Dconfig.file=../conf/application-z3.conf -Dhttp.port=9001 &


kafka-topics.sh --list --zookeeper 172.17.24.231:2181,172.17.24.232:2181,172.17.24.233:2181/root/zookeeper-3.4.6/zookeeperdatadir/data
kafka-topics.sh --list --zookeeper 172.17.24.231:2181,172.17.24.232:2181,172.17.24.233:2181/root/zookeeper-3.4.6/zookeeperdatadir/data
kafka-topics.sh --describe --zookeeper 172.17.24.231:2181,172.17.24.232:2181,172.17.24.233:2181/root/zookeeper-3.4.6/zookeeperdatadir/data --topic kafkatest
kafka-topics.sh --describe --zookeeper 172.17.24.231:2181,172.17.24.232:2181,172.17.24.233:2181/root/zookeeper-3.4.6/zookeeperdatadir/data --topic kafkatest


kafka-topics.sh --create --zookeeper zks1:2181,zks2:2181,zks3:2181/root/zookeeper-3.4.6/zookeeperdatadir/data --partitions 6 --replication-factor 1 --topic kafkatest
kafka-topics.sh --create --zookeeper zks1:2181,zks2:2181,zks3:2181/root/zookeeper-3.4.6/zookeeperdatadir/data --partitions 6 --replication-factor 1 --topic kafkatest

kafka-topics.sh --delete --zookeeper 172.17.24.231:2181,172.17.24.232:2181,172.17.24.233:2181/root/zookeeper-3.4.6/zookeeperdatadir/data/root/zookeeper-3.4.6/zookeeperdatadir/data --topic ktest
kafka-topics.sh --delete --zookeeper 172.17.24.231:2181,172.17.24.232:2181,172.17.24.233:2181/root/zookeeper-3.4.6/zookeeperdatadir/data/root/zookeeper-3.4.6/zookeeperdatadir/data --topic ktest
#kafka-topics.sh --alter --zookeeper 172.17.24.231:2181,172.17.24.232:2181,172.17.24.233:2181/root/zookeeper-3.4.6/zookeeperdatadir/data --topic cep_storm --config replication-factor=1,partitions=3
#kafka-topics.sh --delete --zookeeper 172.17.24.231:2181,172.17.24.232:2181,172.17.24.233:2181172.17.24.231:2181,172.17.24.232:2181,172.17.24.233:2181/root/zookeeper-3.4.6/zookeeperdatadir/data --topic cep_storm


# produce
$ JMX_PORT=10102 kafka-console-producer.sh --broker-list 172.17.24.231:19091,172.17.24.231:19092,172.17.24.232:19093,172.17.24.232:19094,172.17.24.233:19095,172.17.24.233:19096 --topic kafkatest
$ JMX_PORT=10102 kafka-console-producer.sh --broker-list 172.17.24.231:19091,172.17.24.231:19092,172.17.24.232:19093,172.17.24.232:19094,172.17.24.233:19095,172.17.24.233:19096 --topic kafkatest
$ kafka-console-producer.sh --broker-list 172.17.24.231:19091,172.17.24.231:19092,172.17.24.232:19093,172.17.24.232:19094,172.17.24.233:19095,172.17.24.233:19096 --topic kafkatest < file

# consume
$ kafka-console-consumer.sh --zookeeper 172.17.24.231:2181,172.17.24.232:2181,172.17.24.233:2181/root/zookeeper-3.4.6/zookeeperdatadir/data --topic kafkatest
$ kafka-console-consumer.sh --zookeeper 172.17.24.231:2181,172.17.24.232:2181,172.17.24.233:2181/root/zookeeper-3.4.6/zookeeperdatadir/data --topic kafkatest --from-beginning
$ kafka-console-consumer.sh --bootstrap-server localhost:9092 --topic kafkatest --new-consumer --consumer.config consumer.properties


# perftest
kafka-producer-perf-test.sh --broker-list 172.17.24.231:19091,172.17.24.231:19092,172.17.24.232:19093,172.17.24.232:19094,172.17.24.233:19095,172.17.24.233:19096
kafka-producer-perf-test.sh --broker-list 172.17.24.231:19091,172.17.24.231:19092,172.17.24.232:19093,172.17.24.232:19094,172.17.24.233:19095,172.17.24.233:19096 --messages 100000 --threads 1 --message-size 200 -compression-codec 0 --topic kafkatest
kafka-producer-perf-test.sh --broker-list 172.17.24.231:19091,172.17.24.231:19092,172.17.24.232:19093,172.17.24.232:19094,172.17.24.233:19095,172.17.24.233:19096 --messages 50000000 --threads 8 --message-size 100 --batch-size 100 --compression-codec 0 --topic kafkatest
> kafka_exp/kafka_test_case/perf11-pd-5ww-012101.csv
kafka-consumer-perf-test.sh --zookeeper 172.17.24.231:2181,172.17.24.232:2181,172.17.24.233:2181 --messages 100000 --threads 1 --topic kafkatest
> kafka_exp/kafka_test_case/perf11-cs-5ww-012101.csv

# produce
#         開始|      結束|     訊息size|                總size| 每秒?MB|                 總筆數|     每秒?筆
perf11#  start.time| end.time| message.size| total.data.sent.in.MB| MB.sec| total.data.sent.in.nMsg|   nMsg.sec
#    02:10:30| 02:19:20|          100|               4768.37| 8.9941|                50000000| 94309.9061
#
# consume
#         開始|      結束|    訊息size|                總size|  每秒?MB|                總筆數|       每秒?筆
#  start.time| end.time| fetch.size|   data.consumed.in.MB|   MB.sec| data.consumed.in.nMsg|     nMsg.sec
#    02:22:22| 02:22:29|    1048576|              277.9675| 137.8123|               2914700| 1445066.9311


# check consumer offset
$ kafka-run-class.sh kafka.tools.ConsumerOffsetChecker --group cep_storm_1 --zookeeper 172.28.128.22:9092,172.28.128.23:9092,172.28.128.24:9092

# start kafka-manager
$ cd kafka-manager-1.3.0.4/bin
$ sudo ./kafka-manager -Dconfig.file=../conf/application-z3.conf -Dhttp.port=9001 &
-java-home /usr/lib/java/jdk1.8.0_66/


#######################  other test ######################


