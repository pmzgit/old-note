# amqp 和 RabbitMQ
* [amqp 简介](http://www.cnblogs.com/frankyou/p/5283539.html)
* [RabbitMQ Simulator](http://tryrabbitmq.com/)

# 安装
## jdk8
* 解压  
1.在/usr/目录下创建java目录  
`mkdir/usr/java `  
`tar -zxvf jdk-8u151-linux-x64.tar.gz -C /usr/java/` 
* 设置环境变量  
`vi /etc/profile `  
在profile中添加如下内容：  
set java environment
```sh   
export JAVA_HOME=/usr/java/jdk1.8.0_151  
export PATH=$JAVA_HOME/bin:$PATH  
```
* 让修改生效  
`source /etc/profile `  
* 验证JDK有效性    
`java -version` 
 
## maven
* `wget http://mirrors.hust.edu.cn/apache/maven/maven-3/3.5.2/binaries/apache-maven-3.5.2-bin.tar.gz`
* [install](http://maven.apache.org/install.html)
* 使配置生效  
`source /etc/profile`
* 验证   
`mvn -v`

## RocketMQ 下载、解压、maven 编译安装
```sh
wget http://mirrors.hust.edu.cn/apache/rocketmq/4.2.0/rocketmq-all-4.2.0-source-release.zip

unzip rocketmq-all-4.2.0-source-release.zip
cd rocketmq-all-4.2.0/
mvn -Prelease-all -DskipTests clean install -U
cd distribution/target/apache-rocketmq

```
* maven 编译结果
```
[INFO] Apache RocketMQ 4.2.0 .............................. SUCCESS [  01:08 h]
[INFO] rocketmq-remoting 4.2.0 ............................ SUCCESS [18:16 min]
[INFO] rocketmq-common 4.2.0 .............................. SUCCESS [ 11.165 s]
[INFO] rocketmq-client 4.2.0 .............................. SUCCESS [01:50 min]
[INFO] rocketmq-store 4.2.0 ............................... SUCCESS [01:24 min]
[INFO] rocketmq-srvutil 4.2.0 ............................. SUCCESS [01:57 min]
[INFO] rocketmq-filter 4.2.0 .............................. SUCCESS [  5.675 s]
[INFO] rocketmq-broker 4.2.0 .............................. SUCCESS [ 42.353 s]
[INFO] rocketmq-tools 4.2.0 ............................... SUCCESS [  3.675 s]
[INFO] rocketmq-namesrv 4.2.0 ............................. SUCCESS [  1.983 s]
[INFO] rocketmq-logappender 4.2.0 ......................... SUCCESS [ 37.977 s]
[INFO] rocketmq-openmessaging 4.2.0 ....................... SUCCESS [  4.174 s]
[INFO] rocketmq-example 4.2.0 ............................. SUCCESS [  1.809 s]
[INFO] rocketmq-filtersrv 4.2.0 ........................... SUCCESS [  1.417 s]
[INFO] rocketmq-test 4.2.0 ................................ SUCCESS [ 21.515 s]
[INFO] rocketmq-distribution 4.2.0 ........................ SUCCESS [06:00 min]
[INFO] ------------------------------------------------------------------------
[INFO] BUILD SUCCESS

```

# 启动 
* [官方参考](https://rocketmq.apache.org/docs/quick-start/)

# 命名服务
* [概念](http://www.hollischuang.com/archives/1595)

# mmp ,官方文档太简单了，而且阉割了很多功能，暂时放弃,研究转为RabbitMQ 