##1: INTRODUCING KAFKA
###Welcome to the world of Apache Kafka
###Why do we need Kafka?
###Kafka use cases
###Installing Kafka
###Summary
##2: SETTING UP A KAFKA CLUSTER
###A single node – a single broker cluster
###A single node – multiple broker clusters
###Multiple nodes – multiple broker clusters
###The Kafka broker property list
###Summary

##3: KAFKA DESIGN
###Kafka design fundamentals

考慮以下情況

* 最多一次 Messages are never redelivered but may be lost 
* 最少一次 Messages may be redelivered but never lost    
* 剛好一次 Messages are delivered once and only once     

###Log compaction

retention policy針對每個topic有以下記錄方式

* time-based
* size-based
* log compaction-based

compaction 特性如下

* Ordering of messages is always maintained
* The messages will have sequential offsets and the offset never changes 
* Reads progressing from offset 0, or the consumer progressing from the start of the log, will see at least the final state of all records in the order they were written 

設計摘要如下
* The fundamental backbone of Kafka is message caching and storing on  the fiesystem. In Kafka, data is immediately written to the OS kernel  page. Caching and flushing of data to the disk are configurable. 
* Kafka provides longer retention of messages even after consumption, allowing consumers to re-consume, if required.
* Kafka uses a message set to group messages to allow lesser network overhead. 
* Unlike most messaging systems, where metadata of the consumed messages are kept at the server level, in Kafka the state of the consumed messages is maintained at the consumer level. This also addresses issues such as: 
>    * Losing messages due to failure 
>    * Multiple deliveries of the same message By default, consumers store the state in Zookeeper but Kafka also allows storing it within other storage systems used for Online Transaction Processing (OLTP) applications as well. 
* In Kafka, producers and consumers work on the traditional push-and-pull model, where producers push the message to a Kafka broker and consumers pull the message from the broker. 
* Kafka does not have any concept of a master and treats all the brokers as peers. This approach facilitates addition and removal of a Kafka broker at any point, as the metadata of brokers are maintained in Zookeeper and shared with consumers. 
* Producers also have an option to choose between asynchronous or synchronous mode to send messages to a broker.

###Message compression in Kafka
###Replication in Kafka
###Summary
##4: WRITING PRODUCERS
###The Java producer API
###Simple Java producers

重要 properties
* metadata.broker.list
* serializer.class
* request.required.acks=0

分片設定
* partitioner.class
* request.required.acks=1

同步模式
* async (batch)
* sync

###Creating a Java producer with custom partitioning
###The Kafka producer property list
###Summary
##5: WRITING CONSUMERS
###Kafka consumer APIs
###Simple Java consumers
###Reading messages from a topic and printing them
###Multithreaded Java consumers
###The Kafka consumer property list
###Summary
##6: KAFKA INTEGRATIONS
###Kafka integration with Storm
###Introducing Storm
###Kafka integration with Hadoop
###Summary
##7: OPERATIONALIZING KAFKA
###Kafka administration tools
###Kafka cluster mirroring



###Integration with other tools
###Summary