# 分布式系统
– 一致性问题  
– 容灾容错  
– 执行顺序问题  
– 事务性问题  

# zookeeper
* [ZooKeeper 概念](https://juejin.im/post/5b970f1c5188255c865e00e7#heading-15)
* [详解分布式协调服务 ZooKeeper](https://draveness.me/zookeeper-chubby)

* 客户端使用 Zookeeper 时会连接到集群中的任意节点，所有的节点都能够直接对外提供读操作，但是写操作都会被从节点路由到主节点，由主节点进行处理。

* Zookeeper 在设计上提供了以下的两个基本的顺序保证，线性写和先进先出的客户端顺序。每个更新请求，都会分配一个全局唯一的递增编号，这个编号反应了所有事务操作的先后顺序，应用程序可以使用 ZooKeeper 这个特性来实现更高层次的同步原语。 这个编号也叫做时间戳——zxid（Zookeeper Transaction Id）

* 原子性： 所有事务请求的处理结果在整个集群中所有机器上的应用情况是一致的，也就是说，要么整个集群中所有的机器都成功应用了某一个事务，要么都没有应用。

* 单一系统映像 ： 无论客户端连到哪一个 ZooKeeper 服务器上，其看到的服务端数据模型都是一致的。

* 可靠性： 一旦一次更改请求被应用，更改的结果就会被持久化，直到被下一次更改覆盖。某个连接异常断开了，客户端可以连接到另外的机器上。

* ZooKeeper数据保存在内存中，这意味着ZooKeeper可以实现高吞吐量和低延迟

* ZooKeeper 底层其实只提供了两个功能：①管理（存储、读取）用户程序提交的数据；②为用户程序提交数据节点监听服务。

* Zookeeper 原子广播协议，它能够在发生崩溃时快速恢复服务，达到高可用性。两者的主要区别就在于 Zab 主要是为构建高可用的主备系统设计的，而 Paxos 能够帮助工程师搭建具有一致性的状态机系统。

作为一个一致性状态机系统，它能够保证集群中任意一个状态机副本都按照客户端的请求执行了相同顺序的请求，即使来自客户端请求是异步的并且不同客户端的接收同一个请求的顺序不同，集群中的这些副本就是会使用 Paxos 或者它的变种对提案达成一致；在集群运行的过程中，如果主节点出现了错误导致宕机，其他的节点会重新开始进行选举并处理未提交的请求。  
但是在类似 Zookeeper 的高可用主备系统中，所有的副本都需要对增量的状态更新顺序达成一致，这些状态更新的变量都是由主节点创建并发送给其他的从节点的，每一个从节点都会严格按照顺序逐一的执行主节点生成的状态更新请求，如果 Zookeeper 集群中的主节点发生了宕机，新的主节点也必须严格按照顺序对请求进行恢复。  
总的来说，使用状态更新节点数据的主备系统相比根据客户端请求改变状态的状态机系统对于请求的执行顺序有着更严格的要求。  

* 客户端在使用 Zookeeper 服务时会随机连接到集群中的一个节点，所有的读请求都会由当前节点处理，而写请求会被路由给主节点并由主节点向其他节点广播事务，与 2PC 非常相似，如果在所有的节点中超过一半都返回成功，那么当前写请求就会被提交

* ZAB协议包括两种基本的模式，分别是 崩溃恢复和消息广播。当主节点崩溃时，其他的 Replica 节点会进入崩溃恢复模式并重新进行选举，Zab 协议必须确保提交已经被 Leader 提交的事务提案，同时舍弃被跳过的提案，这也就是说当前集群中最新 ZXID 最大的服务器会被选举成为 Leader 节点，同时集群中已经有过半的机器与该Leader服务器完成了状态同步之后，ZAB协议就会退出恢复模式；但是在正式对外提供服务之前，新的 Leader 也需要先与 Follower 中的数据进行同步，确保所有节点拥有完全相同的提案列表。Follower 和  Observer 都只能提供读服务。Follower 和  Observer 唯一的区别在于 Observer 机器不参与 Leader 的选举过程，也不参与写操作的“过半写成功”策略，因此 Observer 机器可以在不影响写性能的情况下提升集群的读性能。

* ZooKeeper 系统的多台服务器存储相同数据，zk集群的性能随着数量增加而下降


* scheme:id:permissions，第一个字段表示采用哪一种机制，第二个id表示用户，permissions表示相关权限（如只读，读写，管理等）
* Stat setACL(String path, List<ACL> acl, int version)  
给某个目录节点重新设置访问权限，需要注意的是 Zookeeper 中的目录节点权限不具有传递性，父目录节点的权限不能传递给子目录节点。目录节点 ACL 由两部分组成：perms 和id。 Perms 有 ALL、READ、WRITE、CREATE、DELETE、ADMIN 几种 而 id 标识了访问目录节点的身份列表，默认情况下有以下两种： ANYONE_ID_UNSAFE = new Id("world", "anyone") 和 AUTH_IDS = new Id("auth", "") 分别表示任何人都可以访问和创建者拥有访问权限。

## 实现原理
* 文件系统、临时/持久节点

它只有一个 Znode 的概念，它既能作为容器存储数据，也可以持有其他的 Znode 形成父子关系。  
Znode 其实有 PERSISTENT、PERSISTENT_SEQUENTIAL、EPHEMERAL 和 EPHEMERAL_SEQUENTIAL 四种类型，它们是临时与持久、顺序与非顺序两个不同的方向组合成的四种类型。  
临时节点是客户端在连接 Zookeeper 时才会保持存在的节点，一旦客户端和服务端之间的连接中断，当前连接持有的所有节点都会被删除，而持久的节点不会随着会话连接的中断而删除，它们需要被客户端主动删除；    Zookeeper 中另一种节点的特性就是顺序和非顺序，如果我们使用 Zookeeper 创建了顺序的节点，那么所有节点就会在名字的末尾附加一个序列号，序列号是一个由父节点维护的单调递增计数器。

* 通知

常见的通知机制往往都有两种，一种是客户端使用『拉』的方式从服务端获取最新的状态，这种方式获取的状态很有可能都是过期的，需要客户端不断地通过轮询的方式获取服务端最新的状态，另一种方式就是在客户端订阅对应节点后由服务端向所有订阅者推送该节点的变化，相比于客户端主动获取数据的方式，服务端主动推送更能够保证客户端数据的实时性。  
作为分布式协调工具的 Zookeeper 就实现了这种服务端主动推送请求的机制，也就是 Watch，当客户端使用 getData()，getChildren()，和exists()等接口获取 Znode 状态时传入了一个用于处理节点变更的回调，那么服务端就会主动向客户端推送节点的变更  
通知机制的实现其实还是比较简单的，通过读请求设置 Watcher 监听事件，写请求在触发事件时就能将通知发送给指定的客户端。

一次性监控，触发后，需要重新设置  
– 保证先收到事件，再收到数据修改的信息  
– 传递性  
• 如create会触发节点数据监控点，同时也会触发父节点的监控点  
• 如delete会触发节点数据监控点，同时也会触发父节点的监控点  

* 会话  
其他的长连接一样，Zookeeper 中的会话也需要客户端与服务端之间进行心跳检测，客户端会在超时时间内向服务端发送心跳请求来保证会话不会被服务端关闭，一旦服务端检测到某一个会话长时间没有收到心跳包就会中断当前会话释放服务器上的资源。Session的sessionTimeout值用来设置一个客户端会话的超时时间。当由于服务器压力太大、网络故障或是客户端主动断开连接等各种原因导致客户端连接断开时，只要在sessionTimeout规定的时间内能够重新连接上集群中任意一台服务器，那么之前创建的会话仍然有效。在为客户端创建会话之前，服务端首先会为每个客户端都分配一个sessionID。由于 sessionID 是 Zookeeper 会话的一个重要标识，许多与会话相关的运行机制都是基于这个 sessionID 的，因此，无论是哪台服务器为客户端分配的 sessionID，都务必保证全局唯一。

## 应用
* 发布订阅
```java
public static enum EventType {
    None(-1),
    NodeCreated(1),
    NodeDeleted(2),
    NodeDataChanged(3),
    NodeChildrenChanged(4);
}
```
该节点的子节点出现数量变更时就会调用 process 方法通知观察者, Zookeeper 更适合做一些类似服务配置的动态下发的工作

* 命名服务,分布式同步（Distributed Synchronization）  

在大型分布式系统中，有两件事情非常常见，一是不同服务之间的可能拥有相同的名字，另一个是同一个服务可能会在集群中部署很多的节点，Zookeeper 就可以通过文件系统和顺序节点解决这两个问题。
* 配置管理
* 集群管理
* 协调分布式事务
* 分布式锁
    * [分布式锁的一些特点](https://juejin.im/post/5bbb0d8df265da0abd3533a5)

互斥性:和我们本地锁一样互斥性是最基本，但是分布式锁需要保证在不同节点的不同线程的互斥。
可重入性:同一个节点上的同一个线程如果获取了锁之后那么也可以再次获取这个锁。
锁超时:和本地锁一样支持锁超时，防止死锁。
高效，高可用:加锁和解锁需要高效，同时也需要保证高可用防止分布式锁失效，可以增加降级。
支持阻塞和非阻塞:和ReentrantLock一样支持lock和trylock以及tryLock(long timeOut)。
支持公平锁和非公平锁(可选):公平锁的意思是按照请求加锁的顺序获得锁，非公平锁就相反是无序的。这个一般来说实现的比较少。

## 安装
* [down](https://www.apache.org/dyn/closer.cgi/zookeeper/)
* 配置
除了myid 不一样，zoo.cfg 配置一样
```
# conf/zoo.cfg
tickTime=2000
initLimit=10
syncLimit=5
dataDir=/opt/zookeeper/zkdata
dataLogDir=/opt/zookeeper/zkdatalog
clientPort=12181
server.1=192.168.7.100:12888:13888
server.2=192.168.7.101:12888:13888
server.3=192.168.7.107:12888:13888
#server.1 这个1是服务器的标识也可以是其他的数字， 表示这个是第几号服务器，用来标识服务器，这个标识要写到快照目录(dataDir)下面myid文件里
#192.168.7.107为集群里的IP地址，第一个端口是master和slave之间的通信端口，默认是2888，第二个端口是leader选举的端口，集群刚启动的时候选举或者leader挂掉之后进行新的选举的端口默认是3888
##initLimit Zookeeper 
# syncLimit=5 服务器集群中连接到 Leader 的 Follower 服务器）初始化连接时最长能忍受多少个心跳时间间隔数。当已经超过 5个心跳的时间（也就是 tickTime）长度后 Zookeeper 服务器还没有收到客户端的返回信息，那么表明这个客户端连接失败。总的时间长度就是 5*2000=10 秒
#dataLogDir 事物日志的存储路径，如果不配置这个那么事物日志会默认存储到dataDir制定的目录，这样会严重影响zk的性能，当zk吞吐量较大的时候，产生的事物日志、快照日志太多
```
* 命令 
```  
export ZK_HOME=
启动   
./zkServer.sh start 
./zkServer.sh stop 、restart
检查服务器状态  (注：需要所有成员服务器均启动服务后才能查看，否则会报错)
./zkServer.sh status

./bin/zkCli.sh -server 127.0.0.1:12181
help
ls /
create /text "test" 创建节点
create -e /text "test" 创建临时节点
create -s /text "test" 创建序列节点
get /test 查看节点
quit

``` 
## [自动清理](https://ningyu1.github.io/site/post/89-zookeeper-cleanlog/)

第二种：使用ZK的工具类PurgeTxnLog，它的实现了一种简单的历史文件清理策略，可以在这里看一下他的使用方法 http://zookeeper.apache.org/doc/r3.4.6/zookeeperAdmin.html 

第三种：对于上面这个执行，ZK自己已经写好了脚本，在bin/zkCleanup.sh中，所以直接使用这个脚本也是可以执行清理工作的。

第四种：从3.4.0开始，zookeeper提供了自动清理snapshot和事务日志的功能，通过配置 autopurge.snapRetainCount 和 autopurge.purgeInterval 这两个参数能够实现定时清理了。这两个参数都是在zoo.cfg中配置的：

autopurge.purgeInterval  这个参数指定了清理频率，单位是小时，需要填写一个1或更大的整数，默认是0，表示不开启自己清理功能。
autopurge.snapRetainCount 这个参数和上面的参数搭配使用，这个参数指定了需要保留的文件数目。默认是保留3个。

## [curator-recipes](https://curator.apache.org/curator-recipes/index.html)

## [znode version](https://ningg.top/zookeeper-lesson-7-zookeeper-version/)

* http://www.throwable.club/2018/12/16/zookeeper-curator-usage/
## swarm
https://hub.docker.com/_/zookeeper?tab=description

```yml
version: '3.1'

services:
  zoo1:
    image: zookeeper
    restart: always
    hostname: zoo1
    ports:
      - 2181:2181
    volumes:
      - zk_data_1:/data
      - zk_dataLog_1:/datalog
    environment:
      ZOO_MY_ID: 1
      ZOO_SERVERS: server.1=0.0.0.0:2888:3888;2181 server.2=zoo2:2888:3888;2181 server.3=zoo3:2888:3888;2181

  zoo2:
    image: zookeeper
    restart: always
    hostname: zoo2
    ports:
      - 2182:2181
    volumes:
      - zk_data_2:/data
      - zk_dataLog_2:/datalog
    environment:
      ZOO_MY_ID: 2
      ZOO_SERVERS: server.1=zoo1:2888:3888;2181 server.2=0.0.0.0:2888:3888;2181 server.3=zoo3:2888:3888;2181

  zoo3:
    image: zookeeper
    restart: always
    hostname: zoo3
    ports:
      - 2183:2181
    volumes:
      - zk_data_3:/data
      - zk_dataLog_3:/datalog
    environment:
      ZOO_MY_ID: 3
      ZOO_SERVERS: server.1=zoo1:2888:3888;2181 server.2=zoo2:2888:3888;2181 server.3=0.0.0.0:2888:3888;2181
      
 
volumes:
  zk_data_1:
  zk_data_2:
  zk_data_3:
  zk_dataLog_1:
  zk_dataLog_2:
  zk_dataLog_3:
```