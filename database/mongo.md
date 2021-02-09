./mongod --dbpath=/home/mongodb/data --fork --logpath=/home/mongodb/log/mongodb.log --storageEngine=wiredTiger


## window 安装服务
* mongod.exe --logpath "D:\install\mongo3.4\data\log\mongodb.log" --logappend --dbpath "D:\install\mongo3.4\data\db" --serviceName "MongoDB" --install
## centos 安装： 下载，解压，即可
`yum install libcurl openssl`  
`curl -O https://fastdl.mongodb.org/linux/mongodb-linux-x86_64-4.0.5.tgz`
## 安全配置
```shell
1. 配置文件 加上 权限开启参数 
security:
   authorization: enabled
或者启动mongod时 加上 --auth 参数
2. 在admin数据库里 添加用户和并赋给root角色
use amdin
db.createUser({user:"root",pwd:"123456",roles:[{role:"root",db:"admin"}]});
3. 重启服务
service mongod stop
mongod -f /etc/mongod.conf
4. 登陆 
//必须在你上一步创建用户时，配置用户所属的数据库下 登陆才行
./mongo
use admin
db.auth("root","123456")
//或者 连接server时登陆
mongo --port 27017 -u "root" -p "123456" --authenticationDatabase "admin"
5. 此时你就拥有了，该用户所属的角色、权限
```
## some
* MongoDB 中默认的数据库为 test，如果你没有创建新的数据库，集合将存放在 test 数据库中。

## shell command
* db.collection.help()
* db.help()
* show dbs
* use dbname 切换或创建 db
* db
* show tables
* show users  #显示用户
* db.stats()  #显示当前db状态
* db.getMongo()  ＃查看当前db的链接机器地址
* db.serverStatus()  #查看数据库服务器的状态
* db.createCollection("testcollection");
* db.dropDatabase()
* db.kx_persons.renameCollection("kx_phones")
* db.colName.drop()
* db.temp_add_user.renameCollection('temp_add_client')
* db.version() 查看mongodb版本
* db.collection.createIndex({Version:1},{background:true}) 创建索引（后台运行，不影响集合其他操作，副本集时，需在主节点操作）
* db.collection.getIndexes() 查看索引
* db.users.find( { name : { $exists: false } } )
## mongo 配置文件 （包含副本集配置项）
```sh
mkdir log  
mkdir data47017
cat /sys/kernel/mm/transparent_hugepage/enabled  
echo never > /sys/kernel/mm/transparent_hugepage/enabled 
echo never > /sys/kernel/mm/transparent_hugepage/defrag 
ulimit -a
ulimit -n 64000
ulimit -u  64000
```
```yml
systemLog:
   destination: file
   path: "/home/pmz/install/mongodb4/log/mongod.log47017"
   logAppend: true
storage:
   dbPath: "/home/pmz/install/mongodb4/data47017"
   engine: wiredTiger
   wiredTiger:
      engineConfig:
         journalCompressor: snappy
   directoryPerDB: true
   journal:
      enabled: true
processManagement:
   fork: true
net:
   bindIp: 0.0.0.0 # 允许远程访问，注意把此注释去掉
   port: 47017
#   ssl:
#      mode: disabled
setParameter:
   enableLocalhostAuthBypass: false
security:
   authorization: disabled 
replication:
   oplogSizeMB: 30720
   replSetName: test_repl

```

```shell
单节点启动
mongod -f mongod.conf
// 后台运行时，关闭mongod
use admin
db.shutdownServer()
// 副本集
//1
./bin/mongod --replSet replset --fork --port 27017 --dbpath /data/mongodb/data27017 --oplogSize 2048 --logpath /data/mongodb/log27017/mongod.log --logappend  

./bin/mongod --replSet replset --fork --port 27018 --dbpath /data/mongodb/data27018 --oplogSize 2048 --logpath /data/mongodb/log27018/mongod.log --logappend 

./bin/mongod --replSet replset --fork --port 27019 --dbpath /data/mongodb/data27019 --oplogSize 2048 --logpath /data/mongodb/log27019/mongod.log --logappend
//2
./bin/mongo
use admin
config = { _id:"replset", members:[
    {_id:0,host:"192.168.200.67:27017"},
    {_id:1,host:"192.168.200.67:27018"},
    {_id:2,host:"192.168.200.67:27019"}]
 };
 rs.initiate(config);

 //验证副本集
 use yes_db
 db.yes_users.insert({"uid":"20160611_0001"},{"uname":"tim.man"});

 // 设置副本集节点可读
 use yes_db
 db.getMongo().setSlaveOk(); 或者 rs.slaveOk()
 show tables;
 db.yes_users.find();  

 //  验证primary、secondary自动切换操作
 mongo localhost:27017
 use admin
 db.shutdownServer();
 mongo localhost:27017 此时会报错

 // 登录另一台
 mongo localhost:27018
 rs.status(); 查看副本集状态

 //再启动原来旧的primary库27017端口的mongodb（如果是实际上的坏了就是修复后启动），27017就会自动变成secondary状态。
 -----------------分割线---------------------------------------
登陆主节点服务:
use admin
删节点:
rs.remove("192.168.200.67:27019")

加节点:
rs.add("192.168.200.67:27019")

修改节点优先级,priority值越大优先级越高,最大的为主节点:
cfg=rs.conf()
cfg.members[2].priority=10
rs.reconfig(cfg)

-----------------分割线---------------------------------------
关闭节点服务:
use admin;
db.shutdownServer();

注:如果不行,用kill吧.
```
### insert

* db.COLLECTION_NAME.insert(document)  
如果该集合不在该数据库中， MongoDB 会自动创建该集合并插入文档。
* 插入文档你也可以使用 db.col.save(document) 命令。如果不指定 _id 字段 save() 方法类似于 insert() 方法。如果指定 _id 字段，则会更新该 _id 的数据。
### update 巨坑的规范，与mysql不一样：要更新匹配的多条数据，要加选项（看示例），否则只更新匹配的第一条数据

```js
db.collection.update(
   <query>,
   <update>,
   {
     upsert: <boolean>,
     multi: <boolean>,
     writeConcern: <document>
   }
)
db.collection.save(
   <document>,
   {
     writeConcern: <document>
   }
)
db.col.update({'title':'MongoDB 教程'},{$set:{'title':'MongoDB'}},false,true)
 db.order.update({orderId:'20180312080841605P0001'},{$set:{busiStatus:'requestFail'}},false,false)

 db.signForRegSum.update({phone:"18502465511"},{$set:{sum:NumberInt("5158")}})
```

### remove
```js
db.collection.remove(
   <query>,
   {
     justOne: <boolean>,
     writeConcern: <document>
   }
)
db.col.remove({'title':'MongoDB 教程'})
```
* 如果你只想删除第一条找到的记录可以设置 justOne 为 1，如下所示：
>db.COLLECTION_NAME.remove(DELETION_CRITERIA,1)

* 如果你想删除所有数据，可以使用以下方式（类似常规 SQL 的 truncate 命令）：
>db.col.remove({})

### find
* db.collection.find(query, projection) 例如：
```js
db.inventory.find(
   { type: "food", item:/^c/ },
   { item: 1, _id: 0 }
)
```
* db.col.find().pretty()
* 除了 find() 方法之外，还有一个 findOne() 方法，它只返回一个文档。
### [distinct](http://docs.mongoing.com/manual-zh/reference/method/db.collection.distinct.html)
`db.collection.distinct(field, query, options);`
`db.media.distinct( key, query, <optional params> ) - e.g. db.media.distinct( 'x' ), optional parameters are: maxTimeMS`

# 数据库目录迁移

## 迁移记录

1. 在home创建数据库目录：mkdir -p /home/data/mongodb_27017_newdata
2. 查找mongodb数据库相关目录：ps -ef|grep mongodb
3. cd /var/data/mongodb/bin/
4. 备份mongod.config文件：sz mongod.config 
5. 关闭本机mongod服务（不行，用kill）：./mongod --shutdown --dbpath /var/data/mongodb/data
6. 修改mongod.config文件：vi /var/data/mongodb/bin/mongod.config  
dbPath: /var/data/mongodb/data   
修改成：dbPath: /home/data/mongodb_27017_newdata  
7. 启动服务：./mongod -f mongod.config


## 测试

1.登陆：  ./mongo ip:27017/badurl  
2. use badurl  
3. db.getMongo().setSlaveOk();  
4. show tables  
5. db.dpi_bad_url.find()  





# 数据库集群添加用户密码
参照文档:http://blog.csdn.net/monkey_four/article/details/50854410

1. 创建root用户  
use admin   
db.createUser({ user: "root", pwd: "ever123", roles: [ { role: "root", db: "admin" } ] })

2. 创建badurl库的普通用户:ever,密码:ever123  
use badurl  
db.createUser({'user':'ever', pwd:'ever123', roles:[{ role: "readWrite", db: "badurl" }]})  

3. 生成mongodb-keyfile  
openssl rand -base64 741 > /var/data/mongodb/mongodb-keyfile  
chmod 600 /var/data/mongodb/mongodb-keyfile  

将mongodb-keyfile 复制到从节点中,再给个600权限;  


4.  修改mongod.config  
主和从节点添加:  
security:   
 authorization: enabled   
 keyFile: /data/mongodb/mongodb-keyfile  

5.  重新启动主和从节点服务  

6. 测试认证  
use admin  
db.auth("root", "ever123")   
返回1表示认证成功．  
rs.status();  

7. 密码登陆测试  
./mongo -u root -p ever123 --host 192.168.171.131:27017 --authenticationDatabase=admin  
./mongo -u ever -p ever123 --host 192.168.171.131:27017 --authenticationDatabase=badurl  
use admin  
db.auth("root", "ever123")    
rs.status();  


## 导入 导出 [mongoexport](https://docs.mongodb.com/manual/reference/program/mongoexport/)
* `./mongoexport --help` 
* `./mongoexport -h [IP]:[port] -d [db] -c [collection] -u [user] -p [password]--port 27018 -q '{insertDate:{$gt:ISODate("2017-07-18T11:00:00.603Z")}}' -o ./HeartLogin.dat`

* `./mongoexport -d CommGuard -c HeartLogin -q '{insertDate:{$gte:ISODate("2017-07-19T16:00:00.000Z"),$lt:ISODate("2017-07-24T16:00:00.000Z")}}' --sort '{createDate:-1}'--type=csv -f phone,insertDate > HeartLogin.csv`
* `./mongoimport -u root -p pwd --host 192.168.200.67:27010 --authenticationDatabase=admin -d test -c aaa --file /home/pmz/tmp/用户感染事件0817记录.csv --type csv --headerline`  
* `./mongoexport -d CallCloudManager -c V2_PushRecordAll -q '{createDate:{$gte:ISODate("2017-08-17T16:00:00.000Z")},proCode:{$exists:false}}' -u root -p pwd --host 192.168.243.140:27017 --authenticationDatabase=admin --out /home/pmz/temp/push.json`
<!-- 注意正则表达式 元字符要转义 -->
* `mongoexport -d test -c records -q '{ a: { $gte: 3 } }' --out exportdir/myRecords.json`
* `./mongoimport -d CommGuard -c HeartLogin ./HeartLogin.dat`  
* 大文件导入: 因为Mongo对单次处理好像有大小限制（16m）
所以大文件会出问题,这应该是个Bug mongoimport 默认会10000条 为一个批量导入数据，但实际上单条数据太大了,每10000条导入一次肯定是不行的.
参数 --batchSize 可以指定每次批量导入的条数 设置小一些就OK了，可设置为 --batchSize：50
* --numInsertionWorkers 并发执行线程数，最好设置成cpu 核数
* `./mongoimport -d CallCloudManager -c V2_OperationLog1711 -u user -p pwd --host 192.168.243.142:27017 --authenticationDatabase=admin --file ./V2_OperationLog.json --mode upsert --stopOnError --numInsertionWorkers 4 --batchSize：50`

# 聚合
```js
// 按时间分组（本地时间：北京，东八区）貌似网上很少有人提到时区这个问题，
// $dateToString 日期这个格式化，是utc时间，所以单纯格式化，不是本地时间，暂时没找到好的办法，所以 用$project 映射一下，在原有日期字段加八个小时，在做后边的分组查询
db.V2_PushRecordAll.aggregate([{$project:{ctime:{$add:["$createDate",8*60*60*1000]},status:1,proCode:1,content:1}},{$match:{status:1,content:{$regex:/\"uuid\":26/},ctime:{$gte:ISODate("2017-08-17T00:00:00"),$lt:ISODate("2017-08-24T00:00:00")}}},{$group:{_id:{date:{ $dateToString: { format: "%Y-%m-%d", date: "$ctime"} },proCode:"$proCode"},pushNum:{$sum:1 } } },{$sort:{"_id.date":-1}}])
// 分组 在分组，实现类似 distinct的功能
db.V2_PushRecordAll.aggregate([{$match:{status:1,content:{$regex:/\"uuid\":26/},createDate:{$gte:ISODate("2017-08-17T16:00:00"),$lt:ISODate("2017-08-23T16:00:00")}}},{$group:{_id:{proCode:"$proCode",imsi:"$imsi"}}},{$group:{_id:{proCode:"$_id.proCode"},num:{$sum:1}}}])

```

## 求和
```js
// 单纯求某个数值类型字段(例如column_a)值的和
db.table.aggregate([{$group:{_id:null,total:{$sum:"$column_a"} } }])m
```
## mongo-drives-java
```java
AggregationOptions options = AggregationOptions
                .builder().allowDiskUse(true).maxTime(1L, TimeUnit.HOURS).build();
        List<DBObject> pipes = new ArrayList<DBObject>();
        BasicDBList add = new BasicDBList();
        add.add("$createDate");
        add.add((8 * 60 * 60 * 1000L));
        BasicDBObject project = new BasicDBObject("ctime",new BasicDBObject("$add",add)).append("status",1).append("proCode",1).append("content",1);
        BasicDBObject match = new BasicDBObject("status",1).append("content",new BasicDBObject("$regex", Pattern.compile("\\\"uuid\\\":26")))
                .append("ctime",new BasicDBObject("$gte",st).append("$lt",ed));
        BasicDBObject group = new BasicDBObject("_id",new BasicDBObject("date",new BasicDBObject("$dateToString",new BasicDBObject("format","%Y-%m-%d").append("date","$ctime")))
                .append("proCode","$proCode")).append("pushNum",new BasicDBObject("$sum", 1));

        pipes.add(new BasicDBObject("$project",project));
        pipes.add(new BasicDBObject("$match",match));
        pipes.add(new BasicDBObject("$group",group));
        BasicDBObject col = new BasicDBObject();
        Cursor cursor =  pushRecord.aggregate(pipes,options);
        while (cursor.hasNext()){
            BasicDBObject obj = (BasicDBObject)cursor.next();
            BasicDBObject g = (BasicDBObject)obj.get("_id");
            log.info(g.getString("date"));
            log.info(g.getString("proCode"));
        } 
```

## spring-data-mongo
```java
MatchOperation match = Aggregation.match(Criteria.where("status").is(1).and("content").regex("\"uuid\":26").and("createDate").gte(st).lt(ed));
        ProjectionOperation project = Aggregation.project("proCode").and("createDate").plus(8*60*60*1000).as("addtime");
        ProjectionOperation projectTime = Aggregation.project("proCode").and("addtime").dateAsFormattedString("%Y-%m-%d").as("ctime");
        GroupOperation group = Aggregation.group("ctime", "proCode").count().as("pushNum");
        SortOperation sort = Aggregation.sort(Sort.Direction.ASC, "_id.ctime");
        Aggregation agg = Aggregation.newAggregation(match,project,projectTime,group,sort);
        log.info("countPushNum-agg={}",agg.toString());
        AggregationResults<BasicDBObject> v2_pushRecordAll = mongoTemplate.aggregate(agg, "V2_PushRecordAll", BasicDBObject.class);
        List<BasicDBObject> mappedResults = v2_pushRecordAll.getMappedResults();
        for (BasicDBObject basicDBObject: mappedResults){
            System.out.println(basicDBObject.toJson());
        }
```