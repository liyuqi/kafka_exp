1. Getting Started
    1.1 Introduction
    1.2 Use Cases
    1.3 Quick Start
    1.4 Ecosystem
    1.5 Upgrading
2. API
    2.1 Producer API
    2.2 Consumer API
    2.2.1 Old High Level Consumer API
    2.2.2 Old Simple Consumer API
    2.2.3 New Consumer API
3. Configuration
    3.1 Broker Configs
    3.2 Producer Configs
    3.3 Consumer Configs
    3.3.1 Old Consumer Configs
    3.3.2 New Consumer Configs
    3.4 Kafka Connect Configs
4. Design
    4.1 Motivation
    4.2 Persistence
    4.3 Efficiency
    4.4 The Producer
    4.5 The Consumer
    4.6 Message Delivery Semantics
    4.7 Replication
    4.8 Log Compaction
    4.9 Quotas
5. Implementation
    5.1 API Design
    5.2 Network Layer
    5.3 Messages
    5.4 Message format
    5.5 Log
    5.6 Distribution
6. Operations
    6.1 Basic Kafka Operations
        Adding and removing topics
        Modifying topics
        Graceful shutdown
        Balancing leadership
        Checking consumer position
        Mirroring data between clusters
        Expanding your cluster
        Decommissioning brokers
        Increasing replication factor
    6.2 Datacenters
    6.3 Important Configs
        Important Server Configs
        Important Client Configs
        A Production Server Configs
    6.4 Java Version
    6.5 Hardware and OS
        OS
        Disks and Filesystems
        Application vs OS Flush Management
        Linux Flush Behavior
        Ext4 Notes
    6.6 Monitoring
    6.7 ZooKeeper
        Stable Version
        Operationalization
7. Security
    7.1 Security Overview
    7.2 Encryption and Authentication using SSL
    7.3 Authentication using SASL
    7.4 Authorization and ACLs
    7.5 ZooKeeper Authentication
        New Clusters
        Migrating Clusters
        Migrating the ZooKeeper Ensemble
8. Kafka Connect
    8.1 Overview
    8.2 User Guide
    8.3 Connector Development Guide






kafka-producer-perf-test.sh --broker-list=localhost:9092 --messages 10000000 --topic test --threads 10 --message-size 1000 --batch-size 200 --compression-codec 1

kafka-producer-perf-test.sh --broker-list=localhost:9092 --messages 10000000 --topic test --threads 10 --message-size 1000 --batch-size 200 --compression-codec 1