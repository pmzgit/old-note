https://cwiki.apache.org/confluence/display/Hive/GettingStarted
http://hive.apache.org/downloads.html
## 简介
Hive是一个SQL解析引擎，将SQL语句转译成MR Job，然后再Hadoop平台上运行，达到快速开发的目的。  
Hive中的表是纯逻辑表，就只是表的定义等，即表的元数据。本质就是Hadoop的目录/文件， 达到了元数据与数据存储分离的目的  
Hive本身不存储数据，它完全依赖HDFS和MapReduce。  
Hive的内容是读多写少,支持记录级别的插入操作
Hive中没有定义专门的数据格式，由用户指定，需要指定三个属性：
列分隔符  
行分隔符  
读取文件数据的方法  

可扩展
       Hive可以自由的扩展集群的规模，一般情况下不需要重启服务

延展性
       Hive支持用户自定义函数，用户可以根据自己的需求来实现自己的函数

容错
       良好的容错性，节点出现问题SQL仍可完成执行

位图索引
Hive 执行延迟高。之前提到 Hive 在查询数据的时候，由于没有索引， 需要扫描整个衰 因此延迟较高。另外一个导致Hive 执行延迟 的因素是 MapReduce 算框架。由于 MapReduce 本身具有较高的延迟，因此在利用 MapReduce 执行 Hive 查询时，也会有较高的延迟。由于数据 访问延迟较高，决定了Hive 不适合实 数据查询，Hive 最佳使用场景是大数据集的批处理作业， 比如网络日志分析。


用户接口： CLI 命令行接口（ Command Line Interface JDBC ODBC Web）接口 。其中最常用的是 hive 这个客户端方式对 Hive 进行相应操作。

Driv 驱动引擎组件（ Hive 解析器） 包括编译器、优化器、执行器。功能就是根据用户编写的 Hive SQL 语句进行 解析、编译优化、生成执行计划，然后调用底层 Ma MapReduce 算框架形成对应的MapReduce Job 行执行。

Hive 元数据（Metastore : Hive 将元数据信息存储在关系数据库中 ，如 Derby （自带的）、MySQL(实际工作中配置的)，因为 Derby 不支持多用户使用 Hive 访问存储在 Derby 中的 Metastore数据，所以实际工作中，通常配置 MySQL 来存储 Metastore 数据。 Hive中的元数据信息包括表的名字、表的列和分区、表的属性（是否为外部表等)、表的数据所在的目录等。

## 应用场景
Hive 不是一个完整的数据库，它依托并受到 HDFS 的限制。其中最大的限制就是 Hive不支持记录级别的更新、插入或者删除操作。  
Hadoop是一个面向批处理的系统，任务的启动需要消耗较长的时间，所以 Hive 查询时比较严重。传统数据库秒级查询的任务在 Hive 中也需要执行较长的时间 如果是交互式查询的场景 建议使用Impala  
Hive 不支持事务。综上所述，Hive 不支持 OLT (On-Line Transaction Processing ），而更接近成为一个 OLAP( On-Line Anal cal Processing ）工具。而且仅仅是接近 OLAP ，因为 Hive 的延时性，它还没有满足 OLAP 中的“联机”部分。因此，Hive 是最适合数据仓库应用程序的，不需要快速响应给出结果，可以对海量数据进行相关的静态数据分析、数据挖掘，然后形成决策意见或者报表等。  https://blog.bcmeng.com/post/oltp-olap-htap.html

## [hive mysql](https://www.cnblogs.com/qingyunzong/p/8710356.html)


## [数据类型](https://www.cnblogs.com/qingyunzong/p/8733924.html)
* [中文乱码](https://www.cnblogs.com/qingyunzong/p/8724155.html)
* https://cwiki.apache.org/confluence/display/Hive/Tutorial
* https://cwiki.apache.org/confluence/display/Hive/LanguageManual+Types
### 原子数据类型
hive是用Java开发的，hive里的基本数据类型和java的基本数据类型也是一一对应的，除了string类型（字符串可以用单引号（'）或双引号（“）。Hive在字符串中使用C-Style的转义）。有符号的整数类型：TINYINT、SMALLINT、INT和BIGINT分别等价于java的byte、short、int和long原子类型，它们分别为1字节、2字节、4字节和8字节有符号整数。Hive的浮点数据类型FLOAT和DOUBLE,对应于java的基本类型float和double类型。而hive的BOOLEAN(false/true)类型相当于java的基本数据类型boolean。hive不支持日期类型（TIMESTAMP，》0.8，DECIMAL(7, 2)》0.11，DATE》0.12），在hive里日期都是用字符串来表示的，而常用的日期格式转化操作则是通过自定义函数进行操作。hive的String类型相当于数据库的varchar类型，该类型是一个可变的字符串，不过它不能声明其中最多能存储多少个字符，理论上它可以存储2GB的字符数。
BINARY 》0。8
char 》0.13
varchar 》0.12
Hive支持基本类型的转换，低字节的基本类型可以转化为高字节的类型，例如TINYINT、SMALLINT、INT可以转化为FLOAT，而所有的整数类型、FLOAT以及STRING类型可以转化为DOUBLE类型，这些转化可以从java语言的类型转化考虑，因为hive就是用java编写的。当然也支持高字节类型转化为低字节类型，这就需要使用hive的自定义函数CAST了。

### 复杂数据类型

ARRAY

一组有序字段。字段的类型必须相同

MAP
 MAP<primitive_type, data_type>
一组无序的键/值对。键的类型必须是原子的，值可以是任何类型，同一个映射的键的类型必须相同，值得类型也必须相同

结构体
STRUCT

一组命名的字段。字段类型可以不同

联合体 
UNIONTYPE<data_type, data_type, ...>
可以理解为泛型
```sql

Create table complex(col1
 ARRAY<INT>,
Col2
 MAP<STRING,INT>,
Col3
 STRUCT<a:STRING comment col_comment,b :INT,c:DOUBLE>);

Select col1[0],col2[‘b’],col3.c from complex;
```

## 数据模型
### database

CREATE (DATABASE|SCHEMA) [IF NOT EXISTS] database_name

　　[COMMENT database_comment]　　　　　　//关于数据块的描述

　　[LOCATION hdfs_path]　　　　　　　　　　//指定数据库在HDFS上的存储位置

　　[WITH DBPROPERTIES ('creator'='hadoop','date'='2018-04-05')];　　　　//指定数据库属性

hive提供了create database dbname、show databases,desc database extended t3，show create database t3，use dbname以及drop database if exists dbname cascade（hive 不允许删除包含表的数据库,此命令强制删除）;

这样的语句建表和数据加载可在同一个语句完成，也可以分部完成
create database db_hive2 location '/db_hive2.db';
alter database hive set dbproperties('createtime'='20170830');
### 内部表
在hive中创建一张表，如果不指定表所保存的位置，那么这张表会创建在HDFS文件系统中的/user/hive/warehouse目录下  
– hive的数据仓库也就是hdfs上的一个目录，这个目录是hive数据文件存储的默认路径，它可以在hive的配置文件里进行配置，最终也会存放到元数据库里,每一个都有相对应的目录， 存储在hive.metastore.warehouse.dir下，以表名为目录。   
– 删除表时，元数据与数据都会被删除。
```sql
show tables in t1;
show tables like 'student_c*';
create table t2 (tid int, tname string, age int) location '/mytable/hive/t2';


row format delimited fields terminated by ',';
表示以csv文件格式存储,因为csv存储的分隔符为逗号
row format DELIMITED [FIELDS TERMINATED BY char] [COLLECTION ITEMS TERMINATED BY char] MAP KEYS TERMINATED BY char] [LINES TERMINATED BY char]  SERDE serde_name [WITH SERDEPROPERTIES (property_name=property_value, property_name=property_value, ...)] 
用户在建表的时候可以自定义 SerDe 或者使用自带的 SerDe。如果没有指定 ROW FORMAT 或者 ROW FORMAT DELIMITED，将会使用自带的 SerDe。在建表的时候，用户还需要为表指定列，用户在指定表的列的同时也会指定自定义的 SerDe，Hive 通过 SerDe 确定表的具体的列的数据。

RegexSerDe正则表达式解析 特殊分隔符
create table t_bi_reg(id string,name string)
row format serde 'org.apache.hadoop.hive.serde2.RegexSerDe'
with serdeproperties('input.regex'='(.*)\\|\\|(.*)','output.format.string'='%1$s %2$s')
stored as textfile tblproperties ("orc.compress"="NONE");

根据查询结果创建表（查询的结果会添加到新创建的表中）
create table t4 row format delimited fields terminated by ',' as select * from sample_data;

create ... as 不能复制分区表

增加和替换列
ALTER TABLE table_name ADD|REPLACE COLUMNS (col_name data_type [COMMENT col_comment], ...) 
注：ADD 是代表新增一字段，字段位置在所有列后面(partition 列前)，REPLACE 则是
表示替换表中所有字段。

不支持删除字段, 替换所有字段
alter table new_student replace columns (id int, name string, address string);

修改内部表 student2 为外部表,固定写法，区分大小写！
alter table student2 set tblproperties('EXTERNAL'='TRUE');

alter table student rename to new_student;

更新列
ALTER TABLE table_name CHANGE [COLUMN] col_old_name col_new_name 
column_type [COMMENT col_comment] [FIRST|AFTER column_name]

drop table t1;

# 外部表

create external table test_external_location (
id string comment 'ID', 
name string comment '名字'
)
comment '测试外部表location'
ROW FORMAT DELIMITED 
FIELDS TERMINATED BY ',' 
lines terminated by '\n'
stored as textfile;
location '/tmp/dkl/external_location';

Create external table external_tbl
 (flied string)
    Location 
 ‘/home/hadoop/external_table’;
Load data local inpath
 ‘home/hadoop/test.txt’ overwrite  into table external_tbl;
# hdfs 文件夹及对应下的数据和建表语句没有先后顺序，建表在前和在后都可以把数据加载出来，往对应的HDFS路径下put数据，Hive表也会对应增加，如果先建表的话，对应的文件夹如果不存在，则会自动建立文件夹。

# 这两种表在使用的区别主要在drop命令上，drop是hive删除表的命令，内部表执行drop命令的时候，会删除元数据和存储的数据，而外部表执行drop命令时候只删除元数据库里的数据，而不会删除存储的数据，无论是建表是指定location还是不指定location。另外我还要谈谈表的load命令，hive加载数据时候不会对元数据进行任何检查，只是简单的移动文件的位置，如果源文件格式不正确，也只有在做查询操作时候才能发现，那个时候错误格式的字段会以NULL来显示。

 create table student_ctas as select * from student where id < 95012;
复制表结构
create table external student_copy like student;

# 分区表
# 分区表一般在数据量比较大，且有明确的分区字段时使用，这样用分区字段作为查询条件查询效率会比较高。hive里分区的概念是根据“分区列”的值对表的数据进行粗略划分的机制，在hive存储上就体现在表的主目录（hive的表实际显示就是一个文件夹）下的一个子目录，这个文件夹的名字就是我们定义的分区列的名字，没有实际操作经验的人可能会认为分区列是表的某个字段，其实不是这样，分区列不是表里的某个字段，而是独立的列，我们根据这个列存储表的里的数据文件。使用分区是为了加快数据分区的查询速度而设计的，我们在查询某个具体分区列里的数据时候没必要进行全表扫描。

# it is the user‘s job to guarantee the relationship between partition name and data content! Partition columns are virtual columns, they are not part of the data itself but are derived on load

# Hive分区分为静态分区和动态分区
静态分区和动态分区的建表语句是一样的
create table test_partition (
id string comment 'ID', 
name string comment '名字'
)
comment '测试分区'
partitioned by (year int comment '年')
ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' ;
静态分区和动态分区的插入数据的语句是不一样的
静态分区是在语句中指定分区字段为某个固定值
insert into table test_partition partition(year=2018) values ('001','张三');
insert into table test_partition partition(year=2018) values ('001','张三');
insert into table test_partition partition(year=2018) values ('002','李四');


data.txt:

002,李四
003,王五


load data local inpath '/root/dkl/data/data.txt' into table test_partition partition (year =2018);
load data local inpath '/root/dkl/data/data.txt' into table test_partition partition (year =2018);
load data local inpath '/root/dkl/data/data.txt' into table test_partition partition (year =2017);


/apps/hive/warehouse/dkl.db/test_partition/year=2018
/apps/hive/warehouse 为hive的仓库路径
dkl.db dkl为数据库名称
test_partition为表名
year为分区字段名

# 动态分区
insert into table test_partition partition(year) values ('001','张三',2016);

动态分区默认不开启，set hive.exec.dynamic.partition.mode=nonstrict; 临时生效，不能使用load data进行动态分区插入,创建没有分区的数据表
create table test (
id string comment 'ID', 
name string comment '名字',
year int comment '年'
)
comment '测试'
ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t'
    LINES TERMINATED BY '\n';

从表test，动态分区插入test_partition中
insert overwrite into table test_partition partition(year)  select id,name,year from test;

查看分区信息

show  partitions test_partition;

添加分区字段，不能添加新的分区字段，只能添加新分区
alter table test_partition add  partition(year=2012) partition(city="chongqing3") partition(city="chongqing4");

当然也可以指定localtion,这样就不会在默认的路径下建立文件夹了
alter table test_partition add  partition (year=2010) location '/tmp/dkl';
这样如果/tmp/dkl文件夹不存在的话就会新建文件夹，如果存在就会把该文件夹下的所有的文件加载到Hive表，有一点需要注意，如果删除该分区的话，对应的文件夹也会删掉

添加非分区字段,新加的字段是在非分区字段的最后，在分区字段之前
alter table test_partition add columns(age int);

不过这里有一个bug，就是往表里新插入数据后，新增的age字段查询全部显示为NULL（其实数据已经存在）,对已存在的分区执行下面的sql即可,以分区2018为例
alter table test_partition partition(year=2018) add columns(age int);

# 多个分区字段

create table test_partition2 (
id string comment 'ID', 
name string comment '名字'
)
comment '测试两个分区'
partitioned by (year int comment '年',month int comment '月')
ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' ;

insert into table test_partition2 partition(year=2018,month=12) values ('001','张三');

/apps/hive/warehouse/dkl.db/test_partition2/year=2018/month=12

# 删除分区

只能删除某个分区，如删除分区2018，而不能删除整个分区year字段。
alter table test_partition drop partition(year=2018);

# 多分区字段
alter table test_partition2 drop partition(year=2018,month=12);
year=2018所有的月份都会删除
alter table test_partition2 drop partition(year=2018);
所有月份等于10的分区都会删除，无论year=2018,还是year=2017
alter table test_partition2 drop partition(month=10);


# 数据关联 分区表的复制
1. 创建新表: create table score3 like score;
2. 将HDFS的数据文件复制一份到新表目录，hive cmd模式下： 
`dfs -cp -f /user/hive/warehouse/score/* /user/hive/warehouse/score3/`
3. 上传数据后修复
msck repair table score3;

# 桶（bucket）：上面的table和partition都是目录级别的拆分数据，bucket则是对数据源数据文件本身来拆分数据。使用桶的表会将源数据文件按一定规律拆分成多个文件，要使用bucket，我们首先要打开hive对桶的控制
set hive.enforce.bucketing=true;

set mapreduce.job.reduces=-1;

desc student_tmp;
desc formatted tbl;
desc extended student;
truncate table test_bucket;  不能删除外部表中数据
truncate table test;

分桶规则：对分桶字段值进行哈希，哈希值除以桶的个数求余，余数决定了该条记录在哪个桶中，也就是余数相同的在一个桶中。
优点：1、提高join查询效率 2、提高抽样效率 3 控制输出文件的数量，类似reduce mapred.reduce.tasks

create table test_bucket (
id int comment 'ID', 
name string comment '名字'
)
comment '测试分桶'
clustered by(id) sorted by (id desc) into 4 buckets
ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' ;

直接load data不会有分桶的效果，这样和不分桶一样，在HDFS上只有一个文件。先将数据load到中间表,然后将中间表的数据插入到分桶表中，这样会产生四个文件。
insert into table test_bucket select * from test;

桶是以文件的形式存在的，而不是像分区那样以文件夹的形式存在，我们用sql语句查出来的顺序和文件存放的顺序是一致的，（默认不排序按文件里的顺序）

用sql看和用hadoop命令看每个文件，结果每个桶内都是按id升序排序的，因为每个桶内的数据是排序的，这样每个桶进行连接时就变成了高效的归并排序

假设表A和表B进行join，join的字段为id
条件：

1、两个表为大表
2、两个表都为分桶表
3、A表的桶数是B表桶数的倍数或因子
这样join查询时候，表A的每个桶就可以和表B对应的桶直接join，而不用全表join，提高查询效率
比如A表桶数为4，B表桶数为8，那么桶数对应关系为

表A	表B
0	0
1	1
2	2
3	3
0	4
1	5
2	6
3	7

提高抽样效率
分桶表后面可以不带on 字段名，不带时默认的是按分桶字段,也可以带，而没有分桶的表则必须带
按分桶字段取样时，因为分桶表是直接去对应的桶中拿数据，在表比较大时会提高取样效率


select * from stu_buck tablesample (bucket x out of y on id);

x表示从哪个桶(x-1)开始，y代表分几个桶，也可以理解分x为分子，y为分母，及将表分为y份（桶），取第x份（桶）

所以这时对于分桶表是有要求的，y为桶数的倍数或因子，hive根据y的大小，决定抽样的比例，比如桶数4

x=1,y=2，取2(4/y)个bucket的数据，分别桶0(x-1)和桶2(0+y)
x=1,y=4, 取1(4/y)个bucket的数据，即桶0
x=2,y=8, 取1/2(4/y)个bucket的数据，即桶1的一半

x的范围：[1,y]

table总共分了64份，当y=32时，抽取 (64/32=)2个bucket的数据，当y=128时，抽取(64/128=)1/2个bucket的数据。x表示从哪个bucket开始抽取。例如，table总bucket数为32，tablesample(bucket 3 out of 16)，表示总共抽取（32/16=）2个bucket的数据，分别为第3个bucket和第（3+16=）19个bucket的数据。
再次插入数据，会再产生新的四个文件

## 视图
视图是一个虚表， 不存储数据的, 如果存储数据只有一种特殊的视图（物化视图），只存在于orcale和myql中， hive不存在物化视图
（1）只有逻辑视图，没有物化视图；

（2）视图只能查询，不能 Load/Insert/Update/Delete 数据；

（3）视图在创建时候，只是保存了一份元数据，当查询视图的时候，才开始执行视图对应的 那些子查询
create view view_cdt as select * from cdt;
show views;
desc view_cdt;-- 查看某个具体视图的信息
drop view view_cdt;
```

# 数据存储,文件格式

### snappy
如果允许损失一些压缩率的话，那么可以达到更高的压缩速度，虽然生成的压缩文件可能会比其他库的要大上20%至100%，但是，相比其他的压缩库，Snappy却能够在特定的压缩率下拥有惊人的压缩速度，“压缩普通文本文件的速度是其他库的1.5-1.7倍，HTML能达到2-4倍，但是对于JPEG、PNG以及其他的已压缩的数据，压缩速度不会有明显改善”。

行存储的特点： 查询满足条件的一整行数据的时候，列存储则需要去每个聚集的字段找到对应的每个列的值，行存储只需要找到其中一个值，其余的值都在相邻地方，所以此时行存储查询的速度更快。
列存储的特点： 因为每个字段的数据聚集存储，在查询只需要少数几个字段的时候，能大大减少读取的数据量；每个字段的数据类型一定是相同的，列式存储可以针对性的设计更好的设计压缩算法。

1.1 textfile
textfile为默认格式，存储方式为行存储。
1.2 ORCFile
hive/spark都支持这种存储格式，它存储的方式是采用数据按照行分块，每个块按照列存储，其中每个块都存储有一个索引。特点是数据压缩率非常高。
1.3 Parquet
Parquet也是一种列式存储，同时具有很好的压缩性能；同时可以减少大量的表扫描和反序列化的时间。

stored as textfile/orc/parquet/ SEQUENCEFILE;
hadoop dfs -du -h hdfs://localhost:9002/user/hive/warehouse/yyz_workdb.db/parquet

磁盘空间占用大小比较

orc<parquet<textfile

查询语句运行时间大小比较

orc<parquet<textfile
查看集群的支持的压缩算法.
set io.compression.codecs

这个大小趋势适用于较大的数据，在数据量较小的情况下，可能会出现与之相悖的结论
-- 任务中间压缩
set hive.exec.compress.intermediate=true
set hive.intermediate.compression.codec=org.apache.hadoop.io.compress.SnappyCodec;
set hive.intermediate.compression.type=BLOCK;
-- map/reduce 输出压缩
set hive.exec.compress.output=true 
set mapred.output.compression.codec=org.apache.hadoop.io.compress.SnappyCodec
set mapred.output.compression.codec=com.hadoop.compression.lzo.LzoCodec;
hive.exec.compress.intermediate：默认该值为false，设置为true为激活中间数据压缩功能。HiveQL语句最终会被编译成Hadoop的Mapreduce job，开启Hive的中间数据压缩功能，就是在MapReduce的shuffle阶段对mapper产生的中间结果数据压缩。在这个阶段，优先选择一个低CPU开销的算法。 
 mapred.map.output.compression.codec：该参数是具体的压缩算法的配置参数，SnappyCodec比较适合在这种场景中编解码器，该算法会带来很好的压缩性能和较低的CPU开销

set mapred.output.compression.codec=org.apache.hadoop.io.compress.SnappyCodec

hive.exec.compress.output：用户可以对最终生成的Hive表的数据通常也需要压缩。该参数控制这一功能的激活与禁用，设置为true来声明将结果文件进行压缩。 
mapred.output.compression.codec：将hive.exec.compress.output参数设置成true后，然后选择一个合适的编解码器，如选择SnappyCodec

常见的hive文件存储格式包括以下几类：TEXTFILE、SEQUENCEFILE、RCFILE、ORC。其中TEXTFILE为默认格式，建表时默认为这个格式，导入数据时会直接把数据文件拷贝到hdfs上不进行处理。SequenceFile、RCFile、ORC格式的表不能直接从本地文件导入数据，数据要先导入到TextFile格式的表中，然后再从TextFile表中用insert导入到SequenceFile、RCFile表







## 安装配置

https://blog.csdn.net/a123demi/article/details/72742279

```xml
hive-site.xml
    <configuration>
    <property>
        <name>javax.jdo.option.ConnectionURL</name>
        <value>jdbc:mysql://master:3306/hive?createDatabaseIfNotExist=true&useSSL=false&useUnicode=true&characterEncoding=UTF-8</value>
    </property>
    <property>
        <name>javax.jdo.option.ConnectionDriverName</name>
        <value>com.mysql.jdbc.Driver</value>
    </property>
    <property>
        <name>javax.jdo.option.ConnectionUserName</name>
        <value>root</value>
    </property>
    <property>
        <name>javax.jdo.option.ConnectionPassword</name>
        <value>root</value>
    </property>
    <property>
        <name>hive.metastore.warehouse.dir</name>
        <value>/user/hive/warehouse</value>
        <description>hive default warehouse, if nessecory, change it</description>
    </property> 
    <property>
    <name>hive.metastore.client.socket.timeout</name>
    <value>600s</value>
    <description>
      Expects a time value with unit (d/day, h/hour, m/min, s/sec, ms/msec, us/usec, ns/nsec), which is sec if not specified.
      MetaStore Client socket timeout in seconds
    </description>
  </property>
        <!-- hive查询时输出列名 -->
    <property>
        <name>hive.cli.print.header</name>
        <value>true</value>
    </property>
    <!-- 显示当前数据库名 -->
    <property>
        <name>hive.cli.print.current.db</name>
        <value>true</value>
    </property>
    <property>
  <name>hive.metastore.uris</name>
  <value>thrift://192.168.20.101:9083</value>
  <description>IP address (or fully-qualified domain name) and port of the metastore host</description>
</property>
<property>
    <name>hive.exec.scratchdir</name>
    <value>/tmp/hive</value>
    <description>HDFS root scratch dir for Hive jobs which gets created with write all (733) permission. For each connecting user, an HDFS scratch dir: ${hive.exec.scratchdir}/<username> is created, with ${hive.scratch.dir.permission}.</description>
  </property>
  <property>
    <name>hive.exec.local.scratchdir</name>
    <value>/tmp/hive</value>
    <description>Local scratch space for Hive jobs</description>
  </property>
  <property>
    <name>hive.downloaded.resources.dir</name>
    <value>/tmp/hive/${hive.session.id}_resources</value>
    <description>Temporary local directory for added resources in the remote file system.</description>
  </property>
  <property>
    <name>hive.scratch.dir.permission</name>
    <value>733</value>
    <description>The permission for the user specific scratch directories that get created.</description>
  </property

<!-- 要修改 hive-site.xml 中所有包含 ${system:java.io.tmpdir} 字段的 value ，可以自己新建一个目录来替换它，例如 /home/hadoop/hive/iotmp  -->

<property>
    <name>hive.exec.compress.output</name>
    <value>true</value>
    <description>
      This controls whether the final outputs of a query (to a local/HDFS file or a Hive table) is compressed. 
      The compression codec and other options are determined from Hadoop config variables mapred.output.compress*
    </description>
  </property>
  <property>
    <name>hive.exec.compress.intermediate</name>
    <value>true</value>
    <description>
      This controls whether intermediate files produced by Hive between multiple map-reduce jobs are compressed. 
      The compression codec and other options are determined from Hadoop config variables mapred.output.compress*
    </description>
  </property>
</configuration>

mv mysql-connector-java-5.1.46/mysql-connector-java-5.1.46.jar /usr/local/hive/lib/ 


/conf/hive-env.sh

# Set HADOOP_HOME to point to a specific hadoop install directory
# HADOOP_HOME=${bin}/../../hadoop

# Hive Configuration Directory can be controlled by:
# export HIVE_CONF_DIR=

# Folder containing extra libraries required for hive compilation/execution can be controlled by:
# export HIVE_AUX_JARS_PATH=

$ $HADOOP_HOME/bin/hadoop fs -mkdir       /tmp
$ $HADOOP_HOME/bin/hadoop fs -mkdir       /user/hive/warehouse
$ $HADOOP_HOME/bin/hadoop fs -chmod g+w   /tmp
$ $HADOOP_HOME/bin/hadoop fs -chmod g+w   /user/hive/warehouse

export HIVE_HOME=/usr/local/hive
export PATH=$PATH:$HIVE_HOME/bin
cp /usr/local/hive/lib/jline-2.12.jar /usr/local/hadoop-2.6.5/share/hadoop/yarn/lib/

Starting from Hive 2.1
hive

hive --service metastore -p 9083

schematool -dbType mysql -initSchema
schematool -dbType mysql -info

grant all privileges on hive.* to root; 
看mysql 有木有hive 库


hive --help 可以查看 hive 命令可以启动那些服务
hive --service serviceName --help 可以查看某个具体命令的使用方式

select current_database();


#hive -e "LOAD DATA LOCAL INPATH '/opt/a.txt' OVERWRITE INTO TABLE table_aname"
#hive -e "LOAD DATA LOCAL INPATH '/opt/b.txt' OVERWRITE INTO TABLE table_aname partition (partcol1=val1,…)"
默认是default库，文件在hdfs就去掉LOCAL

​ LOAD DATA INPATH '/root/hive/hive_test/a.txt' OVERWRITE INTO TABLE u_info;
drop table u_info;

drop table if exists default.hive_user_prq;

hive -f abc.sql > result.txt
```

优先级依次为NOT AND OR

## 配置
set;
Hive 的 log 默认存放在 /tmp/root/hive.log

hive --hiveconf mapred.reduce.tasks=10;


!set

set mapred.reduce.tasks;

set mapred.reduce.tasks=100;


配置文件<命令行参数<参数声明

log4j 相关的设定，必须用前两种方式设定，因为那些参数的读取在会话建立以前已经完成了

* beeline  sqllien

```sh
hive --service hiveserver2 &
nohup hiveserver2 1>/home/hadoop/hiveserver.log 2>/home/hadoop/hiveserver.err &

beeline -u jdbc:hive2://hadoop3:10000 -n hadoop -f wordcount.hql
```

http://www.voidcn.com/article/p-ooofzudr-bov.html

http://sqlline.sourceforge.net/#introduction

```sh
-f选项来执行包含HiveQL代码的文件
-e选项直接在命令行运行HiveQL
--silent来阻止通知的消息输出，也可以和-e或-f选项一起使用
1、!connect jdbc:hive2://hadoop02:10000 – 连接不同的Hive2服务器

2、!exit – 退出shell
!close 退出当前连接的数据库
3、!help – 显示全部命令列表

4、!verbose – 显示查询追加的明细

dfs -ls /;

!sh                 Execute a shell command

hive 中输入的所有历史命令

用户目录下 .beeline
```

### [语法](https://cwiki.apache.org/confluence/display/Hive/LanguageManual)

export table default.student to　'/user/hive/warehouse/export/student';

## [自定义函数](https://cwiki.apache.org/confluence/display/Hive/HivePlugins)

```sql
SHOW FUNCTIONS;
DESC FUNCTION concat;
DESC FUNCTION EXTENDED concat;
```

https://blog.csdn.net/liuj2511981/article/details/8523084

UDF(User-Defined-Function)，用户自定义函数对数据进行处理
用法：UDF函数可以直接应用于select语句，对查询结构做格式化处理后，再输出内容

一对一

udaf
多对一
group by

udtf
一对多
生成函数
insert into table rate select
get_json_object(line,'$.movie') as moive,
get_json_object(line,'$.rate') as rate,
get_json_object(line,'$.timeStamp') as unixtime,
get_json_object(line,'$.uid') as userid
from rate_json;

select b.b_movie, b.b_rate, b.b_timeStamp, b.b_uid from json a lateral view json_tuple(a.data,'movie','rate','timeStamp','uid') b as b_movie,b_rate,b_timeStamp,b_uid;

## 数据检查
hql：读时模式：读时数据解析  
load 数据快，仅仅是文件复制，移动  
sql: 写时模式：为后续查询性能，索引，压缩
加载慢


## hive优化
```sh
explain select sum(id) from my;

mapred.min.split.size、mapred.max.split.size、blockSize均可以再配置文件中配置，前面两个在mapred-site.xml中，最后一个可在在hdfs-site.xml中进行配置,单位均为B。

set mapred.max.split.size=100000000;
set mapred.min.split.size.per.node=100000000; 
set mapred.min.split.size.per.rack=100000000; 
set hive.input.format=org.apache.hadoop.hive.ql.io.CombineHiveInputFormat;

Map端聚合 hive.map.aggr=true


hive.exec.reducers.bytes.per.reducer；reduce任务处理的数据量

https://cwiki.apache.org/confluence/display/Hive/LanguageManual+SortBy
order by（可以使用distribute by和sort by）
cluster by 默认只能升序

Union all（不去重）
– 先做union all再做join或group by等操作可以有效减少MR过程，尽管是多个Select，最终只有一个
mr

一个MR job
SELECT a.val, b.val, c.val
FROM a 
JOIN b ON (a.key = b.key1) 
JOIN c ON (a.key = c.key1)

join 优化：表连接顺序

SELECT /*+ STREAMTABLE(a) */ a.val, b.val, c.val
FROM a 
JOIN b ON (a.key = b.key1) 
JOIN c ON (c.key = b.key1)； a表被视为大表

SELECT /*+ MAPJOIN(b) */ a.key, a.value
FROM a 
JOIN b ON a.key = b.key;
MAPJION会把小表（必须是小表，不要超过1G，或者50万条记录）全部读入内存中，在map阶
段直接拿另外一个表的数据和内存中表数据做
匹配，由于在map是进行了join操作，省去了
reduce运行的效率也会高很多.

执行顺序是，首先完成2表JOIN，然后再通过WHERE条件进行过滤，这样在JOIN过程中可能会输出大量结果，再对这些结果进行过滤，比较耗时。可以进行优化，将WHERE条件放在ON后，在JOIN的过程中，就对不满足条件的记录进行了预先过滤。

ASELECT a.val, b.val
FROM a 
LEFT OUTER JOIN b
ON (a.key=b.key AND b.ds='2009-07-07' AND a.ds='2009-07-07')

Multi-insert & multi-group by
– 从一份基础表中按照不同的维度，一次组合出不同的数据
– FROM from_statement
– INSERT OVERWRITE TABLE tablename1 [PARTITION (partcol1=val1)] select_statement1 group by key1
– INSERT OVERWRITE TABLE tablename2 [PARTITION(partcol2=val2 )] select_statement2 group by key2

Automatic merge
– 当文件大小比阈值小时，hive会启动一个mr进行合并
– hive.merge.mapfiles = true 是否和并 Map 输出文件，默认为 True
– hive.merge.mapredfiles = false 是否合并 Reduce 输出文件，默认为 False
– hive.merge.size.per.task = 256*1000*1000 合并文件的大小

Multi-Count Distinct 中间加一个reduce
– 必须设置参数：set hive.groupby.skewindata=true;
– select dt, count(distinct uniq_id), count(distinct ip) – from ods_log where dt=20170301 group by dt

set hive.exec.parallel=true
# Statistics
https://blog.csdn.net/mhtian2015/article/details/78776122
set hive.stats.autogather=true;    
set hive.stats.dbclass=hbase;
set hive.stats.dbclass=jdbc:derby;
set hive.stats.dbconnectionstring="jdbc:derby:;databaseName=TempStatsStore;create=true";
set hive.stats.jdbcdriver="org.apache.derby.jdbc.EmbeddedDriver";
hive.stats.reliable=false
ANALYZE TABLE [db_name.]tablename [PARTITION(partcol1[=val1], partcol2[=val2], ...)]  -- (Note: Fully support qualified table name since Hive 1.2.0, see HIVE-10007.)
  COMPUTE STATISTICS 
  [FOR COLUMNS]          -- (Note: Hive 0.10.0 and later.)
  [CACHE METADATA]       -- (Note: Hive 2.1.0 and later.)
  [NOSCAN]; 若是指定参数NOSCAN，这个命令不回去扫描每个文件，因此速度非常快，但是它仅仅会获取两个统计信息（文件数，byte数）
desc formatted table_name partition() 
# 函数
https://www.cnblogs.com/qingyunzong/p/8744593.html

```

## 窗口与分析型函数

http://shzhangji.com/cnblogs/2017/09/05/hive-window-and-analytical-functions/
http://lxw1234.com/archives/tag/hive-window-functions
http://lxw1234.com/archives/2015/04/185.htm


## 事务
http://shzhangji.com/cnblogs/2019/06/11/understanding-hive-acid-transactional-table/



https://www.cnblogs.com/cc11001100/p/9434120.html
