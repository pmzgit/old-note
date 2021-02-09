# 参考or工具
* [中文文档](http://doc.codingdict.com/elasticsearch/)
* [Elastic Search 介绍和基本概念](https://www.jianshu.com/p/86a8c085e604)
* [https://next.json-generator.com/](https://next.json-generator.com/)
* [dsl](http://www.youmeek.com/elasticsearch-dsl/)

# 基础
* 对时序数据进行建模的话，会包含三个重要部分，分别是：主体，时间点和测量值。
* [RESTful API 最佳实践](http://www.ruanyifeng.com/blog/2018/10/restful-api-best-practices.html)

在我看来，post和put的本质区别即在于是否具有幂等性（put语义上具有幂等性），2者都可以用于创建和更新，这取决与你的设计，所以更多的是语义
* [AJAX发送PUT和DELETE请求注意事项](https://blog.csdn.net/liuyuanjiang109/article/details/78972644)

* 集群名称elasticsearch
* 节点（Node） 

第一种，索引(indexing，动词，对应于关系型数据库的插入 insert)指的是把一个文档存储到索引(index，名词) 中；第二种的索引(index，名词）对应于关系型数据库的数据库，这里一定要根据上下文来进行理解。一般来说，我们会对数据库增加索引（这里是第三种意思，就是传统的索引的定义）来提高检索效率，Elasticsearch 和 Lucene 使用『倒排索引』的数据结构来完成这个工作（传统数据库一般用红黑树或者 B 树来完成）。默认情况下，文档中的每个字段都会拥有其对应的倒排索引，Elasticsearch 也是通过这个来进行检索的。

结点的三个角色  
主结点：master节点主要用于集群的管理及索引 比如新增结点、分片分配、索引的新增和删除等。   
数据结点：data 节点上保存了数据分片，它负责索引和搜索操作。   
客户端结点：client 节点仅作为请求客户端存在，client的作用也作为负载均衡器，client 节点不存数据，只是将请求均衡转发到其它结点。

通过下边两项参数来配置结点的功能：  默认值 true
node.master: #是否允许为主结点  
node.data: #允许存储数据作为数据结点  
node.ingest: #是否允许成为协调节点，  
四种组合方式：  
master=true，data=true：即是主结点又是数据结点  
master=false，data=true：仅是数据结点  
master=true，data=false：仅是主结点，不存储数据  
master=false，data=false：即不是主结点也不是数据结点，此时可设置ingest为true表示它是一个客户端  

* 分片就是一个Lucene实例,当你的集群扩容或缩小，Elasticsearch将会自动在你的节点间迁移分片，以使集群保持平衡。索引创建完成的时候，主分片的数量就固定了，但是复制分片的数量可以随时调整

curl -XGET http://192.168.205.235:9222/_settings?pretty

PUT /blogs
{
  "settings": {
    "index": {
      "number_of_shards": 5,
      "number_of_replicas": 1
    }
  }
}

主分片或者复制分片都可以处理读请求——搜索或文档检索，所以数据的冗余越多，我们能处理的搜索吞吐量就越大。

PUT /blogs/_settings
{
   "number_of_replicas" : 2
}

在同样数量的节点上增加更多的复制分片并不能提高性能，因为这样做的话平均每个分片的所占有的硬件资源就减少了

* 索引名：全部小写

删除指定多个索引：DELETE /product_index,order_index  
删除匹配符索引：DELETE /product_*  
删除所有索引：DELETE /_all  

* 每个索引可以被拆分成多个分片，一个索引可以设置 0 个（没有副本）或多个副本。开启副本后，每个索引将有主分片（被复制的原始分片）和副本分片（主分片的副本）。分片和副本的数量在索引被创建时都能够被指定。在创建索引后，您也可以在任何时候动态的改变副本的数量，但是不能够改变分片数量。默认情况下，Elasticsearch 中的每个索引分配了 5 个主分片和 1 个副本，这也就意味着如果您的集群至少有两个节点的话，您的索引将会有 5 个主分片和另外 5 个副本分片（1 个完整的副本），每个索引共计 10 个分片。每个 Elasticsearch 分片是一个 Lucene 索引。在单个 Lucene 索引中有一个最大的文档数量限制。从 LUCENE-5843 的时候开始，该限制为 2,147,483,519（=Interger.MAX_VALUE - 128）个文档。您可以使用 _cat/shards api 来监控分片大小。
* 计算机语言：[DSL](https://draveness.me/dsl) 、GPL（ General Purpose Language 的简称，即通用编程语言，也就是我们非常熟悉的 Objective-C、Java、Python 以及 C 语言等等。）
* DSL: 为了解决某一类任务而专门设计的计算机语言。但是在里所说的 DSL(外部 DSL) 并不是图灵完备的，它们的表达能力有限，只是在特定领域解决特定任务的。DSL 通过在表达能力上做的妥协换取在某一领域内的高效.Regex,SQL,HTML & CSS
* 没有计算和执行的概念；其本身并不需要直接表示计算；使用时只需要声明规则、事实以及某些元素之间的层级和关系；
* 与 GPL 相对，DSL 与传统意义上的通用编程语言 C、Python 以及 Haskell 完全不同。通用的计算机编程语言是可以用来编写任意计算机程序的，并且能表达任何的可被计算的逻辑，同时也是 图灵完备 的。
# docker 安装
* [compatibility](https://www.elastic.co/support/matrix#matrix_compatibility)
* [dockerfile](https://github.com/elastic/dockerfiles/)
```sh
grep vm.max_map_count /etc/sysctl.conf


docker pull docker.elastic.co/elasticsearch/elasticsearch:6.6.0
sysctl -w vm.max_map_count=262144

./elasticsearch -Ecluster.name=es_cluster -Enode.name=node01 -E path.data=/dir -d

docker run -d -it --name es-9200 -p 9200:9200 -p 9300:9300 -e "discovery.type=single-node" elasticsearch


docker run -d --restart=always --name es6 --net nw-efk -p 9200:9200 -p 9300:9300 -e "discovery.type=single-node" docker.elastic.co/elasticsearch/elasticsearch:6.6.0


curl http://localhost:9200


version: '3.7'

services:
  es01:
    image: elasticsearch:7.1.1
    ports:
      - "9222:9200"
      - "9333:9300"
    environment:
      - node.name=es01
      - discovery.type=single-node
      - cluster.name=docker-cluster
      - bootstrap.memory_lock=true
      - xpack.security.enabled=false
      - "ES_JAVA_OPTS=-Xms512m -Xmx512m"
    ulimits:
      memlock:
        soft: -1
        hard: -1  
    volumes:
      - es7_data4:/usr/share/elasticsearch/data
    networks:
      - efk_net
    deploy:
      replicas: 1
      placement:
        constraints: ["node.role == manager"]
      
  kibana:
    image: kibana:7.1.1
    
    #volumes:
    #- kibana_data:/usr/share/kibana/config/kibana.yml
    ports:
      - 5601:5601
    environment:
      ELASTICSEARCH_HOSTS: 'http://es01:9200'
    networks:
      - efk_net
    depends_on:
      - es7
    deploy:
      replicas: 1
      placement:
        constraints: ['node.role == manager'] 
  cerebro:
    image: lmenezes/cerebro:latest
    
    ports:
      - "9002:9000"
    networks:
      - efk_net      
        
volumes:
  es7_data4:
  
networks:
  efk_net:

```


## 认证配置

### basic auth
* https://github.com/elasticfence/elasticsearch-http-user-auth
curl -u root:pmz123098 192.168.28.13:9200/_cat/indices?v
### xpack
```sh
6.3 之前 启动trial license（30天试用）
curl -H "Content-Type:application/json" -XPOST  http://127.0.0.1:19200/_xpack/license/start_trial?acknowledge=true
6.3+
xpack.security.enabled=true  
xpack.monitoring.collection.enabled
每个节点执行

bin/elasticsearch-setup-passwords interactive

elastic,apm_system,kibana,logstash_system,beats_system,remote_monitoring_user

elastic
默认密码changeme
修改kibana配置文件
elasticsearch.username: "elastic"
elasticsearch.password: "changeme"
docker 下
ELASTICSEARCH_USERNAME
ELASTICSEARCH_PASSWORD

http://192.168.205.235:9222/_xpack/security/user?pretty
http://192.168.205.235:9222/_xpack/security/role?pretty
curl -XPUT -u elastic '192.168.205.235:9222/_xpack/security/user/elastic/_password' 
-d '{
  "password" : "elastic"
}'
```
# [rest api](https://www.elastic.co/guide/en/elasticsearch/reference/6.5/getting-started-explore.html)

* java api  
节点客户端(node client)：节点客户端加入集群，但是并不存储数据，但知道数据再集群的具体位置，并且能够转发请求到对应节点上。   
传输客户端(Transport client)：节点本身不加入集群，只简单发送请求给集群中的节点，这个更轻量。  
两个客户端都是通过9300端口进行访问，并使用Elasticsearch传输协议进行通信(ETP:Elasticsearch Transport Protocol)，集群节点间也是使用9300端口进行通信。
* 基于http协议  
基于HTTP协议，以JSON为数据交互格式的RESTful API,非java语言可以使用RESTful API形式与ES进行交互，使用9200端口。
```sh
# 功能
Check your cluster, node, and index health, status, and statistics
Administer your cluster, node, and index data and metadata
Perform CRUD (Create, Read, Update, and Delete) and search operations against your indexes
Execute advanced search operations such as paging, sorting, filtering, scripting, aggregations, and many others

curl http://127.0.0.1:9200/_cat/health?v
http://192.168.205.235:9222/_cluster/health?pretty
curl -XGET 'localhost:9200/_cat/nodes?v'
curl -XGET 'localhost:9200/_cat/indices?v'
http://192.168.205.235:9222/_cat/indices/fluentbit-2019.*?v
http://10.10.2.187:9222/_cat/shards?v
http://192.168.200.236:9200/hdd_url_test?pretty

curl -XGET "http://es7:9200/fluentbit-2019.08.15/_count?pretty"

7.4 elasticsearch常用监控地址
elasticsearch常用监控地址：将ip地址调整为服务器ip即可

http://192.168.205.235:9222/_nodes/http?pretty

http://192.168.205.235:9222/_nodes/stats?pretty

http://192.168.205.235:9222/_cluster/health?pretty

http://192.168.205.235:9222/_cluster/stats?pretty

http://192.168.205.235:9222/_settings?pretty

http://192.168.205.235:9222/_cat/indices?v



#  <HTTP Verb> /<Index>/<Type>/<ID>

curl -X PUT "localhost:9200/customer?pretty"
{
  "acknowledged" : true,
  "shards_acknowledged" : true,
  "index" : "customer"
}
curl -X GET "localhost:9200/_cat/indices?v"

# 全量更新
curl -X PUT "localhost:9200/customer/_doc/1?pretty" -H 'Content-Type: application/json' -d'
{
  "name": "John Doe"
}
'
curl -X GET "localhost:9200/customer/_doc/1?pretty"

curl -X DELETE "localhost:9200/customer?pretty"
curl -X GET "localhost:9200/_cat/indices?v"

# https://es.xiaoleilu.com/030_Data/50_Mget.html

# PUT方法—— “在这个URL中存储文档”变成了POST方法—— "在这个类型下存储文档",自动生成的ID有22个字符长，URL-safe, Base64-encoded string universally unique identifiers

curl -X POST "localhost:9200/customer/_doc?pretty" -H 'Content-Type: application/json' -d'
{
  "name": "Jane Doe"
}
'
# 增量更新
 Whenever we do an update, Elasticsearch deletes the old document and then indexes a new document with the update applied to it in one shot.

curl -X POST "localhost:9200/customer/_doc/vQupl2gB6iA4RqJrXkOy/_update?pretty" -H 'Content-Type: application/json' -d'
{
  "doc": { "name": "Jane Doe","age":20 }
}
'
# groovy
这时候当API不能满足要求时，Elasticsearch允许你使用脚本实现自己的逻辑。脚本支持非常多的API，例如搜索、排序、聚合和文档更新。脚本可以通过请求的一部分、检索特殊的.scripts索引或者从磁盘加载方式执行。
默认的脚本语言是Groovy，一个快速且功能丰富的脚本语言，语法类似于Javascript。它在一个沙盒(sandbox)中运行，以防止恶意用户毁坏Elasticsearch或攻击服务器。

# https://www.elastic.co/guide/en/elasticsearch/reference/6.4/search-request-script-fields.html

POST /website/pageviews/1/_update?retry_on_conflict=5
{
    "script": "ctx._source.views+=1",
    "upsert": {
        "views": 0
    }
}

# https://www.elastic.co/guide/en/elasticsearch/reference/6.4/modules-scripting-fields.html

he doc['field'] will throw an error if field is missing from the mappings. In painless, a check can first be done with doc.containsKey('field') to guard accessing the doc map. Unfortunately, there is no way to check for the existence of the field in mappings in an expression script.


curl -X POST "localhost:9200/customer/_doc/vQupl2gB6iA4RqJrXkOy/_update?pretty" -H 'Content-Type: application/json' -d'
{
  "script" : "ctx._source.age += 5"
}
'
# 处理并发读写操作


PUT products/_doc/1?if_seq_no=1&if_primary_term=1
{
  "title":"iphone",
  "count":100
}
# 外部版本控制系统
一种常见的结构是使用一些其他的数据库做为主数据库，然后使用Elasticsearch搜索数据，这意味着所有主数据库发生变化，就要将其拷贝到Elasticsearch中。如果有多个进程负责这些数据的同步，就会遇到上面提到的并发问题。
如果主数据库有版本字段——或一些类似于timestamp等可以用于版本控制的字段——是你就可以在Elasticsearch的查询字符串后面添加version_type=external来使用这些版本号。版本号必须是整数，大于零小于9.2e+18——Java中的正的long。

外部版本号与之前说的内部版本号在处理的时候有些不同。它不再检查_version是否与请求中指定的一致，而是检查是否小于指定的版本。如果请求成功，外部版本号就会被存储到_version中。
外部版本号不仅在索引和删除请求中指定，也可以在创建(create)新文档中指定。

PUT /website/blog/2?version=5&version_type=external
{
  "title": "My first external blog entry",
  "text":  "Starting to get the hang of this..."
}

# batch
The Bulk API does not fail due to failures in one of the actions. If a single action fails for whatever reason, it will continue to process the remainder of the actions after it. When the bulk API returns, it will provide a status for each action (in the same order it was sent in) so that you can check if a specific action failed or not.

curl -X POST "localhost:9200/customer/_doc/_bulk?pretty" -H 'Content-Type: application/json' -d'
{"index":{}}
{"name": "John Doe" }
{"index":{"_id":"2"}}
{"name": "Jane Doe" }
'

curl -X POST "localhost:9200/customer/_doc/_bulk?pretty" -H 'Content-Type: application/json' -d'
{"update":{"_id":"1"}}
{"doc": { "name": "John Doe becomes Jane Doe" } }
{"delete":{"_id":"2"}}
'

curl -H "Content-Type: application/json" -XPOST "localhost:9200/bank/_doc/_bulk?pretty&refresh" --data-binary "@accounts.json"
curl "localhost:9200/_cat/indices?v"

POST _bulk
{ "index" : { "_index" : "test", "_id" : "1" } }
{ "field1" : "value1" }
{ "delete" : { "_index" : "test", "_id" : "2" } }
{ "create" : { "_index" : "test2", "_id" : "3" } }
{ "field1" : "value3" }
{ "update" : {"_id" : "1", "_index" : "test"} }
{ "doc" : {"field2" : "value2"} }


curl -XGET "http://es01:9200/test/_mget" -H 'Content-Type: application/json' -d'
{
    "docs" : [
        {

            "_id" : "1"
        },
        {

            "_id" : "2"
        }
    ]
}'

curl -XGET "http://es01:9200/_mget" -H 'Content-Type: application/json' -d'
{
    "docs" : [
        {
            "_index" : "test",
            "_id" : "1"
        },
        {
            "_index" : "test",
            "_id" : "2"
        }
    ]
}'

curl -XGET "http://es01:9200/_mget" -H 'Content-Type: application/json' -d'
{
    "docs" : [
        {
            "_index" : "test",
            "_id" : "1",
            "_source" : false
        },
        {
            "_index" : "test",
            "_id" : "2",
            "_source" : ["field3", "field4"]
        },
        {
            "_index" : "test",
            "_id" : "3",
            "_source" : {
                "include": ["user"],
                "exclude": ["user.location"]
            }
        }
    ]
}'

# search

查全率
查准率
相关度评分

/_search
GET /_all/product,order/_search
在所有索引的所有类型中搜索
/gb/_search
在索引gb的所有类型中搜索
/gb,us/_search
在索引gb和us的所有类型中搜索
/g*,u*/_search
在以g或u开头的索引的所有类型中搜索

#ignore_unavailable=true，可以忽略尝试访问不存在的索引“404_idx”导致的报错
#查询movies分页
POST /movies,404_idx/_search?ignore_unavailable=true
{
  "profile": true,
	"query": {
		"match_all": {}
	}
}

POST /kibana_sample_data_ecommerce/_search
{
  "from":10,
  "size":20,
  "query":{
    "match_all": {}
  }
}


#对日期排序
POST kibana_sample_data_ecommerce/_search
{
  "sort":[{"order_date":"desc"}],
  "query":{
    "match_all": {}
  }

}

#source filtering 支持通配符
POST kibana_sample_data_ecommerce/_search
{
  "_source":["order_date*"],
  "query":{
    "match_all": {}
  }
}


#脚本字段
GET kibana_sample_data_ecommerce/_search
{
  "script_fields": {
    "new_field": {
      "script": {
        "lang": "painless",
        "source": "doc['order_date'].value+'hello'"
      }
    }
  },
  "query": {
    "match_all": {}
  }
}


POST movies/_search
{
  "query": {
    "match": {
      "title": "last christmas"
    }
  }
}

POST movies/_search
{
  "query": {
    "match": {
      "title": {
        "query": "last christmas",
        "operator": "and"
      }
    }
  }
}

POST movies/_search
{
  "query": {
    "match_phrase": {
      "title":{
        "query": "one love"

      }
    }
  }
}

POST movies/_search
{
  "query": {
    "match_phrase": {
      "title":{
        "query": "one love",
        "slop": 1

      }
    }
  }
}



curl -X GET "localhost:9200/bank/_search?q=*&sort=account_number:asc&pretty"

curl -X GET "localhost:9200/bank/_search" -H 'Content-Type: application/json' -d'
{
  "query": { "match_all": {} },
  "sort": [
    { "account_number": "asc" }
  ]
}


curl -XPOST "http://es01:9200/kibana_sample_data_ecommerce/_msearch" -H 'Content-Type: application/json' -d'
{}
{"query" : {"match_all" : {}},"size":1}
{"index" : "kibana_sample_data_flights"}
{"query" : {"match_all" : {}},"size":2}
'

# 确切的匹配若干个单词或者短语(phrases)。
match_phrase

# highlight

{
    "query" : {
        "match_phrase" : {
            "about" : "rock climbing",
            "slop": 1
        }
    },
    "highlight": {
        "fields" : {
            "about" : {}
        }
    }
}
# 在返回结果中会有一个新的部分叫做highlight，这里包含了来自about字段中的文本，并且用<em></em>来标识匹配到的单词
{
   ...
   "hits": {
      "total":      1,
      "max_score":  0.23013961,
      "hits": [
         {
            ...
            "_score":         0.23013961,
            "_source": {
               "first_name":  "John",
               "last_name":   "Smith",
               "age":         25,
               "about":       "I love to go rock climbing",
               "interests": [ "sports", "music" ]
            },
            "highlight": {
               "about": [
                  "I love to go <em>rock</em> <em>climbing</em>" <1>
               ]
            }
         }
      ]
   }
}
'


took – time in milliseconds for Elasticsearch to execute the search
timed_out – tells us if the search timed out or not
time_out值告诉我们查询超时与否。一般的，搜索请求不会超时。如果响应速度比完整的结果更重要，你可以定义timeout参数为10或者10ms（10毫秒），或者1s（1秒）
GET /_search?timeout=10ms
Elasticsearch将返回在请求超时前收集到的结果。
超时不是一个断路器（circuit breaker）（译者注：关于断路器的理解请看警告）。
警告
需要注意的是timeout不会停止执行查询，它仅仅告诉你目前顺利返回结果的节点然后关闭连接。在后台，其他分片可能依旧执行查询，尽管结果已经被发送。
使用超时是因为对于你的业务需求（译者注：SLA，Service-Level Agreement服务等级协议，在此我翻译为业务需求）来说非常重要，而不是因为你想中断执行长时间运行的查询。
_shards – tells us how many shards were searched, as well as a count of the successful/failed searched shards
hits – search results
hits.total – total number of documents matching our search criteria
hits.hits – actual array of search results (defaults to first 10 documents)
hits.sort - sort key for results (missing if sorting by score)
hits._score and max_score - 默认情况下，Elasticsearch根据结果相关性评分来对结果集进行排序，所谓的「结果相关性评分」就是文档与查询条件的匹配程度。很显然，排名第一的John Smith的about字段明确的写到“rock climbing”。
但是为什么Jane Smith也会出现在结果里呢？原因是“rock”在她的abuot字段中被提及了。因为只有“rock”被提及而“climbing”没有，所以她的_score要低于John。

这个例子很好的解释了Elasticsearch如何在各种文本字段中进行全文搜索，并且返回相关性最大的结果集。相关性(relevance)的概念在Elasticsearch中非常重要，而这个概念在传统关系型数据库中是不可想象的，因为传统数据库对记录的查询只有匹配或者不匹配。



# 分页与遍历 - From, Size, Search_after & Scroll API

from: 跳过开始的结果数，默认0
GET /_search?size=5
GET /_search?size=5&from=5
GET /_search?size=5&from=10&pretty

POST users/_search
{
    "size": 1,
    "query": {
        "match_all": {}
    },
    "sort": [
        {"age": "desc"} ,
        {"_id": "asc"}    
    ]
}

POST users/_search
{
    "size": 1,
    "query": {
        "match_all": {}
    },
    "search_after":
        [
          10,
          "ZQ0vYGsBrR8X3IP75QqX"],
    "sort": [
        {"age": "desc"} ,
        {"_id": "asc"}    
    ]
}

POST /users/_search?scroll=5m
{
    "size": 1,
    "query": {
        "match_all" : {
        }
    }
}

POST /_search/scroll
{
    "scroll" : "1m",
    "scroll_id" : "DXF1ZXJ5QW5kRmV0Y2gBAAAAAAAAAWAWbWdoQXR2d3ZUd2kzSThwVTh4bVE0QQ=="
}

### Dynamic Mapping 和常见字段类型

Mapping中的已有字段一旦设定后，禁止直接修改。因为倒排索引生成后不允许直接修改。需要重新建立新的索引，做reindex操作。

类似数据库中的表结构定义，主要作用

定义所以下的字段名字
定义字段的类型
定义倒排索引相关的配置（是否被索引？采用的Analyzer）
对新增字段的处理 
true mapping 会被更新
false mapping 不会被更新，新增字段无法被索引，但是信息会出现在source
strict 文档写入失败

默认Mapping支持dynamic

curl -XPUT "http://es01:9200/dynamic_mapping_test/_mapping" -H 'Content-Type: application/json' -d'
{
  "dynamic": false
}'

在object下，支持做dynamic的属性的定义

# [date](https://www.elastic.co/guide/en/elasticsearch/reference/7.x/date.html)


### 确切值(exact values)：数字，日期，keyword
### 全文文本(full text)：非结构化文本

这两者的区别才真的很重要 - 这是区分搜索引擎和其他数据库的根本差异。



# 映射
http://192.168.205.235:9222/.kibana_1/_mapping?pretty

当你索引一个包含新字段的文档——一个之前没有的字段——Elasticsearch将使用动态映射猜测字段类型，这类型来自于JSON的基本数据类型，使用以下规则：
* https://www.elastic.co/guide/en/elasticsearch/reference/7.1/dynamic-mapping.html
JSON type	Field type
Boolean: true or false	"boolean"
Whole number: 123	"long"
Floating point: 123.45	"float"
String, valid date: "2014-09-15"	"date"
String: "foo bar"	"text" 和 "keyword"
String: "233"	"float" 或 "long"， 默认关闭
空值： 忽略
https://www.cnblogs.com/shoufeng/p/10692113.html

## 数组
数组中所有值必须为同一类型。你不能把日期和字符串混合。如果你创建一个新字段，这个字段索引了一个数组，Elasticsearch将使用第一个值的类型来确定这个新字段的类型。当你从Elasticsearch中取回一个文档，任何一个数组的顺序和你索引它们的顺序一致。你取回的_source字段的顺序同样与索引它们的顺序相同。
然而，数组是做为多值字段被索引的，它们没有顺序。在搜索阶段你不能指定“第一个值”或者“最后一个值”。倒不如把数组当作一个值集合(bag of values)

当然数组可以是空的为空字段而不被索引：
"empty_string":             "",
"null_value":               null,
"empty_array":              [],
"array_with_null_value":    [ null ]

#处理多值字段，term 查询是包含，而不是等于

curl -XPOST "http://es01:9200/movies/_search" -H 'Content-Type: application/json' -d'
{
  "query": {
    "constant_score": {
      "filter": {
        "term": {
          "genre.keyword": "Comedy"
        }
      }
    }
  }
}'

# 复合类型


## 内部对象的映射
Elasticsearch 会动态的检测新对象的字段，并且映射它们为 object 类型，将每个字段加到 properties 字段下

内部对象是怎样被索引的
Lucene 并不了解内部对象。 一个 Lucene 文件包含一个键-值对应的扁平表单。 为了让 Elasticsearch 可以有效的索引内部对象，将文件转换为以下格式：
{
    "tweet":            [elasticsearch, flexible, very],
    "user.id":          [@johnsmith],
    "user.gender":      [male],
    "user.age":         [26],
    "user.name.full":   [john, smith],
    "user.name.first":  [john],
    "user.name.last":   [smith]
}
# nested类型而不是object类型， 每个嵌套对象会被索引为一个隐藏分割文档
藉由分别索引每个嵌套对象，对象的栏位中保持了其关联。 我们的查询可以只在同一个嵌套对象都匹配时才回应。
不仅如此，因嵌套对象都被索引了，连接嵌套对象至根文档的查询速度非常快--几乎与查询单一文档一样快。

这些额外的嵌套对象被隐藏起来，我们无法直接访问他们。 为了要新增丶修改或移除一个嵌套对象，我们必须重新索引整个文档。 要牢记搜寻要求的结果并不是只有嵌套对象，而是整个文档。

###　https://www.elastic.co/guide/en/elasticsearch/reference/7.1/index-options.html
index参数控制字符串以何种方式被索引。它包含以下三个值当中的一个：
值	解释
analyzed	首先分析这个字符串，然后索引。换言之，以全文形式索引此字段。
not_analyzed	索引这个字段，使之可以被搜索，但是索引内容和指定值一样。不分析此字段。
no	不索引这个字段。这个字段不能为搜索到。

string类型字段默认值是analyzed。如果我们想映射字段为确切值，我们需要设置它为not_analyzed：
{
    "tag": {
        "type":     "string",
        "index":    "not_analyzed",
        "analyzer": "english"
    }
}
其他简单类型（long、double、date等等）也接受index参数，但相应的值只能是no和not_analyzed，它们的值不能被分析。

Analyzed string fields use positions as the default, and all other fields use docs as the default.
### 多字段特性
Elasticsearch 5.X 之后给 text 类型的分词字段，又默认新增了一个子字段 keyword，这个字段的类型就是 keyword，是不分词的，默认保留 256 个字符。假设 product_name 是分词字段，那有一个 product_name.keyword 是不分词的字段，也可以用这个子字段来做完全匹配查询。

text类型：支持分词、全文检索，不支持聚合、排序操作。 
适合大字段存储，如：文章详情、content字段等；

keyword类型：支持精确匹配，支持聚合、排序操作。 
适合精准字段匹配，如：url、name、title等字段。 

"log" : {
          "type" : "text",
          "fields" : {
            "keyword" : {
              "type" : "keyword",
              "ignore_above" : 256
            }
          }
        }

keyword支持的最大长度为32766个UTF-8字符(最多32766 / 4 = 8191 个汉字)，text对字符长度没有限制。

设置ignore_above后，超过给定长度后的数据将不被索引，无法通过term精确匹配检索返回结果

[ignore_above](https://www.elastic.co/guide/en/elasticsearch/reference/current/ignore-above.html)       

#### 配置自定义Analyzer
* https://www.elastic.co/guide/en/elasticsearch/reference/7.x/analysis-custom-analyzer.html
* https://www.elastic.co/guide/en/elasticsearch/reference/7.x/configuring-analyzers.html
* https://www.elastic.co/guide/en/elasticsearch/reference/7.1/null-value.html
# 更新一个映射：来增加一个新字段，但是不能把已有字段的类型那个从analyzed改到not_analyzed。

curl -XPUT "http://es01:9200/users" -H 'Content-Type: application/json' -d'
{
    "mappings" : {
      "properties" : {
        "firstName" : {
          "type" : "text"
        },
        "lastName" : {
          "type" : "text"
        },
        "mobile" : {
          "type" : "keyword",
          "null_value": "NULL"
        }

      }
    }
}'

PUT /gb/_mapping/tweet
{
  "properties" : {
    "tag" : {
      "type" :    "string",
      "index":    "not_analyzed"
    }
  }
}

{
  "settings": {
    "analysis": {
      "analyzer": {
        "my_custom_analyzer": { 
          "type": "custom",
          "char_filter": [
            "emoticons"
          ],
          "tokenizer": "punctuation",
          "filter": [
            "lowercase",
            "english_stop"
          ]
        }
      },
      "tokenizer": {
        "punctuation": { 
          "type": "pattern",
          "pattern": "[ .,!?]"
        }
      },
      "char_filter": {
        "emoticons": { 
          "type": "mapping",
          "mappings": [
            ":) => _happy_",
            ":( => _sad_"
          ]
        }
      },
      "filter": {
        "english_stop": { 
          "type": "stop",
          "stopwords": "_english_"
        }
      }
    }
  }
}

PUT /product_index
{
  "settings": {
    "refresh_interval": "5s",
    "number_of_shards": 5,
    "number_of_replicas": 1
  },
  "mappings": {
    "product": {
      "properties": {
        "id": {
          "type": "text",
          "index": "not_analyzed"
        },
        "product_name": {
          "type": "text",
          "store": "no",
          "term_vector": "with_positions_offsets",
          "analyzer": "ik_max_word",
          "search_analyzer": "ik_max_word",
          "boost": 5
        },
        "product_desc": {
          "type": "text",
          "index": "not_analyzed"
        },
        "price": {
          "type": "double",
          "index": "not_analyzed"
        },
        "created_date_time": {
          "type": "date",
          "index": "not_analyzed",
          "format": "basic_date_time"
        },
        "last_modified_date_time": {
          "type": "date",
          "index": "not_analyzed",
          "format": "basic_date_time"
        },
        "version": {
          "type": "long",
          "index": "no"
        }
      }
    }
  }
}
# 测试映射
你可以通过名字使用analyze API测试字符串字段的映射。对比这两个请求的输出：
GET /gb/_analyze?field=tweet&text=Black-cats 

# 复合类型


## 内部对象的映射
Elasticsearch 会动态的检测新对象的字段，并且映射它们为 object 类型，将每个字段加到 properties 字段下

内部对象是怎样被索引的
Lucene 并不了解内部对象。 一个 Lucene 文件包含一个键-值对应的扁平表单。 为了让 Elasticsearch 可以有效的索引内部对象，将文件转换为以下格式：
{
    "tweet":            [elasticsearch, flexible, very],
    "user.id":          [@johnsmith],
    "user.gender":      [male],
    "user.age":         [26],
    "user.name.full":   [john, smith],
    "user.name.first":  [john],
    "user.name.last":   [smith]
}
# nested类型而不是object类型， 每个嵌套对象会被索引为一个隐藏分割文档
藉由分别索引每个嵌套对象，对象的栏位中保持了其关联。 我们的查询可以只在同一个嵌套对象都匹配时才回应。
不仅如此，因嵌套对象都被索引了，连接嵌套对象至根文档的查询速度非常快--几乎与查询单一文档一样快。

这些额外的嵌套对象被隐藏起来，我们无法直接访问他们。 为了要新增丶修改或移除一个嵌套对象，我们必须重新索引整个文档。 要牢记搜寻要求的结果并不是只有嵌套对象，而是整个文档。

默认情况下，每个索引最多创建50个嵌套文档，可以通过索引设置选项：index.mapping.nested_fields.limit 修改默认的限制。

# 分词


#standard
GET _analyze
{
  "analyzer": "standard",
  "text": "2 running Quick brown-foxes leap over lazy dogs in the summer evening."
}

#simpe
GET _analyze
{
  "analyzer": "simple",
  "text": "2 running Quick brown-foxes leap over lazy dogs in the summer evening."
}


curl -XGET "http://es01:9200/_analyze" -H 'Content-Type: application/json' -d'
{
  "analyzer": "stop",
  "text": "2 running Quick brown-foxes leap over lazy dogs in the summer evening."
}'

curl -XGET "http://es01:9200/_analyze" -H 'Content-Type: application/json' -d'
{
  "analyzer": "english",
  "text": "2 running Quick brown-foxes leap over lazy dogs in the summer evening."
}'

curl -XGET "http://es01:9200/_analyze" -H 'Content-Type: application/json' -d'
{
  "analyzer" : "standard",
  "text" : ["this is a test", "the second text"]
}'


curl -X GET "localhost:9200/analyze_sample/_analyze?pretty" -H 'Content-Type: application/json' -d'
{
  "text" : "this is a test"
}
'
curl -X GET "localhost:9200/analyze_sample/_analyze?pretty" -H 'Content-Type: application/json' -d'
{
  "analyzer" : "whitespace",
  "text" : "this is a test"
}
'
curl -X GET "localhost:9200/analyze_sample/_analyze?pretty" -H 'Content-Type: application/json' -d'
{
  "field" : "obj1.field1",
  "text" : "this is a test"
}
'


PUT logs/_doc/1
{"level":"DEBUG"}

GET /logs/_mapping

POST _analyze
{
  "tokenizer":"keyword",
  "char_filter":["html_strip"],
  "text": "<b>hello world</b>"
}


POST _analyze
{
  "tokenizer":"path_hierarchy",
  "text":"/user/ymruan/a/b/c/d/e"
}



#使用char filter进行替换
POST _analyze
{
  "tokenizer": "standard",
  "char_filter": [
      {
        "type" : "mapping",
        "mappings" : [ "- => _"]
      }
    ],
  "text": "123-456, I-test! test-990 650-555-1234"
}

//char filter 替换表情符号
POST _analyze
{
  "tokenizer": "standard",
  "char_filter": [
      {
        "type" : "mapping",
        "mappings" : [ ":) => happy", ":( => sad"]
      }
    ],
    "text": ["I am felling :)", "Feeling :( today"]
}

// white space and snowball
GET _analyze
{
  "tokenizer": "whitespace",
  "filter": ["stop","snowball"],
  "text": ["The gilrs in China are playing this game!"]
}


// whitespace与stop
GET _analyze
{
  "tokenizer": "whitespace",
  "filter": ["stop","snowball"],
  "text": ["The rain in Spain falls mainly on the plain."]
}


//remove 加入lowercase后，The被当成 stopword删除
GET _analyze
{
  "tokenizer": "whitespace",
  "filter": ["lowercase","stop","snowball"],
  "text": ["The gilrs in China are playing this game!"]
}

//正则表达式
GET _analyze
{
  "tokenizer": "standard",
  "char_filter": [
      {
        "type" : "pattern_replace",
        "pattern" : "http://(.*)",
        "replacement" : "$1"
      }
    ],
    "text" : "http://www.elastic.co"
}


* https://www.elastic.co/guide/en/elasticsearch/reference/current/analyzer-anatomy.html
* https://www.elastic.co/guide/en/elasticsearch/reference/7.1/indices-analyze.html
* https://github.com/medcl/elasticsearch-analysis-ik/

# qsl

ES为用户提供两类查询API，一类是在查询阶段就进行条件过滤的query查询，另一类是在query查询出来的数据基础上再进行过滤的filter查询。这两类查询的区别是：

query 和 filter 一起使用的话，filter 会先执行

从搜索结果上看：
filter，只查询出搜索条件的数据，不计算相关度分数
query，查询出搜索条件的数据，并计算相关度分数，按照分数进行倒序排序
从性能上看：
filter（性能更好，无排序），无需计算相关度分数，也就无需排序，内置的自动缓存最常使用查询结果的数据
缓存的东西不是文档内容，而是 bitset，具体看：https://www.elastic.co/guide/en/elasticsearch/guide/2.x/_finding_exact_values.html#_internal_filter_operation
query（性能较差，有排序），要计算相关度分数，按照分数进行倒序排序，没有缓存结果的功能
filter 和 query 一起使用可以兼顾两者的特性，所以看你业务需求。

query方法会计算查询条件与待查询数据之间的相关性，计算结果写入一个score字段，类似于搜索引擎。filter仅仅做字符串匹配，不会计算相关性，类似于一般的数据查询，所以filter得查询速度比query快。
filter查询出来的数据会自动被缓存，而query不能。
query和filter可以单独使用，也可以相互嵌套使用，非常灵活。

原则上来说，使用查询语句做全文本搜索或其他需要进行相关性评分的时候，剩下的全部用过滤语句， 做精确匹配搜索时，你最好用过滤语句，因为过滤语句可以缓存数据

match 查询
match查询是一个标准查询，不管你需要全文本查询还是精确查询基本上都要用到它。
如果你使用 match 查询一个全文本字段，它会在真正查询之前用分析器先分析match一下查询字符：
{
    "match": {
        "tweet": "About Search"
    }
}

match 还有一种情况，就是必须满足分词结果中所有的词，而不是像上面，任意一个就可以的
{
  "query": {
    "match": {
      "product_name": {
        "query": "PHILIPS toothbrush",
        "operator": "and"
      }
     }
   }
}

match 还还有一种情况，就是必须满足分词结果中百分比的词，比如搜索词被分成这样子：java 程序员 书 推荐，这里就有 4 个词，假如要求 50% 命中其中两个词就返回，我们可以这样：
当然，这种需求也可以用 must、must_not、should 匹配同一个字段进行组合来查询
GET /product_index/product/_search
{
  "query": {
    "match": {
      "product_name": {
        "query": "java 程序员 书 推荐",
        "minimum_should_match": "50%"
      }
    }
  }
}

如果用match下指定了一个确切值，在遇到数字，日期，布尔值或者not_analyzed 的字符串时，它将为你搜索你给定的值：
{ "match": { "age":    26           }}
{ "match": { "date":   "2014-09-01" }}
{ "match": { "public": true         }}
{ "match": { "tag":    "full_text"  }}
提示： 做精确匹配搜索时，你最好用过滤语句，因为过滤语句可以缓存数据。
不像我们在《简单搜索》中介绍的字符查询，match查询不可以用类似"+usid:2 +tweet:search"这样的语句。 它只能就指定某个确切字段某个确切的值进行搜索，而你要做的就是为它指定正确的字段名以避免语法错误。
Prefix Query （性能较差，扫描所有倒排索引）
{
  "query": {
    "prefix": {
      "name": "赵"
    }
  }
}

Range Query https://www.elastic.co/guide/en/elasticsearch/reference/current/query-dsl-range-query.html
{
  "query": {
    "range": {
      "age": {
        "gte": "18",     // 表示>=
        "lte": "20"      // 表示<=
      }
    }
  }
}

curl -XGET "http://es01:9200/products/_search" -H 'Content-Type: application/json' -d'
{
    "query" : {
        "constant_score" : {
            "filter" : {
                "range" : {
                    "price" : {
                        "gte" : 20,
                        "lte"  : 30
                    }
                }
            }
        }
    }
}'
curl -XPOST "http://es01:9200/products/_search" -H 'Content-Type: application/json' -d'
{
    "query" : {
        "constant_score" : {
            "filter" : {
                "range" : {
                    "date" : {
                      "gte" : "now-3y"
                    }
                }
            }
        }
    }
}'
term 用法（与 match 进行对比）（term 不做search analysis，会完全匹配查询 index analysis结果，如果要查询的字段是分词字段就会被拆分成各种分词结果，比如大小写，和完全查询的内容就对应不上了，但同样会相关性算分。一般用在不分词字段或者keyword上的，因为它是完全匹配查询。）：

{
  "query": {
    "term": {
      "product_name": "PHILIPS toothbrush"
    }
  }
}

curl -XPOST "http://es01:9200/products/_search" -H 'Content-Type: application/json' -d'
{
  "profile": "true",
  "explain": true,
  "query": {
    "term": {
      "date": "2019-01-01"
    }
  }
}'

curl -XPOST "http://es01:9200/products/_search" -H 'Content-Type: application/json' -d'
{
  "explain": true,
  "query": {
    "constant_score": {
      "filter": {
        "term": {
          "productID.keyword": "XHDK-A-1293-#fJ3"
        }
      }

    }
  }
}'

Terms Query

多词语查询，查找符合词语列表的数据。如果要查询的字段索引为not_analyzed类型，则terms查询非常类似于关系型数据库中的in查询。下面查找学号为1，3的学生。

curl -XPOST "192.168.1.101:9200/student/student/_search" -d 
'
curl -XPOST "http://es01:9200/products/_search" -H 'Content-Type: application/json' -d'
{
  "query": {
    "constant_score": {
      "filter": {
        "terms": {
          "productID.keyword": [
            "QQPX-R-3956-#aD8",
            "JODL-X-1937-#pV7"
          ]
        }
      }
    }
  }
}'

curl -XPOST "http://es01:9200/products/_search" -H 'Content-Type: application/json' -d'
{
  "query": {
    "constant_score": {
      "filter": {
        "terms": {
          "price": [
            "20",
            "30"
          ]
        }
      }
    }
  }
}'

#exists查询
curl -XPOST "http://es01:9200/products/_search" -H 'Content-Type: application/json' -d'
{
  "query": {
    "constant_score": {
      "filter": {
        "exists": {
          "field": "date"
        }
      }
    }
  }
}'

fuzzy 纠错查询
参数 fuzziness 默认是 2，表示最多可以纠错两次，但是这个值不能很大，不然没效果。一般 AUTO 是自动纠错。下面的关键字漏了一个字母 o。
{
  "query": {
    "match": {
      "product_name": {
        "query": "PHILIPS tothbrush",
        "fuzziness": "AUTO",
        "operator": "and"
      }
    }
  }
}

通配符搜索（性能较差，扫描所有倒排索引）

{
  "query": {
    "wildcard": {
      "product_name": {
        "value": "ipho*"
      }
    }
  }
}
Regexp Filter （性能较差，扫描所有倒排索引）

正则表达式查询，是最灵活的字符串类型字段查询方式。查找家住长沙市的学生，查询结果为学号为1的学生。

curl -XPOST "192.168.1.101:9200/student/student/_search" -d 
'
{
  "filter": {
    "regexp": {
      "address": ".*长沙市.*"
    }
  }
}

[multi_match 查询](https://www.elastic.co/guide/en/elasticsearch/reference/7.x/query-dsl-multi-match-query.html)
multi_match查询允许你做match查询的基础上同时搜索多个字段，查询 title 和 body 字段中，只要有：full text search 关键字的就查询出来
{
    "multi_match": {
        "query":    "full text search",
        "fields":   [ "title", "body" ]
    }
}

multi_match 跨多个 field 查询，表示查询分词必须出现在相同字段中。
GET /product_index/product/_search
{
  "query": {
    "multi_match": {
      "query": "PHILIPS toothbrush",
      "type": "cross_fields",
      "operator": "and",
      "fields": [
        "product_name",
        "product_desc"
      ]
    }
  }
}

bool 查询
https://www.elastic.co/guide/en/elasticsearch/reference/current/query-filter-context.html
https://www.elastic.co/guide/en/elasticsearch/reference/7.1/query-dsl-boosting-query.html
https://www.elastic.co/guide/en/elasticsearch/reference/7.1/query-dsl-dis-max-query.html
bool 查询与 bool 过滤相似，用于合并多个查询子句。不同的是，bool 过滤可以直接给出是否匹配成功， 而bool 查询要计算每一个查询子句的 _score （相关性分值）。
must:: 查询指定文档一定要被包含。
must_not:: 查询指定文档一定不要被包含。
should:: 查询指定文档，有则可以为文档相关性加分，类似于in的查询条件。如果bool查询中不包含must查询，那么should默认表示必须符合查询列表中的一个或多个查询条件

curl -XPOST "http://es01:9200/products/_search" -H 'Content-Type: application/json' -d'
{
  "query": {
    "bool" : {
      "must" : {
        "term" : { "price" : "30" }
      },
      "filter": {
        "term" : { "avaliable" : "true" }
      },
      "must_not" : {
        "range" : {
          "price" : { "lte" : 10 }
        }
      },
      "should" : [
        { "term" : { "productID.keyword" : "JODL-X-1937-#pV7" } },
        { "term" : { "productID.keyword" : "XHDK-A-1293-#fJ3" } }
      ],
      "minimum_should_match" :1
    }
  }
}'
提示： 如果bool 查询下没有must子句，那至少应该有一个should子句。但是 如果有must子句，那么没有should子句也可以进行查询。

# 组合

{
  "query": {
    "bool": {
      "must": [
        {
          "match": {
            "product_name": "PHILIPS toothbrush"
          }
        }
      ],
      "should": [
        {
          "match": {
            "product_desc": "刷头"
          }
        }
      ],
      "must_not": [
        {
          "match": {
            "product_name": "HX6730"
          }
        }
      ],
      "filter": {
        "range": {
          "price": {
            "gte": 33.00
          }
        }
      }
    }
  }
}

{
  "query": {
    "bool": {
      "should": [
        {
          "term": {
            "product_name": "飞利浦"
          }
        },
        {
          "bool": {
            "must": [
              {
                "term": {
                  "product_desc": "刷头"
                },
                "term": {
                  "price": 30
                }
              }
            ]
          }
        }
      ]
    }
  }
}

should 有一个特殊性，如果组合查询中没有 must 条件，那么 should 中必须至少匹配一个。我们也还可以通过 minimum_should_match 来限制它匹配更多个。

{
  "query": {
    "bool": {
      "should": [
        {
          "match": {
            "product_name": "java"
          }
        },
        {
          "match": {
            "product_name": "程序员"
          }
        },
        {
          "match": {
            "product_name": "书"
          }
        },
        {
          "match": {
            "product_name": "推荐"
          }
        }
      ],
      "minimum_should_match": 3
    }
  }
}

boost 用法（默认是 1）。在搜索精准度的控制上，还有一种需求，比如搜索：PHILIPS toothbrush，要比：Braun toothbrush 更加优先，我们可以这样：

{
  "query": {
    "bool": {
      "must": [
        {
          "match": {
            "product_name": "toothbrush"
          }
        }
      ],
      "should": [
        {
          "match": {
            "product_name": {
              "query": "PHILIPS",
              "boost": 4
            }
          }
        },
        {
          "match": {
            "product_name": {
              "query": "Braun",
              "boost": 3
            }
          }
        }
      ]
    }
  }
}

curl -XPOST "http://es01:9200/news/_search" -H 'Content-Type: application/json' -d'
{
  "query": {
    "boosting": {
      "positive": {
        "match": {
          "content": "apple"
        }
      },
      "negative": {
        "match": {
          "content": "pie"
        }
      },
      "negative_boost": 0.5
    }
  }
}'

# 校验 dsl 
GET /_validate/query?explain
{
   "query": {
      "match" : {
         "tweet" : "really powerful"
      }
   }
}


# 排序 

"sort": [
        { "date":   { "order": "desc" }},
        { "_score": { "order": "desc" }}
    ]
作为缩写，你可以只指定要排序的字段名称：
    "sort": "number_of_children"
字段值默认以升序排列，而 _score 默认以倒序排列。

为多值字段排序
在为一个字段的多个值进行排序的时候， 其实这些值本来是没有固定的排序的-- 一个拥有多值的字段就是一个集合， 你准备以哪一个作为排序依据呢？
对于数字和日期，你可以从多个值中取出一个来进行排序，你可以使用min, max, avg 或 sum这些模式。 比说你可以在 dates 字段中用最早的日期来进行排序：
"sort": {
    "dates": {
        "order": "asc",
        "mode":  "min"
    }
}

#打开 text的 fielddata
PUT kibana_sample_data_ecommerce/_mapping
{
  "properties": {
    "customer_full_name" : {
          "type" : "text",
          "fielddata": true,
          "fields" : {
            "keyword" : {
              "type" : "keyword",
              "ignore_above" : 256
            }
          }
        }
  }
}

#关闭 keyword的 doc values
PUT test_keyword
PUT test_keyword/_mapping
{
  "properties": {
    "user_name":{
      "type": "keyword",
      "doc_values":false
    }
  }
}

## 综合排序
* https://www.elastic.co/guide/en/elasticsearch/reference/7.1/query-dsl-function-score-query.html

# 指定查询结果字段（field）
GET /product_index/product/_search
{
  "query": {
    "match_all": {}
  },
  "_source": [
    "product_name",
    "price"
  ]
}

# 聚合
"aggregations" : {
    "<aggregation_name>" : {
        "<aggregation_type>" : {
            <aggregation_body>
        }
        [,"meta" : {  [<meta_data_body>] } ]?
        [,"aggregations" : { [<sub_aggregation>]+ } ]?
    }
    [,"<aggregation_name_2>" : { ... } ]*
}

{
  "aggs": {
    "by_day": {
      "date_histogram": {
        "field":     "date",
        "interval":  "day",
        "time_zone": "Asia/Shanghai"
      }
    }
  }

 #按照目的地进行分桶统计
GET kibana_sample_data_flights/_search
{
	"size": 0,
	"aggs":{
		"flight_dest":{
			"terms":{
				"field":"DestCountry"
			}
		}
	}
}



#查看航班目的地的统计信息，增加平均，最高最低价格
GET kibana_sample_data_flights/_search
{
	"size": 0,
	"aggs":{
		"flight_dest":{
			"terms":{
				"field":"DestCountry"
			},
			"aggs":{
				"avg_price":{
					"avg":{
						"field":"AvgTicketPrice"
					}
				},
				"max_price":{
					"max":{
						"field":"AvgTicketPrice"
					}
				},
				"min_price":{
					"min":{
						"field":"AvgTicketPrice"
					}
				}
			}
		}
	}
}



#价格统计信息+天气信息
GET kibana_sample_data_flights/_search
{
	"size": 0,
	"aggs":{
		"flight_dest":{
			"terms":{
				"field":"DestCountry"
			},
			"aggs":{
				"stats_price":{
					"stats":{
						"field":"AvgTicketPrice"
					}
				},
				"wather":{
				  "terms": {
				    "field": "DestWeather",
				    "size": 5
				  }
				}

			}
		}
	}
}



集群状态分为绿色(green)、黄色(yellow)和红色(red)。

绿色代表集群当前状态是好的(集群功能齐全)。
黄色代表所有数据(主分片)都可用，但是一些副本(副分片)还没有分配(集群功能齐全)。
红色代表一些数据(主分片)不可用。

# Dynamic Template和Index Template
1. 模板仅在新创建一个索引时产生作用，修改模板，不影响已创建的索引

2. 多个索引merge，指定order
https://www.elastic.co/guide/en/elasticsearch/reference/7.1/indices-templates.html

https://www.elastic.co/guide/en/elasticsearch/reference/7.1/dynamic-mapping.html

PUT _template/template_default
{
  "index_patterns": ["*"],
  "order" : 0,
  "version": 1,
  "settings": {
    "number_of_shards": 1,
    "number_of_replicas":1
  }
}
PUT /_template/template_test
{
    "index_patterns" : ["test*"],
    "order" : 1,
    "settings" : {
    	"number_of_shards": 1,
        "number_of_replicas" : 2
    },
    "mappings" : {
    	"date_detection": false,
    	"numeric_detection": true
    }
}

#查看template信息
GET /_template/template_default
GET /_template/temp*


#写入新的数据，index以test开头
PUT testtemplate/_doc/1
{
	"someNumber":"1",
	"someDate":"2019/01/01"
}
GET testtemplate/_mapping
get testtemplate/_settings

PUT testmy
{
	"settings":{
		"number_of_replicas":5
	}
}

put testmy/_doc/1
{
  "key":"value"
}

get testmy/_settings
DELETE testmy
DELETE /_template/template_default
DELETE /_template/template_test



#Dynaminc Mapping 根据类型和字段名
DELETE my_index

PUT my_index/_doc/1
{
  "firstName":"Ruan",
  "isVIP":"true"
}

GET my_index/_mapping
DELETE my_index
PUT my_index
{
  "mappings": {
    "dynamic_templates": [
            {
        "strings_as_boolean": {
          "match_mapping_type":   "string",
          "match":"is*",
          "mapping": {
            "type": "boolean"
          }
        }
      },
      {
        "strings_as_keywords": {
          "match_mapping_type":   "string",
          "mapping": {
            "type": "keyword"
          }
        }
      }
    ]
  }
}


DELETE my_index
#结合路径
PUT my_index
{
  "mappings": {
    "dynamic_templates": [
      {
        "full_name": {
          "path_match":   "name.*",
          "path_unmatch": "*.middle",
          "mapping": {
            "type":       "text",
            "copy_to":    "full_name"
          }
        }
      }
    ]
  }
}


PUT my_index/_doc/1
{
  "name": {
    "first":  "John",
    "middle": "Winston",
    "last":   "Lennon"
  }
}

GET my_index/_search?q=full_name:John


[aliases](https://www.elastic.co/guide/en/elasticsearch/reference/7.7/indices-aliases.html)

```sh
curl -X POST "node103:9205/_aliases?pretty" -H 'Content-Type: application/json' -d'
{
    "actions": [
        {
            "remove": {
                "index": "cti_sinc_date",
                "alias": "cti_sinc_body"
            }
        },
        {
            "add": {
                "index": "cti_sinc_date",
                "alias": "cti_sinc_body",
                "is_write_index": true
            }
        }
    ]
}
'
```
https://www.elastic.co/guide/en/elasticsearch/reference/7.7/indices-get-alias.html

# elasticsearch 中重建索引
https://juejin.im/post/5afa6634518825673e35c5a5



# 搜索和排序，聚合应用的技术不一样

# ingest

curl -X GET "localhost:9200/_nodes/ingest"

# grok

curl -X GET "localhost:9200/_ingest/processor/grok"


```

## Suggester
Term & Phrase Suggester
自动补全与基于上下文的提示

## 跨集群搜索

//在每个集群上设置动态的设置
PUT _cluster/settings
{
  "persistent": {
    "cluster": {
      "remote": {
        "cluster0": {
          "seeds": [
            "127.0.0.1:9300"
          ],
          "transport.ping_schedule": "30s"
        },
        "cluster1": {
          "seeds": [
            "127.0.0.1:9301"
          ],
          "transport.compress": true,
          "skip_unavailable": true
        },
        "cluster2": {
          "seeds": [
            "127.0.0.1:9302"
          ]
        }
      }
    }
  }
}

#查询
GET /users,cluster1:users,cluster2:users/_search
{
  "query": {
    "range": {
      "age": {
        "gte": 20,
        "lte": 40
      }
    }
  }
}

## dfs_query_then_fetch

POST message/_search?search_type=dfs_query_then_fetch
{

  "query": {
    "term": {
      "content": {
        "value": "good"
      }
    }
  }
}

## 插件
[命令行格式](https://www.elastic.co/guide/en/elasticsearch/plugins/current/plugin-management-custom-url.html)  
sudo bin/elasticsearch-plugin install [plugin_name]  
sudo bin/elasticsearch-plugin install [url]   
url可以是http或者 file://
安装完插件后,必须要重启elasticsearch,才能让新增加插件生效

/bin/elasticsearch-plugin list
http://192.168.205.235:9222/_cat/plugins
/bin/elasticsearch-plugin remove [pluginname]

Option             Description
------             -----------
-E <KeyValuePair>  Configure a setting
-h, --help         show help
-s, --silent       show minimal output
-v, --verbose      show verbose output

### 单播、多播和广播
单播”（Unicast）、“多播(组播)”（Multicast）和“广播”（Broadcast）这三个术语都是用来描述网络节点之间通讯方式的术语。

# kibana 

docker pull docker.elastic.co/kibana/kibana:6.5.4

docker run -d --name kibana --net nw-es -e ELASTICSEARCH_HOSTS=http://es:9200 -p 5601:5601 docker.elastic.co/kibana/kibana:6.6.0

localhost:5601

/usr/share/kibana

$KIBANA_HOME/config/

elasticsearch.hosts:
Default: "http://localhost:9200" The URLs of the Elasticsearch instances to use for all your queries. All nodes listed here must be on the same cluster.


http://192.168.20.139:25601/status


http://192.168.20.139:25601/api/status


pattern 

You can use a * as a wildcard in your index pattern.

You can't use spaces or the characters \, /, ?, ", <, >, |.

log:"job" AND log:"20:22:*"


数据权限 https://www.elastic.co/guide/en/elastic-stack-overview/6.6/security-privileges.html

显示和操作 

查询和过滤

时区

#### 多实例
-E key=val -d
# filebeat

docker pull docker.elastic.co/beats/filebeat:6.6.0


Home path: [/usr/share/filebeat] Config path: [/usr/share/filebeat] Data path: [/usr/share/filebeat/data] Logs path: [/usr/share/filebeat/logs]

/usr/share/filebeat/data/registry


Elasticsearch template with name 'filebeat-6.6.0' loaded

filebeat-6.6.0-2019.02.25


/var/lib/docker/volumes/filebeat/_data/
```sh
docker run -d \
--name=filebeat \
--net nw-es \
-v /home/pmz/pmz_tomcat/logs/task:/app/logs \
-v /home/pmz/es/filebeat.docker.yml:/usr/share/filebeat/filebeat.yml \
-v filebeat:/usr/share/filebeat/data \
docker.elastic.co/beats/filebeat:6.6.0  \
setup -E setup.kibana.host=kibana:5601 \
-E output.elasticsearch.hosts=["es:9200"]  

```
https://www.elastic.co/guide/en/beats/filebeat/current/configuring-howto-filebeat.html

```yml
# https://github.com/elastic/beats/blob/master/filebeat/filebeat.reference.yml
filebeat.config:
  modules:
    path: ${path.config}/modules.d/*.yml
    reload.enabled: false

filebeat.autodiscover:
  providers:
    - type: docker
      hints.enabled: true

processors:
- add_cloud_metadata: ~


output.elasticsearch:
  hosts: '${ELASTICSEARCH_HOSTS:elasticsearch:9200}'
  username: '${ELASTICSEARCH_USERNAME:}'
  password: '${ELASTICSEARCH_PASSWORD:}'

output.console:
enabled: false  
codec.json:
  pretty: true
```

```json
{
  "_index": "filebeat-6.6.0-2019.02.25",
  "_type": "doc",
  "_id": "c-0yJGkBHQThXrP0Nci6",
  "_version": 1,
  "_score": 0,
  "_source": {
    "@timestamp": "2019-02-25T10:27:40.658Z",
    "prospector": {
      "type": "log"
    },
    "input": {
      "type": "log"
    },
    "host": {
      "name": "8db45fdffff3"
    },
    "app_id": "job",
    "beat": {
      "name": "8db45fdffff3",
      "hostname": "8db45fdffff3",
      "version": "6.6.0"
    },
    "source": "/app/logs/OverseasUserTask.log",
    "offset": 0,
    "log": {
      "file": {
        "path": "/app/logs/OverseasUserTask.log"
      }
    },
    "message": "2019-02-25 17:50:00,012 [scheduler-8] INFO  [OverseasUserTask][overseasUserTask] - overseasUserTask 启动,获取锁,锁状态:1,当前时间:2019-02-25 17:50:00",
    "tags": [
      "pmz",
      "dev"
    ]
  },
  "fields": {
    "@timestamp": [
      "2019-02-25T10:27:40.658Z"
    ]
  },
  "highlight": {
    "message": [
      "2019-02-25 17:50:00,012 [scheduler-8] INFO  [@kibana-highlighted-field@OverseasUserTask@/kibana-highlighted-field@][@kibana-highlighted-field@overseasUserTask@/kibana-highlighted-field@] - @kibana-highlighted-field@overseasUserTask@/kibana-highlighted-field@ 启动,获取锁,锁状态:1,当前时间:2019-02-25 17:50:00"
    ]
  }
}
```

# java cliet

* https://docs.spring.io/spring-data/elasticsearch/docs/3.2.0.RC3/reference/html/#preface.versions

* https://zhuanlan.zhihu.com/p/27369838


# [elasticsearch-dump](https://github.com/elasticsearch-dump/elasticsearch-dump)


# 日志系统设计

## 设计
日志类型

业务日志 比如用户的操作日志，主要用来监控业务逻辑的执行情况  
错误日志 系统错误信息  
摘要日志 系统操作上下文的摘要信息  
统计日志 可以汇总的统计的信息  

等级

日志挖掘：
日志监控、统计分析、调用链分析，行为分析

系统可用性：
数据实时性；丢失率可控（业务分级、全链路监控）。多样性支持：环境多样：物理机（虚拟机）、容器；来源多样：系统日志、业务日志、中间件日志，接入层；格式多样：单行/多行， plain/json。


1. 【强制】日志文件至少保存 15 天，因为有些异常具备以“周”为频次发生的特点。

2. 【强制】应用中的扩展日志（如打点、临时监控、访问日志等） 命名方式：
appName_logType_logName.log。
logType:日志类型， 如 stats/monitor/access 等； logName:日志描述。这种命名的好处：
通过文件名就可知道日志文件属于什么应用，什么类型，什么目的，也有利于归类查找。
正例： mppserver 应用中单独监控时区转换异常，如：
mppserver_monitor_timeZoneConvert.log
说明： 推荐对日志进行分类， 如将错误日志和业务日志分开存放，便于开发人员查看，也便于
通过日志对系统进行及时监控。

【强制】异常信息应该包括两类信息：案发现场信息和异常堆栈信息。如果不处理，那么通过
关键字 throws 往上抛出。
正例： logger.error(各类参数或者对象 toString() + "_" + e.getMessage(), e);

实现：
日志文件生成，容器内应用日志，日志采集、传输、切分、检索、分析

## 生成：

日志位置，业务区分，应用实例、异步记录 日志保留时间

## 采集：规范，非规范

必须包含四类元信息：

time: 日志产生时间，ISO8601格式

level：日志等级， FATAL、ERROR、WARN、INFO、DEBUG

app_id：应用id，用于标示日志来源，与公司服务树一致，全局唯一

instance_id：实例id，用于区分同一应用不同实例，格式业务方自行设定

业务类型：

埋点

两套环境dev、prod

日志详细信息统一保存到log字段中。

除上述字段之外，业务方也可以自行添加额外的字段。

json的mapping应保持不变：key不能随意增加、变化，value的类型也应保持不变。

beats 

过滤
日志缓存


## 传输：

kafka

负载均衡，容量可水平扩展，数据传输安全可靠

## 切分：字段提取、格式转换

从kafka消费日志，对日志进行处理
logstash

## 检索：
es

数据存储
## 分析

kibana

## es监控


各个阶段高可用性
es cluster的状态信息、thread rejected数量、node节点数量、unassign shard数量。

告警，故障转移，恢复时间

用户名密码



# 其他日志方案
时间序列数据库


