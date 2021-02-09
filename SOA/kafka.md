# [分布式系统与消息的投递](https://draveness.me/message-delivery)

* 单体服务中的消息往往可以通过 IO、进程间通信、方法调用的方式进行通信，而分布式系统中的远程调用就需要通过网络，使用 UDP 或者 TCP 等协议进行传输。

* 网络请求由于超时的问题，消息的发送者只能通过重试的方式对消息进行重发，但是这就可能会导致消息的重复发送与处理，然而如果超时后不重新发送消息也可能导致消息的丢失，所以如何在不可靠的通信方式中，保证消息不重不漏是非常关键的。

* 我们一般都会认为，消息的投递语义有三种，分别是最多一次（At-Most Once）、最少一次（At-Least Once）以及正好一次（Exactly Once）

* 消息去重需要生产者生产消息时加入去重的 key，消费者可以通过唯一的 key 来判断当前消息是否是重复消息，从消息发送者的角度来看，实现正好一次的投递是不可能的，但是从整体来看，我们可以通过唯一 key 或者重入幂等的方式对消息进行『去重』。

* 投递顺序:可以规定，状态的迁移方向，所有资源的状态只能按照我们规定好的线路进行改变,有限状态机的写法，逻辑清晰，表达力强，有利于封装事件。一个对象的状态越多、发生的事件越多，就越适合采用有限状态机的写法。异步编程

# Kafka的特性
由Scala和Java语言编写的的。Kafka是一个基于发布-订阅
高吞吐量、低延迟：单个Kafka Broker 每秒可以处理数十万的读写请求,Kafka将所有数据保存到磁盘，这实质上意味着所有写入都会进入操作系统（RAM）的页面缓存。 这使得将数据从页面缓存传输到网络套接字非常有效。 
可扩展性：kafka集群支持热扩展  
持久性、可靠性：消息被持久化到本地磁盘，并且支持数据备份防止数据丢失  
容错性：允许集群中节点失败（若副本数量为n,则允许n-1个节点失败）  
高并发：支持数千个客户端同时读写  

# [原理](https://wuyanteng.github.io/2017/11/20/Apache-Kafka%E5%8E%9F%E7%90%86%E8%AF%A6%E8%A7%A3-%E8%BF%9B%E9%98%B61/)
* brokers 

一个topic拥有N个分区，并且集群拥有N个broker,则每个broker会负责一个分区。2. 假设，一个topic拥有N个分区，并且集群拥有N+M个broker,则前N个broker每个处理一个分区，剩余的M个broker则不会处理任何分区 3。 假设，一个topic拥有N个分区，并且集群拥有M个broker（M < N），则这些分区会在所有的broker中进行均匀分配。每个broker可能会处理一个或多个分区。这种场景不推荐使用，因为会导致热点问题和负载不均衡问题。

确保所有的消息均匀分布在topic的所有partition上

Kafka brokers 是无状态的，因为它们使用 ZooKeeper 来保持它们的集群信息。即使保存了TB级的数据也不会影响性能。Kafka broker de leader 选举是通过Zookeeper实现的。

Leader是负责某个分区数据读写操作的节点。每个分区都有一个leader.跟随leader操作的节点被称为follower。如果leader节点不可用，则会从所有的fellower中挑选一个作为新的leader节点。一个follower节点作为leader节点一个普通的消费者，拉取leader数据并更新自己的数据存储。一个服务器对于某个分区是leader，对于其它分区可能是follower

>Topic:Multibrokerapplication PartitionCount:1 ReplicationFactor:3 Configs:
Topic:Multibrokerapplication Partition:0 Leader:0 Replicas:0,2,1 Isr:0,2,1


第一个broker（with broker.id 0）是领导者。 然后Replicas：0,2,1意味着所有的Broker已经完成topic的复制。Isr是in-sync副本的集合。这是副本的子集，当前活着的并和leader保持同步的结点。



* Producers

任意时刻 producer 发布到broker中的消息都会被追加到某个分区的最后一个segment文件的最后。 Producer 也可以选择消息发送到指定的分区.
Producer不等待来自Broker的确认，并以Broker可以处理的速度发送消息。

* Consumers 

订阅一个或多个 topic，并通过pull方式从broker拉取订阅的数据。一旦消息被处理，消费者将向Kafka broker发送确认,一旦Kafka收到确认，它将offset更改为新值，并在Zookeeper中更新它。 由于offset在Zookeeper中被维护，消费者可以正确地读取下一条消息，即使服务器宕机后重启。

由于 Kafka brokers 是无状态的， 因此需要Consumer来维护根据partition offset已经消费的消息数量信息。 如果 consumer 确认了一个指定消息的offset，那也就意味着 consumer 已经消费了该offset之前的所有消息。Consumer可以向Broker异步发起一个拉取消息的请求来缓存待消费的消息。consumers 也可以通过提供一个指定的offset值来回溯或跳过Partition中的消息。Consumer 消费消息的offset值是保存在ZooKeeper中的。

一旦新的消费者加入后，Kafka将操作切换到共享模式，将所有topic的消息在两个消费者间进行均衡消费。这种共享行为直到加入的消费者结点数目达到该topic的分区数。一旦消费者的数目大于topic的分区数，则新的消费者不会收到任何消息直到已经存在的消费者取消订阅。出现这种情况是因为Kafka中的每个消费者将被分配至少一个分区，并且一旦所有分区被分配给现有消费者，新消费者将必须等待。

由于所有关键信息存储在Zookeeper中，并且它通常在其整个集群上复制此数据，因此Zookeeper的故障不会影响Kafka集群的状态。一旦Zookeeper重新启动， Kafka将恢复状态。 这为Kafka带来了零停机时间。 Kafka代理之间的领导者选举也通过使用Zookeeper在领导失败的情况下完成。

Consumers可以加入一个consumer 组，共同竞争一个topic，topic中的消息将被分发到组中的一个成员中。同一组中的consumer可以在不同的程序中，也可以在不同的机器上。如果所有的consumer都在一个组中，这就成为了传统的队列模式，在各consumer中实现负载均衡。

如果所有的consumer都不在不同的组中，这就成为了发布-订阅模式，所有的消息都被分发到所有的consumer中。

更常见的是，每个topic都有若干数量的consumer组，每个组都是一个逻辑上的“订阅者”，为了容错和更好的稳定性，每个组由若干consumer组成。这其实就是一个发布-订阅模式，只不过订阅者是个组而不是单个consumer。



# 单机
```sh
启动顺序，zookeeper、kafka  
关闭顺序，kafka、zookeeper  
./bin/zookeeper-server-start.sh -daemon config/zookeeper.properties
tail -200f logs/zookeeper.out
bin/kafka-server-start.sh -daemon config/server.properties
tail -2000f logs/server.log
```
# 集群搭建
## kafka 基于2.0.0

共享队列默认是500的上限，如果满了会阻塞
```sh
#配置文件 config/server.properties
broker.id=1
listeners=PLAINTEXT://:9093
log.dirs=/tmp/kafka-logs-1

delete.topic.enable=true
host.name=master
log.retention.hours=168
#retention.ms=
#retention.bytes
#max.message.bytes
replica.fetch.max.bytes=1048576
zookeeper.connect=10.20.1.153:2181,10.20.1.154:2181,10.20.1.155:2181/kfk01
auto.create.topics.enable=false
auto.leader.rebalance.enable=false
unclean.leader.election.enable=false
#消息至少要被写入到多少个副本才算是“已提交” replication.factor = min.insync.replicas + 1
min.insync.replicas=2
#这个是borker进行网络处理的线程数
num.network.threads=3 
#这个是borker进行执行请求逻辑的线程数
num.io.threads=8
# 发送缓冲区buffer大小，数据不是一下子就发送的，先回存储到缓冲区了到达一定的大小后在发送，能提高性能
socket.send.buffer.bytes=102400
# kafka接收缓冲区大小，当数据到达一定大小后在序列化到磁盘
socket.receive.buffer.bytes=102400

#这个参数是向kafka请求消息或者向kafka发送消息的请请求的最大数，这个值不能超过java的堆栈大小
socket.request.max.bytes=104857600
#默认的分区数，一个topic默认1个分区数
num.partitions = 1 #默认Topic分区数
num.replica.fetchers = 1 #默认副本数
default.replication.factor=3
num.recovery.threads.per.data.dir=1
#默认消息的最大持久化时间，168小时，7天
log.retention.hours=168
#这个参数是：因为kafka的消息是以追加的形式落地到文件，当超过这个值的时候，kafka会新起一个文件
log.segment.bytes=1073741824

log.retention.check.interval.ms=300000

zookeeper.connection.timeout.ms=30000

# config/producer.properties
bootstrap.servers=localhost:9092

# config/consumer.properties


# 命令行 All of the command line tools have additional options; running the command with no arguments will display usage information documenting them in more detail.

# 启动

export KAFKA_HEAP_OPTS=--Xms6g  --Xmx6g
export KAFKA_JVM_PERFORMANCE_OPTS= -server -XX:+UseG1GC -XX:MaxGCPauseMillis=20 -XX:InitiatingHeapOccupancyPercent=35 -XX:+ExplicitGCInvokesConcurrent -Djava.awt.headless=true

./bin/kafka-server-start.sh -daemon config/server.properties

#查看日志
tailf /usr/local/kafka/logs/server.log

# jps

# 创建：topic

bin/kafka-topics.sh --bootstrap-server broker_host:port --create --topic my_topic_name  --partitions 1 --replication-factor 1

bin/kafka-topics.sh --bootstrap-server localhost:9092 --create --topic transaction --partitions 1 --replication-factor 1 --config retention.ms=15552000000 --config max.message.bytes=5242880

# 修改常规主题参数
retention.bytes=-1

bin/kafka-configs.sh --zookeeper localhost:2181 --entity-type topics --entity-name transaction --alter --add-config max.message.bytes=10485760

./bin/kafka-topics.sh --create --zookeeper 127.0.0.1:2181 --replication-factor 1 --partitions 1 --topic message_down_queue_topic

./bin/kafka-topics.sh --delete --zookeeper 192.168.200.67:2181 --topic my-replicated-topic

./bin/kafka-topics.sh --list --zookeeper 127.0.0.1:2181 _consumer_offsets

bin/kafka-topics.sh --bootstrap-server broker_host:port --list (--describe)

./bin/kafka-topics.sh --describe --zookeeper 127.0.0.1:2181

./bin/kafka-topics.sh --describe --zookeeper 192.168.205.235:2181  --topic Multibrokerapplication

bin/kafka-topics.sh --zookeeper 192.168.205.235:2181 --alter --topic topic_name --partitions count


bin/kafka-topics.sh --bootstrap-server broker_host:port --alter --topic <topic_name> --partitions <新分区数>


bin/kafka-topics.sh --bootstrap-server broker_host:port --delete  --topic <topic_name>


bin/kafka-configs.sh --zookeeper zookeeper_host:port --alter --add-config 'leader.replication.throttled.rate=104857600,follower.replication.throttled.rate=104857600' --entity-type brokers --entity-name 0

bin/kafka-configs.sh --zookeeper zookeeper_host:port --alter --add-config 'leader.replication.throttled.replicas=*,follower.replication.throttled.replicas=*' --entity-type topics --entity-name test



bin/kafka-reassign-partitions.sh --zookeeper zookeeper_host:port --reassignment-json-file reassign.json --execute



# p
bin/kafka-console-producer.sh --broker-list 127.0.0.1:9092 --topic message_down_queue_topic --producer.config config/producer.properties

echo '00000,{"name":"Steve", "title":"Captain America"}' | kafka-console-producer.sh \
              --broker-list localhost:9092 \
              --topic earth \
              --property parse.key=true \
              --property key.separator=,

# c
bin/kafka-console-consumer.sh --bootstrap-server 127.0.0.1:9092 --topic message_down_queue_topic --from-beginning --consumer.config config/consumer.properties
--property print.key=true \                              --property key.separator=,
fetch.message.max.bytes
## offset
kafka-run-class.sh kafka.tools.GetOffsetShell \
                                 --broker-list localhost:9092 \
                                 --topic earth \
                                 --time -1

# -1表示显示获取当前offset最大值，-2表示offset的最小值

bin/kafka-console-consumer.sh --bootstrap-server kafka_host:port --topic __consumer_offsets --formatter "kafka.coordinator.group.GroupMetadataManager\$OffsetsMessageFormatter" --from-beginning


bin/kafka-console-consumer.sh --bootstrap-server kafka_host:port --topic __consumer_offsets --formatter "kafka.coordinator.group.GroupMetadataManager\$GroupMetadataMessageFormatter" --from-beginning

# lag


$ bin/kafka-consumer-groups.sh --bootstrap-server <Kafka broker连接信息> --describe --group <group名称> 
--partition 独立消费者

# java api


<!-- https://mvnrepository.com/artifact/org.springframework.kafka/spring-kafka -->
<dependency>
    <groupId>org.springframework.kafka</groupId>
    <artifactId>spring-kafka</artifactId>
    <version>2.4.6.RELEASE</version>
</dependency>


<!-- https://mvnrepository.com/artifact/org.apache.kafka/kafka-clients -->
<dependency>
    <groupId>org.apache.kafka</groupId>
    <artifactId>kafka-clients</artifactId>
    <version>2.3.0</version>
</dependency>
# 生产
配置项	说明
client.id	标志生产者应用程序
producer.type	可以是 sync 或 async
acks	这个配置可以设定发送消息后是否需要Broker端返回确认，0: 不需要进行确认，速度最快。存在丢失数据的风险。1: 仅需要Leader进行确认，不需要ISR进行确认。是一种效率和安全折中的方式。all: 需要ISR中所有的Replica给予接收确认，速度最慢，安全性最高，但是由于ISR可能会缩小到仅包含一个Replica，所以设置参数为all并不能一定避免数据丢失。

unclean.leader.election.enable = false
retries	如果生产者发送消息失败后会通过该选择指定的值进行重试
bootstrap.servers	生产者启动的Broker结点列表
linger.ms	Producer默认会把两次发送时间间隔内收集到的所有Requests进行一次聚合然后再发送，以此提高吞吐量，而linger.ms则更进一步，这个参数为每次发送增加一些delay，以此来聚合更多的Message
key.serializer	消息 Key 值序列化接口
value.serializer	消息 value 的序列化接口
batch.size	Producer会尝试去把发往同一个Partition的多个Requests进行合并，batch.size指明了一次Batch合并后Requests总大小的上限。如果这个值设置的太小，可能会导致所有的Request都不进行Batch
buffer.memory	在Producer端用来存放尚未发送出去的Message的缓冲区大小。缓冲区满了之后可以选择阻塞发送或抛出异常，由block.on.buffer.full的配置来决定
compression.type=gzip
# 消费
bootstrap.servers	Bootstrapping list of brokers.
group.id	Assigns an individual consumer to a group.
enable.auto.commit	enable.auto.commitEnable auto commit for offsets if the value is true, otherwise not committed.
auto.commit.interval.ms 默认值是 5 秒	Return how often updated consumed offsets are written to ZooKeeper.
session.timeout.ms=6s	该参数的默认值是 10 秒，即如果 Coordinator 在 10 秒之内没有收到 Group 下某 Consumer 实例的心跳，它就会认为这个 Consumer 实例已经挂了（取各消费者设置中的最大的值）  
heartbeat.interval.ms=2s 控制发送心跳请求频率的参数,这个值设置得越小，Consumer 实例发送心跳请求的频率就越高
auto.offset.reset earliest
当各分区下有已提交的offset时，从提交的offset开始消费；无提交的offset时，从头开始消费
latest
当各分区下有已提交的offset时，从提交的offset开始消费；无提交的offset时，消费新产生的该分区下的数据
none
topic各分区都存在已提交的offset时，从offset后开始消费；只要有一个分区不存在已提交的offset，则抛出异常
max.poll.records 500 单次 poll 方法能够返回的消息总数的上限
max.poll.interval.ms 参数。它限定了 Consumer 端应用程序两次调用 poll 方法的最大时间间隔。它的默认值是 5 分钟，表示你的 Consumer 程序如果在 5 分钟之内无法消费完 poll 方法返回的消息，那么 Consumer 会主动发起“离开组”的请求，Coordinator 也会开启新一轮 Rebalance（(Re)join group日志）。
```

consumer有重连机制

第一类非必要 Rebalance 是因为未能及时发送心跳，导致 Consumer 被“踢出”Group 而引发的。 （0.10.1之前是在调用poll方法时发送的，0.10.1之后consumer使用单独的心跳线程来发送） 
第二类非必要 Rebalance 是 Consumer 消费时间过长导致的。（poll和业务处理通常是在一个线程中，因此业务处理速度会影响poll调用频率）  

partition.assignment.strategy=org.apache.kafka.clients.consumer.RoundRobinAssignor试试。后引入的RoundRobinAssingor在对抗极端情况时比默认的RangeAssignor要均匀一些，不妨试试

一旦Coordinator将consumer踢出组，该consumer实例会禁掉心跳并等待前端主线程重新加入组

standalone consumer就没有rebalance一说了
```java
String topic = "foo";
TopicPartition partition0 = new TopicPartition(topic, 0);
TopicPartition partition1 = new TopicPartition(topic, 1);
consumer.assign(Arrays.asList(partition0, partition1));
```

Producer 端压缩、Broker 端保持、Consumer 端解压缩。  
Kafka使用Zero Copy优化将页缓存中的数据直接传输到Socket——这的确是发生在broker到consumer的链路上。这种优化能成行的前提是consumer端能够识别磁盘上的消息格式。  

在创建 KafkaProducer 实例时，生产者应用会在后台创建并启动一个名为 Sender 的线程，该 Sender 线程开始运行时首先会创建与 Broker 的连接。TCP 连接还可能在两个地方被创建：一个是在更新元数据后，另一个是在消息发送时。

场景一：当 Producer 尝试给一个不存在的主题发送消息时，Broker 会告诉 Producer 说这个主题不存在。此时 Producer 会发送 METADATA 请求给 Kafka 集群，去尝试获取最新的元数据信息。  
场景二：Producer 通过 metadata.max.age.ms 参数定期地去更新元数据信息。该参数的默认值是 300000，即 5 分钟，也就是说不管集群那边是否有变化，Producer 每 5 分钟都会强制刷新一次元数据以保证它是最及时的数据。

Producer 端关闭 TCP 连接的方式有两种：  
一种是用户主动关闭；一种是 Kafka 自动关闭。我们先说第一种。这里的主动关闭实际上是广义的主动关闭，甚至包括用户调用 kill -9 主动“杀掉”Producer 应用。当然最推荐的方式还是调用 producer.close() 方法来关闭。  
第二种是 Kafka 帮你关闭，这与 Producer 端参数 connections.max.idle.ms 的值有关。默认情况下该参数值是 9 分钟，即如果在 9 分钟内没有任何请求“流过”某个 TCP 连接，那么 Kafka 会主动帮你把该 TCP 连接关闭。用户可以在 Producer 端设置 connections.max.idle.ms=-1 禁掉这种机制。一旦被设置成 -1，TCP 连接将成为永久长连接。当然这只是软件层面的“长连接”机制，由于 Kafka 创建的这些 Socket 连接都开启了 keepalive，因此 keepalive 探活机制还是会遵守的。值得注意的是，在第二种方式中，TCP 连接是在 Broker 端被关闭的，但其实这个 TCP 连接的发起方是客户端，因此在 TCP 看来，这属于被动关闭的场景，即 passive close。被动关闭的后果就是会产生大量的 CLOSE_WAIT 连接，因此 Producer 端或 Client 端没有机会显式地观测到此连接已被中断。

幂等性Producer的局限性：单分区幂等性、单会话幂等性  
启用了幂等性，则ack默认就是-1，kafka就会为每个生产者分配一个pid，并未每条消息分配seqnumber，如果pid、partition、seqnumber三者一样，则kafka认为是重复数据，就不会落盘保存；但是如果生产者挂掉后，也会出现有数据重复的现象；
props.put(ProducerConfig.ENABLE_IDEMPOTENCE_CONFIG， true)。0.11.0.0  

事务型 Producer 能够保证将消息原子性地写入到多个分区中。这批消息要么全部写入成功，要么全部失败。另外，事务型 Producer 也不惧进程的重启。Producer 重启回来后，Kafka 依然保证它们发送消息的精确一次处理。  
设置 Producer 端参数 transactional.id。最好为其设置一个有意义的名字。  

```sh
producer.initTransactions();
try {
            producer.beginTransaction();
            producer.send(record1);
            producer.send(record2);
            producer.commitTransaction();
} catch (KafkaException e) {
            producer.abortTransaction();
}
```

消费者：
isolation.level=read_committed
表明 Consumer 只会读取事务型 Producer 成功提交事务写入的消息。当然了，它也能看到非事务型 Producer 写入的所有消息。

事务日志副本集等于Broker数量 transaction.state.log.replication.factor=3
transaction.state.log.min.isr=2

所有 Broker 都有各自的 Coordinator 组件,它驻留在 Broker 端的内存中，负责消费者组的组成员管理和各个消费者的位移提交管理(加入组、等待组分配方案、心跳请求处理、位移获取、位移提交等。)
Consumer 端应用程序在提交位移时，其实是向 Coordinator 所在的 Broker 提交位移。同样地，当 Consumer 应用启动时，也是向 Coordinator 所在的 Broker 发送各种请求，然后由 Coordinator 负责执行消费者组的注册、成员管理记录等元数据管理操作。

每个Kafka集群都只有一个位移主题  
位移主题的 Key 中应该保存 3 部分内容：<Group ID，主题名，分区号 >

Kafka 提供了专门的后台线程定期地巡检待 Compact 的主题，看看是否存在满足条件的可删除数据。这个后台线程叫 Log Cleaner。  
同一个group下的所有消费者提交的位移数据保存在位移主题的同一个分区下

log cleaner线程挂掉之后会导致磁盘上位移主题的文件越来越多（当然，大部分是过期数据，只是依旧存在），broker内存中会维护offsetMap，从名字上看这个map就是维护消费进度的，而这个map和位移主题的文件有关联，文件越来越多会导致offsetMap越来越大，甚至导致offsetMap构建失败（为什么会失败没有搞明白），offsetMap构建失败之后broker不会承认自己是coordinator。    

消费者组找coordinator的逻辑很简单：  
partitionId=Math.abs(groupId.hashCode() % offsetsTopicPartitionCount)  
第 2 步：找出该分区 Leader 副本所在的 Broker，该 Broker 即为对应的 Coordinator。 

一旦这个broker的offsetMap构建失败，那么这个broker就不承认自己是这个group的coordinate，这个group的消费就无法继续进行，会出现Marking Coordinator Dead错误。  
此时需要删除过期的位移主题的文件（根据文件名很容易确定哪个是最新的），重启broker。重启过程中需要关注log cleaner是否会再次挂掉。  

PS：上述问题在broker重启和正常运行中都有可能遇到。

自动提交就是在poll方法调用过程中执行的，如果设置了5秒，表示至少5秒提交一次  
commitSync 支持自动错误重试。  
异步提交的重试其实没有意义，所以 commitAsync 是不会重试的(提交的是poll后的最新位移，跟遍历无关)



增加期望的时间间隔 max.poll.interval.ms 参数值。  
减少 poll 方法一次性返回的消息数量，即减少 max.poll.records 参数值。

Pull的模式不足之处是如果kafka没有数据，消费者可能会陷入死循环，一直返回空数据，针对这一点，kafka的消费者在消费数据时候回传递一个timeout参数，如果当时没有数据可供消费，消费者会等待一段时间在返回

Range：是按照单个topic来划分的，默认的分配方式

同一个broker机器的不同分区可以复用一个socket,同一个消费组的客户端都只会连接到一个协调者


使用Kafka默认提供 的JMX监控指标来监控消费者的Lag值。
（1）Kafka消费者提供了一个名为Kafka.consumer:type=consumer-fetch-manager-metrics，client-id=”{client-id}”的JMX指标。
（2）有两个重要的属性：records-lag-max 和 records-lead-min 分别表示消费者在测试窗口时间内曾经达到的最大的Lag值和最小的Lead值。
（3）Lead值是指消费者最新消费消息的位移和分区当前第一条消息的位移的差值。即：Lag越大，Lead就越小。
这个JMX是在整个consumer级别上统计，而不是在单个topic或topic分区上统计。records-lag-max即记录所有订阅分区上最大的lag。lead也是同理

 kafka broker jmx 端口9999

 Kafka集群中有一个broker会被选举为controller，负责管理集群broker的上下线，所有的topic的分区副本分配和leader选举等工作



 Kafka在启动的时候会开启两个任务，一个任务用来定期地检查是否需要缩减或者扩大ISR集合，这个周期是replica.lag.time.max.ms的一半，默认5000ms。当检测到ISR集合中有失效副本时，就会收缩ISR集合，当检查到有Follower的HighWatermark追赶上Leader时，就会扩充ISR

 除此之外，当ISR集合发生变更的时候还会将变更后的记录缓存到isrChangeSet中，另外一个任务会周期性地检查这个Set,如果发现这个Set中有ISR集合的变更记录，那么它会在zk中持久化一个节点。然后因为controller在这个节点的路径上注册了一个Watcher，所以它就能够感知到ISR的变化，并向它所管理的broker发送更新元数据的请求。最后删除该路径下已经处理过的节点。

# springboot集成的spring-kafka,构建消费工厂之后,通过kafkaListener注解实现持续监听的效果,等同于while(true)的poll效果
https://leejay.top/posts/kafka%E5%BA%8F%E5%88%97%E5%8C%96%E5%92%8C%E5%8F%8D%E5%BA%8F%E5%88%97%E5%8C%96-protoBuf/

## kafka server config

```sh
advertised.host.name = null
        advertised.listeners = null
        advertised.port = null
        alter.config.policy.class.name = null
        alter.log.dirs.replication.quota.window.num = 11
        alter.log.dirs.replication.quota.window.size.seconds = 1
        authorizer.class.name = 
        auto.create.topics.enable = true
        auto.leader.rebalance.enable = true
        background.threads = 10
        broker.id = 0
        broker.id.generation.enable = true
        broker.rack = null
        client.quota.callback.class = null
        compression.type = producer
        connections.max.idle.ms = 600000
        controlled.shutdown.enable = true
        controlled.shutdown.max.retries = 3
        controlled.shutdown.retry.backoff.ms = 5000
        controller.socket.timeout.ms = 30000
        create.topic.policy.class.name = null
        default.replication.factor = 1
        delegation.token.expiry.check.interval.ms = 3600000
        delegation.token.expiry.time.ms = 86400000
        delegation.token.master.key = null
        delegation.token.max.lifetime.ms = 604800000
        delete.records.purgatory.purge.interval.requests = 1
        delete.topic.enable = true
        fetch.purgatory.purge.interval.requests = 1000
        group.initial.rebalance.delay.ms = 0
        group.max.session.timeout.ms = 300000
        group.min.session.timeout.ms = 6000
        host.name = 
        inter.broker.listener.name = null
        inter.broker.protocol.version = 2.0-IV1
        leader.imbalance.check.interval.seconds = 300
        leader.imbalance.per.broker.percentage = 10
        listener.security.protocol.map = PLAINTEXT:PLAINTEXT,SSL:SSL,SASL_PLAINTEXT:SASL_PLAINTEXT,SASL_SSL:SASL_SSL
        listeners = null
        log.cleaner.backoff.ms = 15000
        log.cleaner.dedupe.buffer.size = 134217728
        log.cleaner.delete.retention.ms = 86400000
        log.cleaner.enable = true
        log.cleaner.io.buffer.load.factor = 0.9
        log.cleaner.io.buffer.size = 524288
        log.cleaner.io.max.bytes.per.second = 1.7976931348623157E308
        log.cleaner.min.cleanable.ratio = 0.5
        log.cleaner.min.compaction.lag.ms = 0
        log.cleaner.threads = 1
        log.cleanup.policy = [delete]
        log.dir = /tmp/kafka-logs
        log.dirs = /home/pmz/kafka-logs
        log.flush.interval.messages = 9223372036854775807
        log.flush.interval.ms = null
        log.flush.offset.checkpoint.interval.ms = 60000
        log.flush.scheduler.interval.ms = 9223372036854775807
        log.flush.start.offset.checkpoint.interval.ms = 60000
        log.index.interval.bytes = 4096
        log.index.size.max.bytes = 10485760
        log.message.downconversion.enable = true
        log.message.format.version = 2.0-IV1
        log.message.timestamp.difference.max.ms = 9223372036854775807
        log.message.timestamp.type = CreateTime
        log.preallocate = false
        log.retention.bytes = -1
        log.retention.check.interval.ms = 300000
        log.retention.hours = 168
        log.retention.minutes = null
        log.retention.ms = null
        log.roll.hours = 168
        log.roll.jitter.hours = 0
        log.roll.jitter.ms = null
        log.roll.ms = null
        log.segment.bytes = 1073741824
        log.segment.delete.delay.ms = 60000
        max.connections.per.ip = 2147483647
        max.connections.per.ip.overrides = 
        max.incremental.fetch.session.cache.slots = 1000
        message.max.bytes = 1000012
        metric.reporters = []
        metrics.num.samples = 2
        metrics.recording.level = INFO
        metrics.sample.window.ms = 30000
        min.insync.replicas = 1
        num.io.threads = 8
        num.network.threads = 3
        num.partitions = 1
        num.recovery.threads.per.data.dir = 1
        num.replica.alter.log.dirs.threads = null
        num.replica.fetchers = 1
        offset.metadata.max.bytes = 4096
        offsets.commit.required.acks = -1
        offsets.commit.timeout.ms = 5000
        offsets.load.buffer.size = 5242880
        offsets.retention.check.interval.ms = 600000
        offsets.retention.minutes = 10080
        offsets.topic.compression.codec = 0
        offsets.topic.num.partitions = 50
        offsets.topic.replication.factor = 1
        offsets.topic.segment.bytes = 104857600
        password.encoder.cipher.algorithm = AES/CBC/PKCS5Padding
        password.encoder.iterations = 4096
        password.encoder.key.length = 128
        password.encoder.keyfactory.algorithm = null
        password.encoder.old.secret = null
        password.encoder.secret = null
        port = 9092
        principal.builder.class = null
        producer.purgatory.purge.interval.requests = 1000
        queued.max.request.bytes = -1
        queued.max.requests = 500
        quota.consumer.default = 9223372036854775807
        quota.producer.default = 9223372036854775807
        quota.window.num = 11
        quota.window.size.seconds = 1
        replica.fetch.backoff.ms = 1000
        replica.fetch.max.bytes = 1048576
        replica.fetch.min.bytes = 1
        replica.fetch.response.max.bytes = 10485760
        replica.fetch.wait.max.ms = 500
        replica.high.watermark.checkpoint.interval.ms = 5000
        replica.lag.time.max.ms = 10000
        replica.socket.receive.buffer.bytes = 65536
        replica.socket.timeout.ms = 30000
        replication.quota.window.num = 11
        replication.quota.window.size.seconds = 1
        request.timeout.ms = 30000
        reserved.broker.max.id = 1000
        sasl.client.callback.handler.class = null
        sasl.enabled.mechanisms = [GSSAPI]
        sasl.jaas.config = null
        sasl.kerberos.kinit.cmd = /usr/bin/kinit
        sasl.kerberos.min.time.before.relogin = 60000
        sasl.kerberos.principal.to.local.rules = [DEFAULT]
        sasl.kerberos.service.name = null
        sasl.kerberos.ticket.renew.jitter = 0.05
        sasl.kerberos.ticket.renew.window.factor = 0.8
        sasl.login.callback.handler.class = null
        sasl.login.class = null
        sasl.login.refresh.buffer.seconds = 300
        sasl.login.refresh.min.period.seconds = 60
        sasl.login.refresh.window.factor = 0.8
        sasl.login.refresh.window.jitter = 0.05
        sasl.mechanism.inter.broker.protocol = GSSAPI
        sasl.server.callback.handler.class = null
        security.inter.broker.protocol = PLAINTEXT
        socket.receive.buffer.bytes = 102400
        socket.request.max.bytes = 104857600
        socket.send.buffer.bytes = 102400
        ssl.cipher.suites = []
        ssl.client.auth = none
        ssl.enabled.protocols = [TLSv1.2, TLSv1.1, TLSv1]
        ssl.endpoint.identification.algorithm = https
        ssl.key.password = null
        ssl.keymanager.algorithm = SunX509
        ssl.keystore.location = null
        ssl.keystore.password = null
        ssl.keystore.type = JKS
        ssl.protocol = TLS
        ssl.provider = null
        ssl.secure.random.implementation = null
        ssl.trustmanager.algorithm = PKIX
        ssl.truststore.location = null
        ssl.truststore.password = null
        ssl.truststore.type = JKS
        transaction.abort.timed.out.transaction.cleanup.interval.ms = 60000
        transaction.max.timeout.ms = 900000
        transaction.remove.expired.transaction.cleanup.interval.ms = 3600000
        transaction.state.log.load.buffer.size = 5242880
        transaction.state.log.min.isr = 1
        transaction.state.log.num.partitions = 50
        transaction.state.log.replication.factor = 1
        transaction.state.log.segment.bytes = 104857600
        transactional.id.expiration.ms = 604800000
        unclean.leader.election.enable = false
        zookeeper.connect = localhost:2181,localhost:2182,localhost:2183
        zookeeper.connection.timeout.ms = 6000
        zookeeper.max.in.flight.requests = 10
        zookeeper.session.timeout.ms = 6000
        zookeeper.set.acl = false
        zookeeper.sync.time.ms = 2000
 (kafka.server.KafkaConfig)
```

## 安全
* 简单认证与安全层(SASL) 

是一个在网络协议中用来认证和数据加密的构架。 它把认证机制从程序中分离开, 理论上使用SASL的程序协议都可以使用SASL所支持的全部认证机制。 认证机制可支持代理认证, 这让一个用户可以承担另一个用户的认证。 SASL同样提供数据安全层，这提供了数据完整验证和数据加密。
https://zh.wikipedia.org/wiki/%E7%AE%80%E5%8D%95%E8%AE%A4%E8%AF%81%E4%B8%8E%E5%AE%89%E5%85%A8%E5%B1%82
```sh
In release 0.9.0.0, the Kafka community added a number of features that, used either separately or together, increases security in a Kafka cluster. The following security measures are currently supported:
Authentication of connections to brokers from clients (producers and consumers), other brokers and tools, using either SSL or SASL. Kafka supports the following SASL mechanisms:
SASL/GSSAPI (Kerberos) - starting at version 0.9.0.0
SASL/PLAIN - starting at version 0.10.0.0
SASL/SCRAM-SHA-256 and SASL/SCRAM-SHA-512 - starting at version 0.10.2.0
SASL/OAUTHBEARER - starting at version 2.0
Authentication of connections from brokers to ZooKeeper
Encryption of data transferred between brokers and clients, between brokers, or between brokers and tools using SSL (Note that there is a performance degradation when SSL is enabled, the magnitude of which depends on the CPU type and the JVM implementation.)
Authorization of read / write operations by clients
Authorization is pluggable and integration with external authorization services is supported
It's worth noting that security is optional - non-secured clusters are supported, as well as a mix of authenticated, unauthenticated, encrypted and non-encrypted clients. The guides below explain how to configure and use the security features in both clients and brokers
```

# Kafka 认证添加
## 服务端设置
```sh
一.broker 配置  
在kafka 安装目录的 config 下创建 kafka_server_jaas.conf
内容是：
KafkaServer {
       org.apache.kafka.common.security.plain.PlainLoginModule required
       username="admin"
       password="admin-secret"
       user_admin="admin-secret"
       user_alice="alice-secret";
};
说明：username和password是broker之间建立连接使用。user_用户=”密码”，定义了clinet和broker通信的用户名和密码。
2.修改kafka-server-start.sh，将-Djava.security.auth.login.config=*/kafka_server_jaas.conf添加到启动命令。

exec $base_dir/kafka-run-class.sh $EXTRA_ARGS -Djava.security.auth.login.config=安装目录/config/kafka_server_jaas.conf kafka.Kafka "$@"

3.修改 server.properties
listeners=SASL_PLAINTEXT://hostname:9092
security.inter.broker.protocol=SASL_PLAINTEXT
sasl.mechanism.inter.broker.protocol=PLAIN
sasl.enabled.mechanisms=PLAIN

### 客户端设置
1.在kafka 安装目录的 config 下创建 kafka_client_jaas.conf
内容：
KafkaClient {
org.apache.kafka.common.security.plain.PlainLoginModule required
username="alice"
password="alice-secret";
};
说明：当前的 username 和 password 与之前的设置需保持相同。

2.生产者配置（config/producer.properties）和消费者配置（consumer.properties）添加参数
在配置文件中添加：

~~~
security.protocol=SASL_PLAINTEXT
sasl.mechanism=PLAIN
~~~

在使用命令行进行生产和消费的时候需要添加该配置（生产者使用 --producer.config config/producer.properties，消费添加 --consumer.config config/consumer.properties）


3.修改使用脚本：bin/kafka-console-producer.sh 和 bin/kafka-console-consumer.sh
添加 export KAFKA_OPTS="-Djava.security.auth.login.config=安装目录/config/kafka_client_jaas.conf"

修改之后：
![](kafka 认证添加客户端修改之后.png)

4.验证
验证条件：kafka 已正确启动

~~~
使用该命令进行生产：
bin/kafka-console-producer.sh --broker-list ip:9092 --topic message_down_queue_topic --producer.config config/producer.properties
使用该命令进行消费：
bin/kafka-console-consumer.sh --bootstrap-server ip:9092 --topic message_down_queue_topic --consumer.config config/consumer.properties
~~~
```

## swarm
### http://wurstmeister.github.io/kafka-docker/
```yml
version: '3.2'
services:
  zookeeper:
    image: wurstmeister/zookeeper:latest
    ports:
      - "2181:2181"
    volumes:
      - zk_data_1:/data
      - zk_dataLog_1:/datalog
    networks:
      - kafka-net

  kafka:
    image: wurstmeister/kafka:latest
    ports:
      - target: 9094
        published: 9094
        protocol: tcp
        mode: host
    environment:
      HOSTNAME_COMMAND: "docker info | grep ^Name: | cut -d' ' -f 2"
      # BROKER_ID_COMMAND: "hostname | awk -F'-' '{print $$2}'"
      KAFKA_ZOOKEEPER_CONNECT: zookeeper:2181
      KAFKA_LISTENER_SECURITY_PROTOCOL_MAP: INSIDE:PLAINTEXT,OUTSIDE:PLAINTEXT
      KAFKA_ADVERTISED_LISTENERS: INSIDE://:9092,OUTSIDE://_{HOSTNAME_COMMAND}:9094
      KAFKA_LISTENERS: INSIDE://:9092,OUTSIDE://:9094
      KAFKA_INTER_BROKER_LISTENER_NAME: INSIDE
      KAFKA_LOG_DIRS: "/kafka/kafka-logs-_{HOSTNAME_COMMAND}"
    depends_on:
      - zookeeper  
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
      - kafka_logs_1:/kafka
    networks:
      - kafka-net

volumes:
  kafka_logs_1:
  zk_data_1:
  zk_dataLog_1:

networks:
    kafka-net:

kafka1:
    image: wurstmeister/kafka
    restart: always
    hostname: kafka1
    container_name: kafka1
    ports:
    - "9092:9092"
    environment:
      KAFKA_ADVERTISED_LISTENERS: PLAINTEXT://192.168.205.235:9092
      KAFKA_ADVERTISED_HOST_NAME: 192.168.56.101
      KAFKA_ADVERTISED_PORT: 9092
      KAFKA_ZOOKEEPER_CONNECT: zoo1:2181,zoo2:2181,zoo3:2181
    volumes:
    - kafka_logs_1:/kafka
   
   
  kafka2:
    image: wurstmeister/kafka
    restart: always
    hostname: kafka2
    container_name: kafka2
    ports:
    - "9093:9092"
    environment:
      KAFKA_ADVERTISED_LISTENERS: PLAINTEXT://192.168.205.235:9093 
      KAFKA_ADVERTISED_HOST_NAME: 192.168.205.235
      KAFKA_ADVERTISED_PORT: 9093
      KAFKA_ZOOKEEPER_CONNECT: zoo1:2181,zoo2:2181,zoo3:2181
    volumes:
    - kafka_logs_2:/kafka


  kafka3:
    image: wurstmeister/kafka
    restart: always
    hostname: kafka3
    container_name: kafka3
    ports:
    - "9094:9092"
    environment:
      KAFKA_ADVERTISED_LISTENERS: PLAINTEXT://192.168.205.235:9094
      KAFKA_ADVERTISED_HOST_NAME: 192.168.205.235
      KAFKA_ADVERTISED_PORT: 9094
      KAFKA_ZOOKEEPER_CONNECT: zoo1:2181,zoo2:2181,zoo3:2181
    volumes:
    - kafka_logs_3:/kafka

volumes:
  kafka_logs_1:
  kafka_logs_2:
  kafka_logs_3:
```




# kafka-eagle

ke.sh [start|status|stop|restart|stats]  
Account:admin ,Password:123456  
http://127.0.0.1:8048/
```sh
cd ${KE_HOME}/conf
vi system-config.properties

# Multi zookeeper&kafka cluster list -- The client connection address of the Zookeeper cluster is set here
kafka.eagle.zk.cluster.alias=cluster1,cluster2
cluster1.zk.list=tdn1:2181,tdn2:2181,tdn3:2181
cluster2.zk.list=xdn1:2181,xdn2:2181,xdn3:2181

# Add zookeeper acl
cluster1.zk.acl.enable=false
cluster1.zk.acl.schema=digest
cluster1.zk.acl.username=test
cluster1.zk.acl.password=test123

# Kafka broker nodes online list
cluster1.kafka.eagle.broker.size=10
cluster2.kafka.eagle.broker.size=20

# Zkcli limit -- Zookeeper cluster allows the number of clients to connect to
kafka.zk.limit.size=25

# Kafka Eagle webui port -- WebConsole port access address
kafka.eagle.webui.port=8048

# Kafka offset storage -- Offset stored in a Kafka cluster, if stored in the zookeeper, you can not use this option
cluster1.kafka.eagle.offset.storage=kafka
cluster2.kafka.eagle.offset.storage=kafka

# Whether the Kafka performance monitoring diagram is enabled
kafka.eagle.metrics.charts=false

# Kafka Eagle keeps data for 30 days by default
kafka.eagle.metrics.retain=30

# If offset is out of range occurs, enable this property -- Only suitable for kafka sql
kafka.eagle.sql.fix.error=false
kafka.eagle.sql.topic.records.max=5000

# Delete kafka topic token -- Set to delete the topic token, so that administrators can have the right to delete
kafka.eagle.topic.token=keadmin

# Kafka sasl authenticate
cluster1.kafka.eagle.sasl.enable=false
cluster1.kafka.eagle.sasl.protocol=SASL_PLAINTEXT
cluster1.kafka.eagle.sasl.mechanism=SCRAM-SHA-256
cluster1.kafka.eagle.sasl.jaas.config=org.apache.kafka.common.security.scram.ScramLoginModule required username="admin" password="admin-secret";
# If not set, the value can be empty
cluster1.kafka.eagle.sasl.client.id=
# Add kafka cluster cgroups
cluster1.kafka.eagle.sasl.cgroup.enable=false
cluster1.kafka.eagle.sasl.cgroup.topics=kafka_ads01,kafka_ads02

cluster2.kafka.eagle.sasl.enable=true
cluster2.kafka.eagle.sasl.protocol=SASL_PLAINTEXT
cluster2.kafka.eagle.sasl.mechanism=PLAIN
cluster2.kafka.eagle.sasl.jaas.config=org.apache.kafka.common.security.plain.PlainLoginModule required username="admin" password="admin-secret";
cluster2.kafka.eagle.sasl.client.id=
cluster2.kafka.eagle.sasl.cgroup.enable=false
cluster2.kafka.eagle.sasl.cgroup.topics=kafka_ads03,kafka_ads04

# Default use sqlite to store data
kafka.eagle.driver=org.sqlite.JDBC
# It is important to note that the '/hadoop/kafka-eagle/db' path must be exist.
kafka.eagle.url=jdbc:sqlite:/hadoop/kafka-eagle/db/ke.db
kafka.eagle.username=root
kafka.eagle.password=smartloli

# (Optional) set mysql address
#kafka.eagle.driver=com.mysql.jdbc.Driver
#kafka.eagle.url=jdbc:mysql://127.0.0.1:3306/ke?useUnicode=true&characterEncoding=UTF-8&zeroDateTimeBehavior=convertToNull
#kafka.eagle.username=root
#kafka.eagle.password=smartloli
```