#!/usr/bin/env bash

ssh 172.17.24.22 "nohup kafka-server-start.sh kafka_exp/kafka-properties/server-z3-b5-p3.properties &"
ssh 172.17.24.22 "nohup kafka-server-start.sh kafka_exp/kafka-properties/server-z3-b6-p3.properties &"
nohup kafka-server-start.sh kafka_exp/kafka-properties/server-z3-b7-p3.properties &
kafka-manager-1.3.0.4/bin/kafka-manager -Dconfig.file=kafka-manager-1.3.0.4/conf/application.conf -Dhttp.port=9001 &