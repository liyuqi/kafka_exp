#!/usr/bin/env bash

 sudo rm -r /usr/local/zk_dir/

zkServer.sh stop
zkServer.sh start


kafka-server-start.sh kafka_exp/kafka-properties/server-z3-b5-p3.properties &
kafka-server-start.sh kafka_exp/kafka-properties/server-z3-b6-p3.properties &
kafka-server-start.sh kafka_exp/kafka-properties/server-z3-b7-p3.properties &

#JMX=10151 kafka-server-start.sh kafka_exp/kafka-properties/server-z3-b5-p3.properties &
#JMX=10161 kafka-server-start.sh kafka_exp/kafka-properties/server-z3-b6-p3.properties &
#JMX=10171 kafka-server-start.sh kafka_exp/kafka-properties/server-z3-b7-p3.properties &
# cd kafka-manager-1.3.0.4
# kafka-manager-1.3.0.4/
./kafka-manager -Dconfig.file=../conf/application-z3.conf -Dhttp.port=9001 &


kafka-topics.sh --list --zookeeper 172.28.128.22:2181,172.28.128.23:2181,172.28.128.24:2181
kafka-topics.sh --describe --zookeeper 172.28.128.22:2181,172.28.128.23:2181,172.28.128.24:2181 --topic kafkatest
kafka-topics.sh --describe --zookeeper 172.28.128.22:2181,172.28.128.23:2181,172.28.128.24:2181 --topic cep_storm


kafka-topics.sh --create --zookeeper 172.28.128.22:2181,172.28.128.23:2181,172.28.128.24:2181 --partitions 1 --replication-factor 1 --topic kafkatest
kafka-topics.sh --create --zookeeper 172.28.128.22:2181,172.28.128.23:2181,172.28.128.24:2181 --partitions 1 --replication-factor 1 --topic cep_storm
#kafka-topics.sh --alter --zookeeper 172.28.128.22:2181,172.28.128.23:2181,172.28.128.24:2181 --topic cep_storm --config replication-factor=1,partitions=3
#kafka-topics.sh --delete --zookeeper 172.28.128.22:2181,172.28.128.23:2181,172.28.128.24:2181 --topic cep_storm
kafka-topics.sh --describe --zookeeper 172.28.128.22:2181,172.28.128.23:2181,172.28.128.24:2181 --topic cep_storm


# produce
$ kafka-console-producer.sh --broker-list 172.28.128.22:9092,172.28.128.23:9092,172.28.128.24:9092 --topic kafkatest
$ kafka-console-producer.sh --broker-list 172.28.128.22:9092,172.28.128.23:9092,172.28.128.24:9092 --topic kafkatest < file

# consume
$ kafka-console-consumer.sh --zookeeper localhost:2181 --topic kafkatest
$ kafka-console-consumer.sh --zookeeper localhost:2181 --topic kafkatest --from-beginning
$ kafka-console-consumer.sh --bootstrap-server localhost:9092 --topic kafkatest --new-consumer --consumer.config consumer.properties


# perftest
kafka-producer-perf-test.sh --broker-list 172.28.128.22:9092,172.28.128.23:9092,172.28.128.24:9092
kafka-producer-perf-test.sh --broker-list 172.28.128.22:9092,172.28.128.23:9092,172.28.128.24:9092 --messages 10000000 --threads 1 --message-size 300 -compression-codec 0 --topic ktest
kafka-producer-perf-test.sh --broker-list 172.28.128.22:9092,172.28.128.23:9092,172.28.128.24:9092 --messages 50000000 --threads 8 --message-size 100 --batch-size 100 --compression-codec 0 --topic perf11
> kafka_exp/kafka_test_case/perf11-pd-5ww-012101.csv
kafka-consumer-perf-test.sh --zookeeper 172.28.128.22:2181,172.28.128.23:2181,172.28.128.24:2181 --messages 100000 --threads 1 --topic ktest
> kafka_exp/kafka_test_case/perf11-cs-5ww-012101.csv

# check consumer offset
$ kafka-run-class.sh kafka.tools.ConsumerOffsetChecker --group test-consumer-group --zookeeper 172.28.128.22:9092,172.28.128.23:9092,172.28.128.24:9092

# start kafka-manager
$ cd kafka-manager-1.3.0.4/bin
$ sudo ./kafka-manager -Dconfig.file=../conf/application-z3.conf -Dhttp.port=9001 &
-java-home /usr/lib/java/jdk1.8.0_66/


#######################  other test ######################

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

$ kafka-run-class.sh kafka.tools.SimpleConsumerShell --broker-list 172.28.128.22:9092,172.28.128.23:9092,172.28.128.24:9092 --max-messages 10 --offset -2 --partition 0 --printoffsets --topic ktest





