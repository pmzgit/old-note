## 概括 CAP 原理就是——网络分区发生时，一致性和可用性两难全
* P：分区容错性(partition-tolerance)这个是必需的，这是客观存在的。
* CAP是无法完全兼顾的，从上面的例子也可以看出，我们可以选AP，也可以选CP。但是，要注意的是：不是说选了AP，C就完全抛弃了。不是说选了CP，A就完全抛弃了！
* 在CAP理论中，C所表示的一致性是强一致性(每个节点的数据都是最新版本)，其实一致性还有其他级别的：

弱一致性：弱一致性是相对于强一致性而言，它不保证总能得到最新的值；

最终一致性(eventual consistency)：放宽对时间的要求，在被调完成操作响应后的某个时间点，被调多个节点的数据最终达成一致


## [yaml](http://www.ruanyifeng.com/blog/2016/07/yaml.html)

## 搭建
import属性实现依赖的多继承
## eureka
* 在Spring Cloud中，服务的Instance ID的默认值:机器主机名:应用名称:应用端口


## openfeign
https://www.cnblogs.com/goingforward/p/9560069.html
## autoconfig
配置类 xxxProperties
* KafkaProperties


## config
客户端和服务端的键值对概念与Spring Environment和PropertySource 相同，所以十分适合Spring应用，另一方面可以适用于任何语言的应用程序。


@SpringCloudApplication



## zuul

通过服务网关统一向外系统提供REST API的过程中，除了具备服务路由、均衡负载功能之外，它还具备了权限控制等功能。Spring Cloud Netflix中的Zuul就担任了这样的一个角色，为微服务架构提供了前门保护的作用，同时将权限控制这些较重的非业务逻辑内容迁移到服务路由层面，使得服务集群主体能够具备更高的可复用性和可测试性。


网关的默认路由规则

但是如果后端服务多达十几个的时候，每一个都这样配置也挺麻烦的，spring cloud zuul已经帮我们做了默认配置。默认情况下，Zuul会代理所有注册到Eureka Server的微服务，并且Zuul的路由规则如下：http://ZUUL_HOST:ZUUL_PORT/微服务在Eureka上的serviceId/**会被转发到serviceId对应的微服务。