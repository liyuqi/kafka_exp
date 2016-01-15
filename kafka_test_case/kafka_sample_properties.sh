
# start kafka server
$ kafka-server-start.sh ../config/server.properties
## server.properties
$ vi server.properties
    # The id of the broker. This must be set to a unique integer for each broker.
    broker.id=0
    # The port the socket server listens on
    port=9092
    # A comma seperated list of directories under which to store log files
    log.dirs=/tmp/kafka-logs
    # Zookeeper connection string (see zookeeper docs for details).
    zookeeper.connect=localhost:2181
    # Timeout in ms for connecting to zookeeper
    zookeeper.connection.timeout.ms=6000

# produce
$ kafka-console-producer.sh --broker-list localhost:9092 --topic kafkatest
## producer.properties
$ vi producer.properties
    # list of brokers : host1:port1,host2:port2 ...
    metadata.broker.list=localhost:9092
    # specifies whether the messages are sent asynchronously (async) or synchronously (sync)
    producer.type=sync
    # specify the compression codec for all data generated: none, gzip, snappy, lz4.
    # the old config values work as well: 0, 1, 2, 3 for none, gzip, snappy, lz4, respectively
    compression.codec=none


# consume
$ kafka-console-consumer.sh --zookeeper localhost:2181 --topic kafkatest
$ kafka-console-consumer.sh --zookeeper localhost:2181 --topic kafkatest --from-beginning
$ kafka-console-consumer.sh --bootstrap-server localhost:9092 --topic kafkatest --new-consumer --consumer.config consumer.properties
## consumer.properties
$ vi consumer.properties
    ## Zookeeper connection string
    zookeeper.connect=localhost:2181
    ## timeout in ms for connecting to zookeeper
    zookeeper.connection.timeout.ms=6000
    ## consumer group id
    group.id=test-consumer-group



    kafka-manager.zkhosts="172.28.128.24:2181"