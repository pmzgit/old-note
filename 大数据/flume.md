https://flume.apache.org/  
https://841809077.github.io/2019/03/04/Flume%E5%9F%BA%E6%9C%AC%E6%A6%82%E5%BF%B5%E5%8F%8A%E6%9E%B6%E6%9E%84%E8%AF%B4%E6%98%8E.html

### avro

https://kaimingwan.com/post/java/javagong-ju-yu-shi-jian/avroxu-lie-hua-gong-ju-shi-yong-jiao-cheng

https://fangjian0423.github.io/2016/02/21/avro-intro/

https://zhuanlan.zhihu.com/p/24803426

# 安装

cp flume-env.sh.template flume-env.sh

export JAVA_HOME=/opt/modules/jdk1.8.0_191
export HADOOP_HOME=/opt/modules/hadoop-2.6.0
export HBASE_HOME=/opt/modules/hbase-1.0.0-cdh5.4.0
export FLUME_HOME=/home/hadoop/apps/flume

flume-ng version

### 配置
http://flume.apache.org/releases/content/1.9.0/FlumeUserGuide.html
https://www.cnblogs.com/qingyunzong/p/8995554.html
https://www.cnblogs.com/qingyunzong/p/8996155.html
```sh
#配置一个agent，agent的名称可以自定义（如a1）
#指定agent的sources（如s1）、sinks（如k1）、channels（如c1）
#分别指定agent的sources，sinks,channels的名称 名称可以自定义
a1.sources = s1
a1.sinks = k1
a1.channels = c1

#配置source
a1.sources.s1.channels = c1
a1.sources.s1.type = avro
a1.sources.s1.bind = 192.168.123.102
a1.sources.s1.port = 6666

#配置channels
a1.channels.c1.type = memory
gent2.channels.c1.capacity = 10000
agent2.channels.c1.transactionCapacity = 10000
agent2.channels.c1.keep-alive = 5
#配置sinks
a1.sinks.k1.channel = c1
a1.sinks.k1.type = logger

#为sources和sinks绑定channels
a1.sources.s1.channels = c1
a1.sinks.k1.channel = c1


flume-ng agent --conf conf --conf-file ~/apps/flume/examples/single_avro.properties --name a1 -Dflume.root.logger=DEBUG,console -Dorg.apache.flume.log.printconfig=true -Dorg.apache.flume.log.rawdata=true


flume-ng avro-client -c ~/apps/flume/conf -H 192.168.123.102 -p 6666 -F 666.txt

Note that in a full deployment we would typically include one more option: --conf=<conf-dir>. The <conf-dir> directory would include a shell script flume-env.sh and potentially a log4j properties file. In this example, we pass a Java option to force Flume to log to the console and we go without a custom environment script.


agent2.sinks.k1.type = avro
agent2.sinks.k1.channel = c1
agent2.sinks.k1.hostname = bigdata-pro01.kfk.com
agent2.sinks.k1.port = 5555

# http://flume.apache.org/releases/content/1.9.0/FlumeUserGuide.html#hbasesinks


agenttest.sinks.hbaseSink-1.type = org.apache.flume.sink.hbase.HBaseSink
agenttest.sinks.hbaseSink-1.table = test_hbase_table  //HBase表名
agenttest.sinks.hbaseSink-1.columnFamily = familycolumn-1  //HBase表的列族名称
agenttest.sinks.hbaseSink-1.serializer= org.apache.flume.sink.hbase.SimpleHbaseEventSerializer
agenttest.sinks.hbaseSink-1.serializer.payloadColumn = columnname  //HBase表的列族下的某个列名称


agent.sinks.hbase-sink-2.serializer = org.apache.flume.sink.hbase.RegexHbaseEventSerializer
agent.sinks.hbase-sink-2.serializer.regex = \\[(.*?)\\]\\ \\[(.*?)\\]\\ \\[(.*?)\\]
agent.sinks.hbase-sink-2.serializer.colNames = time,IP,number

## http://flume.apache.org/releases/content/1.9.0/FlumeUserGuide.html#kafka-sink

```
## [flume-interceptor-monitor](https://www.ipcpu.com/2018/03/flume-interceptor-monitor/)

## hbase 用户权限

## HBase 的IPC通信方式


