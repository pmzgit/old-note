# 概述
https://spark.apache.org/docs/latest/index.html

http://spark.apache.org/downloads.html

## [submitting-applications](http://spark.apache.org/docs/latest/submitting-applications.html)

### spark-shell
You can also run Spark interactively through a modified version of the Scala shell. This is a great way to learn the framework.

./bin/spark-shell --master local[2]

The --master option specifies the master URL for a distributed cluster, or local to run locally with one thread, or local[N] to run locally with N threads. You should start by using local for testing. For a full list of options, run Spark shell with the --help option. 

Spark Shell中已经默认将SparkContext类初始化为对象sc。用户代码如果需要用到，则直接应用sc即可

Spark Shell中已经默认将SparkSQl类初始化为对象spark。用户代码如果需要用到，则直接应用spark即可

### deploy-mode

是针对集群而言的，是指集群部署的模式，根据Driver主进程放在哪分为两种方式：client和cluster，默认是client

明白几个基本概念：Master节点就是你用来提交任务，即执行bin/spark-submit命令所在的那个节点；Driver进程就是开始执行你Spark程序的那个Main函数，但注意Driver进程不一定在Master节点上，它可以在任何节点；Worker就是Slave节点，Executor进程必然在Worker节点上，用来进行实际的计算
* client mode

1、client mode下Driver进程运行在Master节点上，不在Worker节点上，所以相对于参与实际计算的Worker集群而言，Driver就相当于是一个第三方的“client”

2、正由于Driver进程不在Worker节点上，所以其是独立的，不会消耗Worker集群的资源

3、client mode下Master和Worker节点必须处于同一片局域网内，因为Driver要和Executorr通信，例如Drive需要将Jar包通过Netty HTTP分发到Executor，Driver要给Executor分配任务等

4、client mode下没有监督重启机制，Driver进程如果挂了，需要额外的程序重启
* cluster mode

1、Driver程序在worker集群中某个节点，而非Master节点，但是这个节点由Master指定

2、Driver程序占据Worker的资源

3、cluster mode下Master可以使用–supervise对Driver进行监控，如果Driver挂了可以自动重启

4、cluster mode下Master节点和Worker节点一般不在同一局域网，因此就无法将Jar包分发到各个Worker，所以cluster mode要求必须提前把Jar包放到各个Worker几点对应的目录下面
* 选择

如果提交任务的节点（即Master）和Worker集群在同一个网络内，此时client mode比较合适

如果提交任务的节点和Worker集群相隔比较远，就会采用cluster mode来最小化Driver和Executor之间的网络延迟

如果是local[*]，则代表 Run Spark locally with as many worker threads as logical cores on your machine.
```sh

./bin/spark-submit \
  --class <main-class> \
  --master <master-url> \
  --deploy-mode <deploy-mode> \
  --conf <key>=<value> \
  ... # other options
  <application-jar> \
  [application-arguments]


  Some of the commonly used options are:

--class: The entry point for your application (e.g. org.apache.spark.examples.SparkPi)
--master: The master URL for the cluster (e.g. spark://23.195.26.187:7077)
--deploy-mode: Whether to deploy your driver on the worker nodes (cluster) or locally as an external client (client) (default: client) †
--conf: Arbitrary Spark configuration property in key=value format. For values that contain spaces wrap “key=value” in quotes (as shown).
application-jar: Path to a bundled jar including your application and all dependencies. The URL must be globally visible inside of your cluster, for instance, an hdfs:// path or a file:// path that is present on all nodes.
application-arguments: Arguments passed to the main method of your main class, if any

# Run application locally on 8 cores
./bin/spark-submit \
  --class org.apache.spark.examples.SparkPi \
  --master local[8] \
  /path/to/examples.jar \
  100

# Run on a Spark standalone cluster in client deploy mode
./bin/spark-submit \
  --class org.apache.spark.examples.SparkPi \
  --master spark://207.184.161.138:7077 \
  --executor-memory 20G \
  --total-executor-cores 100 \
  /path/to/examples.jar \
  1000

# Run on a Spark standalone cluster in cluster deploy mode with supervise
./bin/spark-submit \
  --class org.apache.spark.examples.SparkPi \
  --master spark://207.184.161.138:7077 \
  --deploy-mode cluster \
  --supervise \
  --executor-memory 20G \
  --total-executor-cores 100 \
  /path/to/examples.jar \
  1000

# Run on a YARN cluster
export HADOOP_CONF_DIR=XXX
./bin/spark-submit \
  --class org.apache.spark.examples.SparkPi \
  --master yarn \
  --deploy-mode cluster \  # can be client for client mode
  --executor-memory 20G \
  --num-executors 50 \
  /path/to/examples.jar \
  1000

# Connect to a YARN cluster in client or cluster mode depending on the value of --deploy-mode. The cluster location will be found based on the HADOOP_CONF_DIR or YARN_CONF_DIR variable.

# Run a Python application on a Spark standalone cluster
./bin/spark-submit \
  --master spark://207.184.161.138:7077 \
  examples/src/main/python/pi.py \
  1000
```
spark-submit 和 spark-submit --master local 效果是一样的
（同理：spark-shell 和 spark-shell --master local 效果是一样的）
spark-submit --master local[4] 代表会有4个线程（每个线程一个core）来并发执行应用程序。

启动了spark的local模式，该模式仅在本机启动一个进程，没有与集群建立联系。这个SparkSubmit进程又当爹、又当妈，既是客户提交任务的Client进程、又是Spark的driver程序、还充当着Spark执行Task的Executor角色。（如下图所示：driver的web ui）

先在spark-env.sh 增加SPARK_HISTORY_OPTS；
然后启动sbin/start-history-server.sh服务；
就可以看到启动了HistoryServer进程，且监听端口是18080。
之后就可以在web上使用http://hostname:18080愉快的玩耍了。



* [uberjar](https://www.cnblogs.com/oldtrafford/p/6901149.html)


# [spark-standalone](http://spark.apache.org/docs/latest/spark-standalone.html)

*  If conf/slaves does not exist, the launch scripts defaults to a single machine (localhost), which is useful for testing. Note, the master machine accesses each of the worker machines via ssh. 

```sh
SPARK_HOME/sbin:

sbin/start-master.sh - Starts a master instance on the machine the script is executed on.
sbin/start-slaves.sh - Starts a slave instance on each machine specified in the conf/slaves file.
sbin/start-slave.sh - Starts a slave instance on the machine the script is executed on.
sbin/start-all.sh - Starts both a master and a number of slaves as described above.
sbin/stop-master.sh - Stops the master that was started via the sbin/start-master.sh script.
sbin/stop-slaves.sh - Stops all slave instances on the machines specified in the conf/slaves file.
sbin/stop-all.sh - Stops both the master and the slaves as described above.
#spark-defaults.conf

# Example:
# spark.master                     spark://master:7077
# spark.eventLog.enabled           true
# spark.eventLog.dir               hdfs://mycluster/directory
# spark.serializer                 org.apache.spark.serializer.KryoSerializer
# spark.driver.memory              1g
# spark.executor.extraJavaOptions  -XX:+PrintGCDetails -Dkey=value -Dnumbers="one two three"

# conf/spark-env.sh
export SPARK_HOME=/home/hadoop/apps/spark
export PATH=$PATH:$SPARK_HOME/bin

export JAVA_HOME=/usr/local/jdk1.8.0_73
export SCALA_HOME=/usr/share/scala-2.11.8
export HADOOP_HOME=/home/hadoop/apps/hadoop-2.7.5
export HADOOP_CONF_DIR=/home/hadoop/apps/hadoop-2.7.5/etc/hadoop
export SPARK_MASTER_HOST=hadoop1
export SPARK_MASTER_PORT=7077
export SPARK_MASTER_WEBUI_PORT=4040
export SPARK_LOCAL_DIRS=
export SPARK_DAEMON_MEMORY=1g
#值约为当前服务器内存的75%
export SPARK_WORKER_MEMORY=48g


## 启动
guard1 , guard2 节点执行:
./sbin/start-master.sh
在guard1, guard2, guard3: /home/dmp/spark/目录下 执行:
./sbin/start-slave.sh spark://guard1:7077
```
### test

./bin/run-example SparkPi 10 --master local[2]

./bin/spark-shell --master local[2]

./bin/pyspark --master local[2]

./bin/spark-submit examples/src/main/python/pi.py 10

### Yarn Client：适用于交互与调试
– Driver在任务提交机上执行  
– ApplicationMaster只负责向ResourceManager申请executor需要的资源  
– 基于yarn时，spark-shell和pyspark必须要使用yarn-client模式  
### Yarn Cluster vs. Yarn Client区别：
本质是AM进程的区别，cluster模式下，driver运行在AM中，负责向Yarn申请资源，并监督作业运行状况，当用户提交完作用后，就关掉Client，作业会继续在yarn上运行。然而cluster模式不适合交互类型的作业。而client模式，AM仅向yarn请求executor，client会和请求的container通信来调度任务，即client不能离开

### checkpoint（检查点）
是很多分布式系统为了容灾容错引入的机制，其实质是将系统运行时的内存数据结构和状态持久化到磁盘上，在需要的时候通过读取这些数据，重新构造出之前的运行时状态。

Spark中使用检查点来将RDD的执行状态保存下来，在作业失败重试的时候，从检查点中恢复之前已经运行成功的RDD结果，这样就会大大减少重新计算的成本，提高任务恢复效率和执行效率，节省Spark各个计算节点的资源。

## work
Executor有线程池多线程管理这些坑内的task
* Executor伴随整个app的生命周期
* 线程池模型，省去进程频繁启停的开销

Executor的内存分为3块 

• 第一块：让task执行代码时，默认占executor总内存的20%  
• 第二块：task通过shuffle过程拉取上一个stage的task的输出后，进行聚合等操作时使用，默认也是占20%  
• 第三块：让RDD持久化时使用，默认占executor总内存的60%

• Task的执行速度和每个executor进程的CPU Core数量有直接关系，一个CPU Core同一时间只能执行一个线程，每个executor进程上分配到的多个task，都是以task一条线程的方式，多线程并发运行的。如果CPU Core数量比较充足，而且分配到的task数量比较合理，那么可以比较快速和高效地执行完这些task线程

num-executors* numexecutors代表作业申请的总内存量（尽量不要超过最大总内存的1/3~1/2） – 建议：设置4G~8G较合适

executor-cores：每个executor进程的CPU Core数量，该参数决定每个executor进程并行执行task线程的能力，num-executors* executor-cores代表作业申请总CPU core数（不要超过总CPU Core的1/3~1/2 ）  
– 建议：设置2~4个较合适

driver-memory：设置Driver进程的内存
– 建议：通常不用设置，一般1G就够了，若出现使用collect算子将RDD数据全部拉取到Driver上处理，就必须确保该值足够大，否则OOM内存溢出  
### spark 参数
• spark.default.parallelism：每个stage的默认task数量
– 建议：设置500~1000较合适，默认一个HDFS的block对应一个task，Spark默认值偏少，这样导致不能充分利用资源  
• spark.storage.memoryFraction：设置RDD持久化数据在executor内存中能占的比例，默认0.6，即默认executor 60%的内存可以保存持久化RDD数据  
– 建议：若有较多的持久化操作，可以设置高些，超出内存的会频繁gc导致运行缓慢  
• spark.shuffle.memoryFraction：聚合操作占executor内存的比例，默认0.2  
– 建议：若持久化操作较少，但shuffle较多时，可以降低持久化内存占比，提高shuffle操作内存占比

spark.streaming.receiver.writeAheadLog.enable

### RDD
RDD 上定义的函数分两种，一种是转换（transformation）函数这种函数的返回值还是 RDD；Transformation 操作是延迟计算的，也就是说从一个RDD 转换生成另一个 RDD 的转换操作不是马上执行，可以理解为懒加载,需要等到有 Action 操作的时候才会真正触发运算。另一种是执行（action）函数，这种函数不再返回 RDD，这类算子会触发 SparkContext 提交 Job 作业,spark job的划分就是依据action算子,运行的计算后返回到 driver 程序

– 应用程序：由一个driver program和
多个job构成
– Job：由多个stage组成
– Stage：对应一个taskset
– Taskset：对应一组关联的相互之间没
有shuffle依赖关系的task组成
– Task：任务最小的工作单元

默认情况下，每次你在 RDD 运行一个 action 的时， 每个 transformed RDD 都会被重新计算。但是，您也可用 persist (或 cache) 方法将 RDD persist（持久化）到内存中；在这种情况下，Spark 为了下次查询时可以更快地访问，会把数据保存在集群上。此外，还支持持续持久化 RDDs 到磁盘，或复制到多个结点。配置持久化级别

* Pair RDD

虽然大部分Spark的RDD操作都支持所有种类的对象，但是有少部分特殊的操作只能作用于键值对类型的RDD。这类操作中最常见的就是分布的shuffle操作，比如将元素通过键来分组或聚集计算。在Python中，这类操作一般都会使用Python内建的元组类型，比如(1, 2)。生成的键值对的RDD称为PairRDD。

普通的RDD转化为一个pair RDD时可以使用map函数

Pair RDD可以使用所有标准RDD上的可用的转化操作。由于pair RDD包含的是二元组，所以需要传递的函数应当操作二元组而不是独立的元素。当然如果传递的函数不是操作二元组的话，有异常报出。

https://www.jianshu.com/p/f3aea4480f2b

* 重新分区  

https://www.cnblogs.com/qingyunzong/p/8987065.html
spark中两个常用的重分区算子,repartition 和 partitionBy 都是对数据进行重新分区，默认都是使用 HashPartitioner，区别在于partitionBy 只能用于 PairRdd，但是当它们同时都用于 PairRdd时,效果也是不一样的

reparation的分区结果比较的随意,没有什么规律,随机生成了一个key,而不是用原来的key。

而partitionBy把相同的key都分到了同一个分区，非key-value RDD分区，没必要设置分区器

分区是可配置的，只要RDD是基于键值对的即可。

RDD分区的一个分区原则：尽可能是得分区的个数等于集群核心数目，通过spark.default.parallelism来配置其默认分区个数，若没有设置该值，则根据不同的集群环境确定该值



从源码中可以看出repartition方法其实就是调用了coalesce方法,shuffle为true的情况(默认shuffle是fasle).现在假设RDD有X个分区,需要重新划分成Y个分区.

1.如果x<y,说明x个分区里有数据分布不均匀的情况,利用HashPartitioner把x个分区重新划分成了y个分区,此时,需要把shuffle设置成true才行,因为如果设置成false,不会进行shuffle操作,此时父RDD和子RDD之间是窄依赖,这时并不会增加RDD的分区.

2.如果x>y,需要先把x分区中的某些个分区合并成一个新的分区,然后最终合并成y个分区,此时,需要把coalesce方法的shuffle设置成false.

总结:如果想要增加分区的时候,可以用repartition或者coalesce,true都行,但是一定要有shuffle操作,分区数量才会增加,为了让该函数并行执行，通常把shuffle的值设置成true。

### DAG
父RDD的依赖关系（rddA=>rddB）   
– 宽依赖： B的每个partition依赖于A的所有partition
• 比如groupByKey、reduceByKey、join……，由A产生B时会先对A做shuffle分桶

– 窄依赖： B的每个partition依赖于A的常数个partition
• 比如map、filter、union

若一个stage包含的其他stage中的任务已经全部完成，这个stage中的任务才会被加入调度

如果此task失败，AM会重新分配task  
• 如果task依赖的上层partition数据已经失效了，会先将其依赖的partition计算任务再重算一遍

• 宽依赖中被依赖partition，可以将数据保存HDFS，以便快速重构（checkpoint） – 窄依赖只依赖上层一个partition，恢复代价较少；宽依赖依赖上层所有partition，如果数据丢失，上层所有partiton要重算

• 可以指定保存一个RDD的数据至节点的cache中，如果内存不够，会LRU释放一部分，仍有重构的可能

### broadcast
Spark actions are executed through a set of stages, separated by distributed “shuffle” operations. Spark automatically broadcasts the common data needed by tasks within each stage. The data broadcasted this way is cached in serialized form and deserialized before running each task. This means that explicitly creating broadcast variables is only useful when tasks across multiple stages need the same data or when caching the data in deserialized form is important.

val broadcastVar = sc.broadcast(Array(1, 2, 3))
broadcastVar.value


1,广播变量是一个只读变量,在driver端定义后,在excetors端只能读它的值,不能修改.

2,累加器在Driver端定义赋初始值,累加器只能在Driver端读取最后的值,在Excutor端更新.在driver端获取累计器值的时候需要一个action操作来触发,才能拿到值,并且累计器只能增加,不能减少.

3,无法从Spark Streaming中的检查点恢复累加器和广播变量。如果启用了检查点并使用 累加器或广播变量 ，则必须为累加器和广播变量创建延迟实例化的单例实例， 以便在驱动程序重新启动失败后重新实例化它们.


# SparkSql
https://www.cnblogs.com/qingyunzong/p/8987579.html
https://spark.apache.org/docs/latest/sql-programming-guide.html

如果用户直接运行bin/spark-sql命令。会导致我们的元数据有两种状态：

1、in-memory状态:

  如果SPARK-HOME/conf目录下没有放置hive-site.xml文件，元数据的状态就是in-memory

2、hive状态：

 如果我们在SPARK-HOME/conf目录下放置了，hive-site.xml文件，那么默认情况下

 spark-sql的元数据的状态就是hive.


bin/spark-sql\
--master spark://intsmaze:7077 \
--executor-memory 512m \
--total-executor-cores 3 \
--driver-class-path /home/intsmaze/mysql-connector-java-5.1.35-bin.jar

spark.sql.sources.default

### beeline
hive-site.xml


./sbin/start-thriftserver.sh --help

./sbin/start-thriftserver.sh --master yarn --deploy-mode client --driver-memory 16G --executor-memory 10G --num-executors 8 
--jars ~/software/mysql-connector-java-5.1.27-bin.jar  
--hiveconf hive.server2.thrift.port=14000

beeline -u jdbc:hive2://localhost:14000 -n hadoop

 !connect jdbc:hive2://localhost:10000

thriftserver和普通的spark-shell/spark-sql有什么区别？
1）spark-shell、spark-sql都是一个spark  application；
2）thriftserver， 不管你启动多少个客户端(beeline/开发环境code)，永远都是一个spark application
解决了一个数据共享的问题，多个客户端可以共享数据；

## catalog api

https://www.cnblogs.com/cc11001100/p/9463578.html

## 分区发现
请注意，分区列的数据类型是自动推断的。 目前，支持数字数据类型，日期，时间戳和字符串类型。 有时，用户可能不希望自动推断分区列的数据类型。 对于这些用例，可以通过spark.sql.sources.partitionColumnTypeInference.enabled配置自动类型推断，默认为true。 禁用类型推断时，字符串类型将用于分区列。 
从Spark 1.6.0开始，分区发现默认只查找给定路径下的分区。 对于上面的示例，如果用户将path/to/table/gender=male传递给SparkSession.read.parquet或SparkSession.read.load，则不会将性别视为分区列。 如果用户需要指定分区发现应该从哪个基本路径开始，则可以在数据源选项中设置basePath。 例如，当path/to/table/gender=male是数据的路径并且用户将basePath设置为path/to/table/时，gender将是分区列。

## [优化](http://spark.apache.org/docs/latest/tuning.html)

什么时候spark才会使用Map-side Join？
只有当要进行join的表的大小小于spark.sql.autoBroadcastJoinThreshold（默认是10M）的时候，才会进行mapjoin。

spark.sql.statistics.fallBackToHdfs=True
该参数能让spark直接读取hdfs的文件大小来判断一个表达大小，从而代替从metastore里面的获取的关于表的信息。这样spark自然能正确的判断出表的大小，从而使用b表来进行broadcast。

hint
在使用sql语句执行的时候在sql语句里面加上mapjoin的注释，也能够达到相应的效果，比如把上述的sql语句改成:

select /*+ BROADCAST (b) */ * from a where id not in (select id from b)
这样spark也会使用b表来进行broadcast。

* [kryo](https://www.jianshu.com/p/8ccd701490cf)
```scala
onf.set("spark.serializer", "org.apache.spark.serializer.KryoSerializer")
```
https://github.com/twitter/chill

* parquet

parquet的gzip的压缩比率最高，若不考虑备份可以达到27倍。可能这也是spar parquet默认采用gzip压缩的原因吧。  
分区过滤和列修剪可以帮助我们大幅节省磁盘IO。以减轻对服务器的压力。  
如果你的数据字段非常多，但实际应用中，每个业务仅读取其中少量字段，parquet将是一个非常好的选择。

https://blog.csdn.net/yu616568/article/details/50993491

* RDD，Dataframe，DataSet区别对比

http://xiaoyue26.github.io/2019/04/29/2019-04/spark%E4%B8%ADRDD%EF%BC%8CDataframe%EF%BC%8CDataSet%E5%8C%BA%E5%88%AB%E5%AF%B9%E6%AF%94/
# SparkStreaming
https://zhmin.github.io/2019/02/13/spark-streaming-receiver/
https://www.cnblogs.com/qingyunzong/p/9026429.html

1、我们在集群中的其中一台机器上提交我们的Application Jar，然后就会产生一个Application，开启一个Driver，然后初始化SparkStreaming的程序入口StreamingContext；

2、Master会为这个Application的运行分配资源，在集群中的一台或者多台Worker上面开启executor，executor会向Driver注册；

3、Driver服务器会发送多个receiver给开启的executor，（receiver是一个接收器，是用来接收消息的，在executor里面运行的时候，其实就相当于一个task任务）

4、receiver接收到数据后，每隔200ms就生成一个block块，就是一个rdd的分区，然后这些block块就存储在executor里面，block块的存储级别是Memory_And_Disk_2；

5、receiver产生了这些block块后会把这些block块的信息发送给StreamingContext；

6、StreamingContext接收到这些数据后，会根据一定的规则将这些产生的block块定义成一个rdd

### WAL
spark.streaming.driver.writeAheadLog.allowBatching=true
spark.streaming.receiver.writeAheadLog.enable=true

```scala
dstream.foreachRDD { (rdd, time) =>
  rdd.foreachPartition { partitionIterator =>
    val partitionId = TaskContext.get.partitionId()
    val uniqueId = generateUniqueId(time.milliseconds, partitionId)
    // use this uniqueId to transactionally commit the data in partitionIterator
  }
}
```

### sparkStreamingOffsetOnlyOnce
https://dongkelun.com/2018/06/20/sparkStreamingOffsetOnlyOnce/ 

### 反压
http://spark.apache.org/docs/latest/configuration.html#spark-streaming
spark.streaming.backpressure.pid.minRate
Backpressure 指的是在 Buffer 有上限的系统中，Buffer 溢出的现象；它的应对措施只有一个：丢弃新事件。

Backpressure 只是一种现象，而不是一种机制；