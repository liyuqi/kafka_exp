## 0.目錄結構

```bash
├── jona_sample                     # jona script 主要學習 script
├── kafka-exception                 # 錯誤事件記錄 (*.log)
├── kafka_notes                     # 實作筆記 (table content 是目錄, notes 是各篇摘要)
├── kafka-properties                # 設定概要 (broker,producer,consumer .properties)
│   ├── consumer.properties
│   ├── producer.properties
│   ├── server.properties
│   ├── server-z3-b5-p3.properties
│   ├── server-z3-b6-p3.properties
│   └── server-z3-b7-p3.properties
├── kafka_test_case                 # 測試案例
│   ├── bt_kafka_cluster.sh             ## *201601 cluster測試*
│   ├── kafka_topic1_rs1_p1.sh
│   ├── kafka_unit_test_2.py
│   ├── perftest-10w-raws           ## 10w筆測試
│   ├── perftest5kw-raws            ## 5kw筆測試
│   └── test_kafka_cluster.sh           ## *201601 本機測試*
├── test011401                      # 放置 test script
│   ├── kafka_consumer.py
│   └── kafka_producer.py
├── unit_test
│   ├── kafka_unit_test_2.py
│   └── kafka_unit_test.py
├── kafka_producer.py
├── kafka_consumer.py
└── README.md           # 此repo概要
```

## 1.initialize kafka
    replica 相當於 rs
    partition 相當於 shard
    broker 相當於 mongod
    message:value 訊息

### 1.1 設定 Broker

### 1.2 建立 topic
* 建立 topic:kafkatest

`kafka-topics.sh --create --zookeeper localhost:2181 -replication-factor 1 --partitions 1 --topic kafkatest`
* 查看 topic:kafkatest

`kafka-topics.sh --list --zookeeper localhost:2181 kafkatest`
* 描述 topic:kafkatest

`kafka-topics.sh --describe --zookeeper localhost:2181 --topic kafkatest`
* 建立 rs topic

`kafka-topics.sh --create --zookeeper localhost:2181 -replication-factor 3 --partitions 1 --topic rskafka`
* 描述 rs topic

`kafka-topics.sh --describe --zookeeper localhost:2181 --topic rskafka`

>Topic:replicatedkafkatest
>PartitionCount:1
>ReplicationFactor:3
>Configs:
>
>Topic:	replicatedkafkatest
>Partition:	0
>Leader:	2
>Replicas:	2,0,1
>Isr:	2,0,1

describe   資訊說明             |description
--- | ---
PartitionCount | 某topic下partition的數量
ReplicationFactor | 某topic下replicas的數量
Leader | 指定的partition中負責RW操作的node(server)
Replicas | 有replica的node(server)清單，含有dead
ISR | in-sync replica的node(server)清單，kafka cluster中 replica nodes的subset

### 1.3 produce message

* 發布 msg
`kafka-console-producer.sh --broker-list localhost:9092 --topic kafkatest`
    > line 1 hello
    > line 2 helloo

param   參數說明             |description        |sample
--- | --- | ---
*--broker-list               |zookeeper servers  |hostname:port
--topic                     |topic 名稱          |kafkatest
--sync                      |指定傳送方式(同步)
--compression-codec         |壓縮方式            |none,default:gzip,snappy,lz4
--batch-size                |非sync時的傳送
--message-send-max-retries  |broker無回應時,重傳數
--retry-backoff-ms          |leader重選的初始時間

### 1.4 consume message
* 訂閱 msg
`kafka-console-consumer.sh --zookeeper localhost:2181 --topic kafkatest --from-beginning`
    > line 1 hello
    > line 2 helloo

param   參數說明p81          |description    |sample
--- | --- | ---
--fetch-size                |   訂閱byte量
--socket-buffer-size        |TCP接收byte量
--autocommit.interval.ms    |offset保留時間
--max-messages              |               |default:無限大
--skip-message-on-error     |               |default:直接skip

#### 1.4.1 params

properties | default value | description
--- | --- | ---
broker.id | 0 | 多个Kafka服务不能相同
port|9092|KAFKA绑定的端口
zookeeper.connect|localhost:2181|ZooKeeper的连接URL
zookeeper.connection.timeout.ms|1000000|ZooKeeper的超时连接时间
>`host.name=HDP125	无	主机名`
>`advertised.host.name	HDP125`
>`advertised.port	9092`
num.network.threads	2
num.io.threads	8
socket.send.buffer.bytes	1048576
socket.receive.buffer.bytes	1048576
socket.request.max.bytes	104857600
num.partitions	2
>`log.flush.interval.messages	10000`
>`log.flush.interval.ms	1000`
log.retention.hours	168
>`log.retention.bytes	1073741824`
log.segment.bytes	536870912
log.retention.check.interval.ms	60000
log.cleaner.enable	false


## 8. Monitor

### 8.1 jconsole

開啟 broker 上的 JMX
```bash
JMX_PORT=10103 kafka-console-producer.sh --broker-list locaost:9092 --topic topic
JMX_PORT=10101 kafka-server-start.sh
```

啟動jconsole /MBean
```bash
jconsole 
   -Dcom.sun.management.jmxremote.port=6789
   -Dcom.sun.management.jmxremote.authenticate=false
   -Dcom.sun.management.jmxremote.ssl=false
    service:jmx:remoting-jmx://172.28.128.22:9999
```

```service:jmx:rmi:///jndi/rmi://localhost:9999/jmxrmi```

### 8.2 kafka-manager

* ref [https://github.com/yahoo/kafka-manager]
* ref [http://hengyunabc.github.io/kafka-manager-install/]

特點:
* 建立 cluster
* 查看 broker
* 建立 topic
* 設定 topic 的 rs, partition
* 刪除 topic

#### 8.2.1 啟動kafka-manager

```bash
java8 $ sudo ./kafka-manager -Dconfig.file=../conf/application.conf -Dhttp.port=9001 &
-java-home /usr/lib/java/jdk1.8.0_66/
```
記得CentOS 防火牆允許port 

ref [http://www.centoscn.com/CentOS/help/2015/0208/4667.html]
```firewall-cmd --zone=public --add-port=9001/tcp --permanent```
```firewall-cmd --zone=public --add-port=8080/tcp --permanent```

#### 8.2.2 開啟 broker 上的 JMX (查看流量 metrics)

```bash
$ JMX_PORT=10101	bin/kafka-server-start.sh	config/server.properties
$ JMX_PORT=10102	bin/kafka-console-producer.sh	--broker-list	localhost:9092	--topic	kafkatest
$ JMX_PORT=10103	bin/kafka-console-producer.sh	--broker-list	localhost:9092	--topic	kafkatest
```