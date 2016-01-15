
# start kafka server
kafka-server-start.sh ../config/server.properties

# topic
kafka-topics.sh --create --zookeeper localhost:2181 -replication-factor 1 --partitions 1 --topic kafkatest

# view topic
kafka-topics.sh --describe --zookeeper localhost:2181 --topic kafkatest
kafka-topics.sh --describe --zookeeper 172.28.128.22:2181 --topic kafkatest
kafka-topics.sh --list --zookeeper localhost:2181
kafka-topics.sh --list --zookeeper 172.28.128.22:2181

# produce
kafka-console-producer.sh --broker-list localhost:9092 --topic kafkatest
kafka-console-producer.sh --broker-list 172.28.128.22:9092 --topic kafkatest

# consume
kafka-console-consumer.sh --zookeeper localhost:2181 --topic kafkatest
kafka-console-consumer.sh --zookeeper 172.28.128.22:2181 --topic kafkatest

kafka-console-consumer.sh --zookeeper localhost:2181 --topic kafkatest --from-beginning
kafka-console-consumer.sh --zookeeper 172.28.128.22:2181 --topic kafkatest --from-beginning


##   C[2016-01-14 17:33:49,067] WARN Fetching topic metadata with correlation id 80 for topics [Set(kafkatest)] from broker [id:0,host:BT2016Realtime01,port:9092] failed (kafka.client.ClientUtils$)
##   java.nio.channels.ClosedChannelException
##           at kafka.network.BlockingChannel.send(BlockingChannel.scala:100)
##           at kafka.producer.SyncProducer.liftedTree1$1(SyncProducer.scala:73)
##           at kafka.producer.SyncProducer.kafka$producer$SyncProducer$$doSend(SyncProducer.scala:72)
##           at kafka.producer.SyncProducer.send(SyncProducer.scala:113)
##           at kafka.client.ClientUtils$.fetchTopicMetadata(ClientUtils.scala:58)
##           at kafka.client.ClientUtils$.fetchTopicMetadata(ClientUtils.scala:93)
##           at kafka.consumer.ConsumerFetcherManager$LeaderFinderThread.doWork(ConsumerFetcherManager.scala:66)
##           at kafka.utils.ShutdownableThread.run(ShutdownableThread.scala:60)
##   Consumed 0 messages

##  [2016-01-14 18:08:57,317] WARN Fetching topic metadata with correlation id 21 for topics [Set(kafkatest)] from broker [id:0,host:BT2016Realtime01,port:9092] failed (kafka.client.ClientUtils$)
##   java.nio.channels.ClosedChannelException
##           at kafka.network.BlockingChannel.send(BlockingChannel.scala:100)
##           at kafka.producer.SyncProducer.liftedTree1$1(SyncProducer.scala:73)
##           at kafka.producer.SyncProducer.kafka$producer$SyncProducer$$doSend(SyncProducer.scala:72)
##           at kafka.producer.SyncProducer.send(SyncProducer.scala:113)
##           at kafka.client.ClientUtils$.fetchTopicMetadata(ClientUtils.scala:58)
##           at kafka.client.ClientUtils$.fetchTopicMetadata(ClientUtils.scala:93)
##           at kafka.consumer.ConsumerFetcherManager$LeaderFinderThread.doWork(ConsumerFetcherManager.scala:66)
##           at kafka.utils.ShutdownableThread.run(ShutdownableThread.scala:60)
##   ^CConsumed 0 messages



# check consumer offset
kafka-run-class.sh kafka.tools.ConsumerOffsetChecker --zkconnect localhost:2181 --group test-consumer-group






# monitor with kafka-manager
sudo ./kafka-manager \
-Dconfig.file=../conf/application.conf \
-Dhttp.port=9001 \
-java-home /usr/lib/java/jdk1.8.0_66/

## /home/vagrant/kafka-manager-1.3.0.4/lib/kafka-manager.kafka-manager-1.3.0.4-assets.jar
## [info] o.a.z.ZooKeeper - Client environment:java.library.path=/usr/java/packages/lib/amd64:/usr/lib64:/lib64:/lib:/usr/lib
## [info] o.a.z.ZooKeeper - Client environment:java.io.tmpdir=/tmp
## [info] o.a.z.ZooKeeper - Client environment:java.compiler=<NA>
## [info] o.a.z.ZooKeeper - Client environment:os.name=Linux
## [info] o.a.z.ZooKeeper - Client environment:os.arch=amd64
## [info] o.a.z.ZooKeeper - Client environment:os.version=3.13.0-74-generic
## [info] o.a.z.ZooKeeper - Client environment:user.name=root
## [info] o.a.z.ZooKeeper - Client environment:user.home=/root
## [info] o.a.z.ZooKeeper - Client environment:user.dir=/home/vagrant/kafka-manager-1.3.0.4
## [info] o.a.z.ZooKeeper - Initiating client connection, connectString=172.28.128.24:2181 sessionTimeout=60000 watcher=org.apache.curator.ConnectionState@3d6d889b
## [info] o.a.z.ClientCnxn - Opening socket connection to server 172.28.128.24/172.28.128.24:2181. Will not attempt to authenticate using SASL (unknown error)
## [info] o.a.z.ClientCnxn - Socket connection established to 172.28.128.24/172.28.128.24:2181, initiating session
## [info] o.a.z.ClientCnxn - Session establishment complete on server 172.28.128.24/172.28.128.24:2181, sessionid = 0x2523ef4b2520013, negotiated timeout = 40000
## [info] play.api.Play - Application started (Prod)
## [info] p.c.s.NettyServer - Listening for HTTP on /0:0:0:0:0:0:0:0:9001
## [warn] o.a.c.r.ExponentialBackoffRetry - maxRetries too large (100). Pinning to 29
## [info] o.a.z.ZooKeeper - Initiating client connection, connectString=172.28.128.24:2181 sessionTimeout=60000 watcher=org.apache.curator.ConnectionState@6681dc80
## [info] o.a.z.ClientCnxn - Opening socket connection to server 172.28.128.24/172.28.128.24:2181. Will not attempt to authenticate using SASL (unknown error)
## [info] o.a.z.ClientCnxn - Socket connection established to 172.28.128.24/172.28.128.24:2181, initiating session
## [warn] o.a.c.r.ExponentialBackoffRetry - maxRetries too large (100). Pinning to 29
## [info] o.a.z.ZooKeeper - Initiating client connection, connectString=172.28.128.22:2181,172.28.128.23:2181,172.28.128.24:2181 sessionTimeout=60000 watcher=org.apache.curator.ConnectionState@58592a51
## [info] o.a.z.ClientCnxn - Opening socket connection to server 172.28.128.24/172.28.128.24:2181. Will not attempt to authenticate using SASL (unknown error)
## [info] o.a.z.ClientCnxn - Session establishment complete on server 172.28.128.24/172.28.128.24:2181, sessionid = 0x2523ef4b2520014, negotiated timeout = 40000
## [info] o.a.z.ClientCnxn - Socket connection established to 172.28.128.24/172.28.128.24:2181, initiating session
## [info] o.a.z.ClientCnxn - Session establishment complete on server 172.28.128.24/172.28.128.24:2181, sessionid = 0x2523ef4b2520015, negotiated timeout = 40000
## [error] k.m.a.c.BrokerViewCacheActor - Failed to get broker metrics for BrokerIdentity(0,dipvm71,9092,-1)
## [error] k.m.a.c.BrokerViewCacheActor - Failed to get topic metrics for broker BrokerIdentity(0,dipvm71,9092,-1)
## [error] k.m.a.c.BrokerViewCacheActor - Failed to get broker topic segment metrics for BrokerIdentity(0,dipvm71,9092,-1)
## [error] k.m.j.KafkaJMX$ - Failed to connect to service:jmx:rmi:///jndi/rmi://dipvm71:-1/jmxrmi

# monitor with jconsole (JMX)
JMX_PORT=10101	bin/kafka-server-start.sh	config/server.properties
JMX_PORT=10102	bin/kafka-console-producer.sh	--broker-list	localhost:9092	--topic	kafkatest
JMX_PORT=10103	bin/kafka-console-producer.sh	--broker-list	localhost:9092	--topic	kafkatest