# 简介
http://sqoop.apache.org/docs/1.4.7/SqoopUserGuide.html

# 安装配置
```sh
# conf/sqoop-env.sh
export HADOOP_COMMON_HOME=/home/hadoop/apps/hadoop-2.7.5

#Set path to where hadoop-*-core.jar is available
export HADOOP_MAPRED_HOME=/home/hadoop/apps/hadoop-2.7.5

#set the path to where bin/hbase is available
export HBASE_HOME=/home/hadoop/apps/hbase-1.2.6

#Set the path to where bin/hive is available
export HIVE_HOME=/home/hadoop/apps/apache-hive-2.3.3-bin

#Set the path for where zookeper config dir is
export ZOOCFGDIR=/home/hadoop/apps/zookeeper-3.4.10/conf


.bashrc
export SQOOP_HOME=/home/hadoop/apps/sqoop-1.4.6
export PATH=$PATH:$SQOOP_HOME/bin

# mysql、oracle等数据库的JDBC驱动也要放到Sqoop的lib目录下

sqoop-version


sqoop help

sqoop help import

sqoop list-databases \
> --connect jdbc:mysql://hadoop1:3306/ \
> --username root \
> --password root


sqoop list-tables \
> --connect jdbc:mysql://hadoop1:3306/mysql \
> --username root \
> --password root



sqoop create-hive-table \
--connect jdbc:mysql://hadoop1:3306/mysql \
--username root \
--password root \
--table help_keyword \
--hive-table hk

# hdfs 

数据导出储存方式（数据存储文件格式---（ textfil parquet）
--as-textfile	Imports data as plain text (default)
--as-parquetfile	Imports data to Parquet Files
）

--where 不能用or，子查询，join

sqoop import   \
--connect jdbc:mysql://hadoop1:3306/mysql   \
--username root  \
--password root   \
--where "name='STRING' " \
--table help_keyword   \
--target-dir /sqoop/hadoop11/myoutport1  \
-m 1

sqoop import   \
--connect jdbc:mysql://hadoop1:3306/  \
--username root  \
--password root   \
--target-dir /user/hadoop/myimport33_1  \
--query 'select help_keyword_id,name from mysql.help_keyword where $CONDITIONS and name = "STRING"' \
--split-by  help_keyword_id \
--fields-terminated-by '\t'  \
-m 4


Sqoop 导入关系型数据到 hive 的过程是先导入到 hdfs，然后再 load 进入 hive
--target-dir:需要指定该参数，数据首先写入到该目录，过程和直接导入HDFS是一样
普通导入：数据存储在默认的default hive库中，表名就是对应的mysql的表名：

--delete-target-dir:如果目标目录已经存在，会先把目录删掉，类似overwrite
--hive-import参数指定数据导入到hive表
--hive-drop-import-delims:删除string字段内的特殊字符，如果Hive使用这些字符作为分隔符，hive的字段会解析错误、出现错位的情况。它的内部是用正则表达式替换的方式把\n, \r, \01替换成""
--map-column-hive参数，显示把字段映射到Hive指定的类型
--map-column-java参数
sqoop import  \
--connect jdbc:mysql://hadoop1:3306/mysql  \
--username root  \
--password root  \
--table help_keyword  \
--fields-terminated-by "\t"  \
--lines-terminated-by "\n"  \
--hive-import  \
--hive-overwrite  \
--create-hive-table  \
--delete-target-dir \
--compress \
--compression-codec  org.apache.hadoop.io.compress.SnappyCodec \
--hive-database  mydb_test \
--hive-table new_help_keyword
# 增量

–check-column，用来指定一些列，这些列在导入时用来检查做决定数据是否要被作为增量数据，在一般关系型数据库中，都存在类似Last_Mod_Date的字段或主键。注意：这些被检查的列的类型不能是任意字符类型，例如Char，VARCHAR…（即字符类型不能作为增量标识字段） 
–incremental，用来指定增量导入的模式（Mode），append和lastmodified 
–last-value，指定上一次导入中检查列指定字段最大值
--merge-key id 使用lastmodified模式进行增量处理要指定增量数据是以append模式(附加)还是merge-key(合并)模式添加 

sqoop import   \
--connect jdbc:mysql://hadoop1:3306/mysql   \
--username root  \
--password root   \
--table help_keyword  \
--target-dir /user/hadoop/myimport_add  \
--incremental  append  \
--check-column  help_keyword_id \
--last-value 500  \
-m 1

# hbase
 --hbase-table指定数据直接导入到Hbase表而不是HDFS，对于每个输入行都会转换成HBase的put操作，每行的key取自输入的列，值转换成string、UTF-8格式存储在单元格里；所有的列都在同一列簇下，不能指定多个个列簇。

 --hbase-row-key:指定row key使用的列。默认是split-by作为row key，如果没有指定，会把源表的主键作为row key;如果row key是多个列组成的，多个列必须用逗号隔开，生成的row key是由用下划线隔开(`ID`_`RUN_ID`)的字段组合


sqoop import \
--connect jdbc:mysql://hadoop1:3306/mysql \
--username root \
--password root \
--table help_keyword \
--hbase-table new_help_keyword \
--column-family person \
--hbase-row-key help_keyword_id

# hdfs to mysql

export

--columns:指定插入目标数据库的字段，sqoop直接读取hdfs文件并把记录解析成多个字段，此时解析后的记录是没有字段名的，是通过位置和columns列表对应的，数据库插入的sql类似于:insert into _table (c1,c2...) value(v1,v2...)

--export-dir:指定HDFS输入文件的目录

--input-fields-terminated-by:字段之间分隔符

--input-lines-terminated-by:行分隔符



```

