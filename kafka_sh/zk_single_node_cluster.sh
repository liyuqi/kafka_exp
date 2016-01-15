#!/bin/bash

# 目標:在單台Server建立 zookeeper cluster(3個成員)

# ref 1:[http://ydt619.blog.51cto.com/316163/1230571]
# ref 2:[https://www.ibm.com/developerworks/cn/opensource/os-cn-zookeeper/]

# 安裝 zookeeper
wget http://apache.stu.edu.tw/zookeeper/zookeeper-3.4.6/zookeeper-3.4.6.tar.gz
sudo tar zxvf zookeeper-3.4.6.tar.gz -C  /usr/local/
rm zxvf zookeeper-3.4.6.tar.gz

# 建立 cfg 
cd $ZK_HOME/conf
for file in zk0.cfg zk1.cfg zk2.cfg; do cp zoo_sample.cfg $file;done

# 指定 dataDir (每個 zk 都不同)
for((i=0; i<3; i=i+1))
do 
  sed -i "s/clientPort=2181/clientPort=218$i/g" zk$i.cfg
  sed -i "s/tmp\/zookeeper/tmp\/zookeeper\/zk$i/g" zk$i.cfg
done

# 叢集成員
for file in zk0.cfg zk1.cfg zk2.cfg;
do echo '
server.0=localhost:2887:3887
server.1=localhost:2888:3888
server.2=localhost:2889:3889
' | sudo tee -a $ZK_HOME/conf/$file
done

# 告知編號 (與叢集成員呼應)
for f in zk0 zk1 zk2
do mkdir -p /tmp/zookeeper/$f
done

echo 0 > /tmp/zookeeper/zk0/myid
echo 1 > /tmp/zookeeper/zk1/myid
echo 2 > /tmp/zookeeper/zk2/myid

# 設定 ZOOKEEPER_HOME
echo '
export   ZOOKEEPER_HOME=/usr/local/zookeeper-3.4.6
' | sudo tee -a /etc/profile

sudo sed -i 's/PATH=$PATH/PATH=$PATH:$ZOOKEEPER_HOME\/bin/g' /etc/profile

source /etc/profile

# 啟動 zk
zkServer.sh restart /usr/local/zookeeper-3.4.6/conf/zk0.cfg
zkServer.sh restart /usr/local/zookeeper-3.4.6/conf/zk1.cfg
zkServer.sh restart /usr/local/zookeeper-3.4.6/conf/zk2.cfg

# # 檢查狀態
# zkServer.sh status /usr/local/zookeeper-3.4.6/conf/zk0.cfg
# zkServer.sh status /usr/local/zookeeper-3.4.6/conf/zk1.cfg
# zkServer.sh status /usr/local/zookeeper-3.4.6/conf/zk2.cfg

# # 登入shell
# zkCli.sh -server localhost:2180
# zkCli.sh -server localhost:2181
# zkCli.sh -server localhost:2182