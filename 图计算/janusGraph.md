


#安装，配置，启动
## [docker 方式](https://github.com/JanusGraph/janusgraph-docker/blob/master/README.md)

```sh
docker run -d --name janusgraph-default -p 8182:8182 -e gremlinserver.channelizer=org.apache.tinkerpop.gremlin.server.channel.WsAndHttpChannelizer janusgraph/janusgraph:latest 


docker run --rm --link janusgraph-default:janusgraph -e GREMLIN_REMOTE_HOSTS=janusgraph \
    -it janusgraph/janusgraph:latest ./bin/gremlin.sh

docker run --rm --link daf604145fb9:janusgraph -e GREMLIN_REMOTE_HOSTS=janusgraph \
    -it janusgraph/janusgraph:latest ./bin/gremlin.sh


docker run --network cti-sinc_sinc_net -e GREMLIN_REMOTE_HOSTS=janusServer \
    -it janusgraph/janusgraph:latest ./bin/gremlin.sh
    --network my-net

docker exec -it f30949e950ed ./bin/gremlin.sh

:remote connect tinkerpop.server conf/remote.yaml

:> GraphOfTheGodsFactory.load(graph)


:remote console
All scripts will now be sent to Gremlin Server - [janusgraph/172.17.0.3:8182] - type ':remote console' to return to local mode


docker run --rm -it janusgraph/janusgraph:latest janusgraph show-config
```

```sh
gremlin-server.sh conf/gremlin-server/gremlin-server.yaml

通过Gremlin控制台远程连接JanusGraph Server是WebSocket方式
gremlin.sh

:remote connect tinkerpop.server conf/remote.yaml

HTTP接口验证要更简单，可以直接在浏览器输入IP地址+端口，后面跟Gremlin查询语言。示例如下：
 http://192.168.142.171:8182/?gremlin=g.V().count()
如果正常，会返回如下JSON结果：
{"requestId":"a85166ee-302d-444a-b02a-e163ef7e7ddb","status":{"message":"","code":200,"attributes":{"@type":"g:Map","@value":[]}},"result":{"data":{"@type":"g:List","@value":[{"@type":"g:Int64","@value":0}]},"meta":{"@type":"g:Map","@value":[]}}}


开启一个图数据库实例

 graph = JanusGraphFactory.open('conf/janusgraph-berkeleyje-es.properties')

获取图遍历句柄


 g = graph.traversal()

g.addV('person').property('name','Dennis')

GraphOfTheGodsFactory.load(graph)
```


## 可视化
https://github.com/prabushitha/gremlin-visualizer
https://github.com/fenglex/janusgraph-visualization
```sh
docker run --rm -d -p 33000:3000 -p 33001:3001 --name=gremlin-visualizer prabushitha/gremlin-visualizer:latest
```

### cache 分布式

```sh
storage.backend=hbase
storage.hostname=100.100.101.1
storage.port=2181

index.search.backend=elasticsearch
index.search.hostname=100.100.101.1, 100.100.101.2
index.search.elasticsearch.client-only=true
```

Vertex Property进行has()操作，前提是图支持meta-property 
g.V().has('name','saturn').repeat(bothE().otherV()).times(5).path()

g.V().has('name','saturn').bothE().otherV().bothE().otherV().bothE().otherV().bothE().otherV().bothE().otherV().path()
```sh
version: '3.7'

services:
  es5-ik:
    image: es5.5-ik:latest
    ports:
      - "9205:9200"
      - "9305:9300"
    environment:
      - node.name=es5.5
      - discovery.type=single-node
      - cluster.name=docker-cluster5
      - bootstrap.memory_lock=true
      - xpack.security.enabled=false
      - "ES_JAVA_OPTS=-Xms100m -Xmx100m"
    ulimits:
      memlock:
        soft: -1
        hard: -1  
    volumes:
      - es5_data:/usr/share/elasticsearch/data
    networks:
      - sinc_net
    deploy:
      replicas: 1
      placement:
        constraints: ["node.hostname == node102"] 
        
  janusServer:
    image: janusgraph/janusgraph:latest
    container_name: berkeleyje-lucene-janusgraph
    ports:
      - "8182:8182"
    environment:
      - gremlinserver.channelizer=org.apache.tinkerpop.gremlin.server.channel.WsAndHttpChannelizer
    volumes:
      - janus-berkeleyje-data:/var/lib/janusgraph/data
      - janus-lucene-data:/var/lib/janusgraph/index
    networks:
      - sinc_net
    deploy:
      replicas: 1
      placement:
        constraints: ["node.hostname == node102"]
     
     
  janus-console:
    image: janusgraph/janusgraph:latest
    entrypoint: ["docker-entrypoint.sh","./bin/gremlin.sh"]
    environment:
      - GREMLIN_REMOTE_HOSTS=janusServer
    networks:
      - sinc_net
    deploy:
      replicas: 1
      placement:
        constraints: ["node.hostname == node102"]   
        
  janus-visualization:
    image: fenglex/janusgraph-visualization:latest
    ports:
      - "11111:8888"
    networks:
      - sinc_net
    deploy:
      replicas: 1
      placement:
        constraints: ["node.hostname == node102"]
        
        
volumes:
  es5_data:
  janus-berkeleyje-data:
  janus-lucene-data:
  
networks:
  sinc_net:

```
