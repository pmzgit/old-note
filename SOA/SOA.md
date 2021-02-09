# 分布式+集群=微服务
## what
* https://www.jianshu.com/p/21238ae6107c
### 分布式
* 分与合的艺术
* 分布式是指将不同的业务分布在不同的地方
* 分布式是以缩短单个任务的执行时间来提升效率的
* 分布式是个工作方式
### 集群
* 负载均衡，心跳，故障转移，共享存储
* 集群指的是将几台服务器集中在一起，实现同一业务
* 集群则是通过提高单位时间内执行的任务数来提升效率。
* 集群是个物理形态
## why
* 为了性能扩展——系统负载高，单台机器无法承载，希望通过使用多台机器来提高系统的负载能力。
* 为了增强可靠性——软件不是完美的，网络不是完美的，甚至机器本身也不可能是完美的，随时可能会出错，为了避免故障，需要将业务分散开保留一定的冗余度。
## how 
* 根本的问题：计算、存储、网络通讯
* 网关，服务注册与发现，配置中心，分布式db，cache，文件，消息队列，分布式任务，监控；

# DevOps

## what： 敏捷开发 
### 持续集成、持续交付、持续部署
* https://www.zhihu.com/question/23444990
* https://www.jianshu.com/p/56530c80606d

* 持续集成强调开发人员提交了新代码之后，立刻进行构建(拉取代码，编译，打包，归档，运行)、（单元）测试，代码打tag，二进制文件上传到某个仓库->脚本化部署到各个机器。根据测试结果，我们可以确定新代码和原有代码能否正确地集成在一起。
* 持续交付在持续集成的基础上，将集成后的代码部署到更贴近真实运行环境的「类生产环境」（production-like environments）中。比如，我们完成单元测试后，可以把代码部署到连接数据库的 Staging 环境中更多的测试。如果代码没有问题，可以继续手动部署到生产环境中。
* 持续部署则是在持续交付的基础上，把部署到生产环境的过程自动化。
* 这种做法的核心思想在于：既然事实上难以做到事先完全了解完整的、正确的需求，那么就干脆一小块一小块的做，并且加快交付的速度和频率，使得交付物尽早在下个环节得到验证。这一步成功以后，才能进入到下一步，这一步失败，就说明有人提交的代码有问题。早发现问题早返工,持续就是自动化。

* 灰度发布，回滚多个版本，部署依赖，集群自动化部署，微服务注册，发现
## how
### jenkins

```sh
docker run \
 --name jenkins \
  -u root \
  --rm \
  -d \
  -p 8081:8080 \
  -p 50000:50000 \
  -v jenkins-data:/var/jenkins_home \
  -v /var/run/docker.sock:/var/run/docker.sock \
  jenkins/jenkins:lts
  #jenkinsci/blueocean

   /var/jenkins_home/secrets/initialAdminPassword

   6ee39b75882a4377b1f526df58ea47da

```
* https://www.cnblogs.com/yjmyzz/p/jenkins-tutorial-part-1.html
* https://jenkins.io/solutions/java/
* 更换端口 java -jar jenkins.war --ajp13Port=-1 --httpPort=8081
* /root/.jenkins/secrets/initialAdminPassword
* Jenkins默认在当前用户的主目录下创建.jenkins目录，所有的配置文件、数据库都存放在里面，只需要备份这个目录就备份了整个CI配置。

* http://www.supervisord.org/  进程管理
* http://192.168.202.104:5001/
* http://192.168.200.4/projects/microservices/wiki/%E4%BD%BF%E7%94%A8jenkins%E8%BF%9B%E8%A1%8C%E9%A1%B9%E7%9B%AE%E6%89%93%E5%8C%85%E5%B9%B6%E5%BD%92%E6%A1%A3


* Java Network Launching Protocol (JNLP，java网络加载协议) 承诺改变这个现状。通过JCP(Java Community Process)的JSR-56的开发， JNLP解决了很多先前用java开发针对客户端的功能的问题。一个JNLP客户端是一个应用程序或者说服务，它可以从宿主于网络的资源中加载应用程序。如果你使用JNLP打包一个应用程序，那么一个JNLP客户端能够：
o 为该应用探测，安装并且使用正确版本的JRE（java运行时环境）
o 从浏览器或者桌面加载应用程序
o 当新版本的应用出现时自动下载最新的版本。
o 为了加速启动速度在本机缓存应用程序需要的类
o 可以作为applet或者应用程序运行
o 在必要的情况下下载原始的库
o 以安全的方式使用诸如文件系统这样的本机资源
o 自动定位和加载外部依赖资源


## 云服务: 软件的开发、管理、部署
* http://www.ruanyifeng.com/blog/2017/07/iaas-paas-saas.html


# 服务编排-swarm

配置-部署发布-滚动更新回滚-伸缩

## 
资源管理: 集群/主机/容器/镜像的查看和管理  
监控报警: 集群/主机/容器的资源占用，阈值和报警机制  
扩容收缩: 主要针对无状态容器，可以手动扩容或收缩  
故障转移: 基于 Docker Service 的容器级和主机级的故障转移  

* http://wudaijun.com/2018/03/docker-swarm/

# 解压war包
`unzip -oq common.war -d common`
## 服务部署
* [微服务部署：蓝绿部署、滚动部署、灰度发布、金丝雀发布](http://www.jianshu.com/p/022685baba7d)

## 前端工程
* [大公司里怎样开发和部署前端代码？](https://www.zhihu.com/question/20790576)

# 服务器同步时间rdate

`rdate -s time-b.nist.gov`
`ntpdate ntp.sjtu.edu.cn`
* 时间服务器列表  
time.nist.gov     
time-b.nist.gov  
216.118.116.105  
rdate.darkorb.net  
202.106.196.19  
time-b.timefreq.bldrdoc.go  


