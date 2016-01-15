# -*- coding: utf-8 -*-
from pykafka import KafkaClient
from datetime import date,datetime

client = KafkaClient(hosts="127.0.0.1:9092")

print(client.topics)
topic = client.topics['test']

'''同步producer'''
# with topic.get_sync_producer() as producer:
# 	for i in range(10000):
# 		#producer.produce(str('85,0,40187421,466977200122266,2015-11-05 01:59:55,3587160516678701,886989305765,103.2.218.49,103.2.216.227,1206917429,internet,1,10.187.41.152,5,406679,22,1,14842,8751,8,2048,21000,0,0,2,0,0,2015-11-05 02:01:30,167,167,95,0,264f67979880657,1206917429,,SAEW03-5-0,null,,466:97,,,31112,,1623,,,2')
# 		producer.produce(datetime.now().strftime("%Y%m%d %H:%M:%S")+' test message '+str(i))


'''非同步producer'''
with topic.get_producer(delivery_reports=True) as producer:
    count = 0
    while True:
        count += 1
        producer.produce(datetime.now().strftime("%Y%m%d %H:%M:%S")+' p1 test message '+str(count), 
        	partition_key='{}'.format(count))
        if count % 10**5 == 0:  # adjust this or bring lots of RAM ;)
            while True:
                try:
                    msg, exc = producer.get_delivery_report(block=False)
                    if exc is not None:
                        print 'Failed to deliver msg {}: {}'.format(
                            msg.partition_key, repr(exc))
                    else:
                        print 'Successfully delivered msg {}'.format(
                        msg.partition_key)
                except Queue.Empty:
                    break

# consumer = topic.get_simple_consumer()
# for message in consumer:
# 	if message is not None:
# 		print message.offset, message.value

# balance_consumer = topic.get_balanced_consumer(
# 	consumer_group = 'group1',
# 	zookeeper_connect='127.0.0.1:2181'
# 	auto_commit_enable=True,
# 	)
