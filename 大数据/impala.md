https://impala.apache.org/  
https://www.jianshu.com/p/257ff24db397

## 介绍

Impala是使用C ++开发的,LLVM统一编译运行  
完全依赖hive,两者使用相同的元数据,兼顾数据仓库、具有实时、批处理、多并发等优点,impala使用hive的元数据, 完全在内存中计算,官方建议128G(一般64G基本满足)，可优化: 各个节点汇总的节点(服务器)内存选用大的，不汇总节点可小点,hive中的一些复杂结构是不支持的,实践过程中分区超过1w 性能严重下下降
稳定性不如hive,因完全在内存中计算，内存不够，会出现问题, hive内存不够，可使用外存  
Impala没有MapReduce批处理，直接读取HDFS及Hbase数据 ,支持Data Local,而是通过使用与商用并行关系数据库中类似的分布式查询引擎（由Query Planner、Query Coordinator和Query Exec Engine三部分组成),从而大大降低了延迟
Impala提供JDBC和ODBC API。  
mpala不提供对触发器的任何支持。  
Impala不提供任何对序列化和反序列化的支持  
每当新的记录/文件被添加到HDFS中的数据目录时，该表需要被刷新。   
在Impala中，您无法更新或删除单个记录。Impala SQL is focused on queries and includes relatively little DML. There is no UPDATE or DELETE statement. Stale data is typically discarded (by DROP TABLE or ALTER TABLE ... DROP PARTITION statements) or replaced (by INSERT OVERWRITE statements).  
Impala不支持事务    
Impala不支持索引    

数据流：

Hive: 采用推的方式，每一个计算节点计算完成后将数据主动推给后续节点。  
Impala: 采用拉的方式，后续节点通过getNext主动向前面节点要数据，以此方式数据可以流式的返回给客户端，且只要有1条数据被处理完，就可以立即展现出来，而不用等到全部处理完成，更符合SQL交互式查询使用。

内存使用：

Hive: 在执行过程中如果内存放不下所有数据，则会使用外存，以保证Query能顺序执行完。每一轮MapReduce结束，中间结果也会写入HDFS中，同样由于MapReduce执行架构的特性，shuffle过程也会有写本地磁盘的操作。   
Impala: 在遇到内存放不下数据时，当前版本1.0.1是直接返回错误，而不会利用外存，以后版本应该会进行改进。这使用得Impala目前处理Query会受到一 定的限制，最好还是与Hive配合使用。Impala在多个阶段之间利用网络传输数据，在执行过程不会有写磁盘的操作（insert除外）

容错

Hive任务依赖于Hadoop框架的容错能力，可以做到很好的failover  
Impala中不存在任何容错逻辑，如果执行过程中发生故障，则直接返回错误。当一个Impalad失败时，在这个Impalad上正在运行的所有query都将失败。但由于Impalad是对等的，用户可以向其他Impalad提交query，不影响服务。当StateStore失败时，也不会影响服务，但由于Impalad已经不能再更新集群状态，如果此时有其他Impalad失败，则无法及时发现。这样调度时，如果谓一个已经失效的Impalad调度了一个任务，则整个query无法执行。

## 安装
https://impala.apache.org/docs/build/html/topics/impala_hadoop.html

hdfs-site.xml、core-site.xml和hive-site.xml
```sh
core-site.xml
<property>
  <name>fs.defaultFS</name>
  <value>hdfs://ip-172-31-20-161.ap-northeast-2.compute.internal:8020</value>
</property>
hdfs-site.xml
<property>
  <name>dfs.client.read.shortcircuit</name>
  <value>true</value>
</property>
hive-site.xml
<configuration>
  <property>
    <name>hive.metastore.uris</name>
    <value>thrift://ip-172-31-20-161.ap-northeast-2.compute.internal:9083</value>
  </property>
</configuration>
## hbase
#https://impala.apache.org/docs/build/html/topics/impala_hbase.html#hbase_queries
conf/hbase-site.xml
<property>
  <name>hbase.client.retries.number</name>
  <value>3</value>
</property>
<property>
  <name>hbase.rpc.timeout</name>
  <value>3000</value>
</property>

export IMPALA_HOME=/opt/impala
export PATH=$PATH:$IMPALA_HOME/bin
export IMPALA_CONF_DIR=$IMPALA_HOME/conf

vi /etc/default/impala

IMPALA_CATALOG_SERVICE_HOST=192.168.40.130 -- 安装impala-catalog的服务器IP
IMPALA_STATE_STORE_HOST=192.168.40.150 -- 安装impala-state-store的服务器IP（需要在安装hive的服务器上）
IMPALA_SCRATCH_DIR=/home/hadoop
IMPALA_CATALOG_ARGS=" -log_dir=${IMPALA_LOG_DIR} "
IMPALA_STATE_STORE_ARGS=" -log_dir=${IMPALA_LOG_DIR} -state_store_port=${IMPALA_STATE_STORE_PORT}"
IMPALA_SERVER_ARGS=" \
-log_dir=${IMPALA_LOG_DIR} \
-catalog_service_host=${IMPALA_CATALOG_SERVICE_HOST} \
-state_store_port=${IMPALA_STATE_STORE_PORT} \
-use_statestore \
-state_store_host=${IMPALA_STATE_STORE_HOST} \
-scratch_dirs=${IMPALA_SCRATCH_DIR} \
-be_port=${IMPALA_BACKEND_PORT}"


bin/start-impala-cluster.sh
bin/start-impala-cluster.sh --kill
bin/start-impala-cluster.sh --force_kill

usermod -G hive,hdfs,hadoop impala

sudo -u hdfs hadoop fs -mkdir /user/impala
sudo -u hdfs hadoop fs -chown impala /user/impala
将用户impala加入该文件所属的组
chmod 775 /var/run/hadoop-hdfs
```

主机名：25010  默认的元数据所在节点信息，
主机名:25000    server信息,任何有装server的节点都可以访问
主机名：25020  catalog信息

## 使用
Hive查询语言（HiveQL）的最常见SQL-92功能，包括SELECT，join和aggregate函数
-f选项来执行包含查询的文件
-q选项直接在命令行运行查询
-o来将结果输出到文件
impala-shell -i localhost:port -d hbase
默认端口 21000
```sh
impala-shell -h 
quit
select version;

Impala内部Shell
shell hdfs dfs

# 特殊数据库
# default，建立的没有指定任何数据库的新表
# _impala_builtins，用于保存所有内置函数的系统数据库

# 库操作
# 创建 
create database tpc;
# 展示
show databases;
# 展示库名中含有指定(格式)字符串的库展示

summary;
profile;
# 进入
use tpc;
# 当前所在库
select current_database();

#表操作
# 展示(默认default库的表)
show tables;
# 指定库的表展示
show tables in tpc;
# 展示指定库中表名中含有指定字符串的表展示
show tables in tpc like 'customer*';
# 表结构
describe city; 或 desc city;
# select insert create alter

# 表导到另一个库中(tcp:city->d1:city)
alter table city rename to d1.city

# 列是否包含null值
select count(*) from city where c_email_address is null

# hive中 create、drop、alter,切换到impala-shell中需要如下操作
invalidate metadata table_name
# hive中 load、insert、change表中数据(直接hdfs命令操作),切换到impala-shell中需要如下操作
refresh table_name


```
考虑集群性能问题，一般将StateStoreDaemon与 Catalog Daemon放在统一节点上，因之间要做通信,与hive安装部署在同一台服务器


## 调优
https://www.cloudera.com/documentation/enterprise/5-9-x/topics/impala_explain_plan.html
```sh
set explain_level=1
explain
show table stats t1;
show column stats t1;
```


## [HUE](https://docs.gethue.com/quickstart/)


安全事件

资产名称
事件类型
发生时间
发生地点
ip定位
风险等级
恶意程度高、波及范围广 是否造成损失，
事件状态为：忽略、误报和已处置。修复和加固建议

https://www.secrss.com/articles/15930
http://help.cloud.nsfocus.com/hc/kb/article/1111532/
http://www.integritytech.com.cn/html/Products/Products_172_1.html
类型统计，时间统计，地理位置统计，行业，单位，分析，政府机构，教育电力，银行，公司，科技，大学
Dos SQL注入，XSS，网页篡改，网页挂马，其他


搜索

https://www.venuseye.com.cn/ip/

统计
受攻击目标统计，按时间范围
https://www.secpulse.com/archives/110475.html 风险级别，地理位置为基准的统计，top5 资产
细分领域的统计
攻击资产的统计，某类资产受到的攻击方式
分析


基于数据处理与计算分析的自动化关联技术，自动对采集的安全事件数据开展聚合挖掘、机器学习等分析，从用户画像、设备画像、IP画像、技术特征等多角度出发，有效的从安全事件数据中找出异常行为/重点关注对象，快速完成初步的技术研判工作，提升安全事件分析能力。

https://www.leimudata.com/ip.html

攻击手段
攻击者-资产名称-结果
资产拥有者-采取的措施-结果
攻击者-攻击者目的
攻击者是否找到

设备设施故障

长期解决方案


