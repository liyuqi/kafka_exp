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
kafka-topics.sh --describe --zookeeper 172.28.128.22:2181,172.28.128.23:2181,172.28.128.24:2181 --topic kafka
kafka-topics.sh --describe --zookeeper 172.28.128.22:2181,172.28.128.23:2181,172.28.128.24:2181 --topic cep_storm


kafka-topics.sh --create --zookeeper 172.28.128.22:2181,172.28.128.23:2181,172.28.128.24:2181 -replication-factor 1 --partitions 1 --topic kafkatest
kafka-topics.sh --create --zookeeper 172.28.128.22:2181,172.28.128.23:2181,172.28.128.24:2181 -replication-factor 1 --partitions 1 --topic cep_storm
#kafka-topics.sh --alter --zookeeper 172.28.128.22:2181,172.28.128.23:2181,172.28.128.24:2181 --topic cep_storm --config replication-factor=1,partitions=3
#kafka-topics.sh --delete --zookeeper 172.28.128.22:2181,172.28.128.23:2181,172.28.128.24:2181 --topic cep_storm
kafka-topics.sh --describe --zookeeper 172.28.128.22:2181,172.28.128.23:2181,172.28.128.24:2181 --topic cep_storm


# confirm


kafka-producer-perf-test.sh --broker-list 172.28.128.22:9092,172.28.128.23:9092,172.28.128.24:9092
kafka-producer-perf-test.sh --broker-list 172.28.128.22:9092,172.28.128.23:9092,172.28.128.24:9092 --messages 100 --topic kafkatest --threads 1 --message-size 100 --batch-size 100 --compression-codec 1


kafka-consumer-perf-test.sh --zookeeper 172.28.128.22:2181,172.28.128.23:2181,172.28.128.24:2181 --messages 50000000 --topic kafkatest --threads 1