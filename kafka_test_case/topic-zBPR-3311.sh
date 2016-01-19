#!/usr/bin/env bash
kafka-topics.sh --create --zookeeper 172.28.128.22:2181,172.28.128.23:2181,172.28.128.24:2181 -replication-factor 1 --partitions 3 --topic cep_storm
kafka-topics.sh --alter --zookeeper 172.28.128.22:2181,172.28.128.23:2181,172.28.128.24:2181 --topic cep_storm --config replication-factor=1,partitions=3
kafka-topics.sh --delete --zookeeper 172.28.128.22:2181,172.28.128.23:2181,172.28.128.24:2181 --topic cep_storm
kafka-topics.sh --create --zookeeper localhost:2181 -replication-factor 1 --partitions 1 --topic
kafka-topics.sh --create --zookeeper localhost:2181 -replication-factor 1 --partitions 1 --topic
kafka-topics.sh --create --zookeeper localhost:2181 -replication-factor 1 --partitions 1 --topic
kafka-topics.sh --create --zookeeper localhost:2181 -replication-factor 1 --partitions 1 --topic
kafka-topics.sh --create --zookeeper localhost:2181 -replication-factor 1 --partitions 1 --topic
kafka-topics.sh --create --zookeeper localhost:2181 -replication-factor 1 --partitions 1 --topic
kafka-topics.sh --create --zookeeper localhost:2181 -replication-factor 1 --partitions 1 --topic
kafka-topics.sh --create --zookeeper localhost:2181 -replication-factor 1 --partitions 1 --topic
kafka-topics.sh --create --zookeeper localhost:2181 -replication-factor 1 --partitions 1 --topic