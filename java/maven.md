# [maven](http://mvnbook.com/index.html)
## 1. features
* 构建工具build  
* 依赖管理dependencies/快照依赖 
* 配置管理SCMs
* 发布管理Releases  
* 文档编制Documentation  
* 报告Reporting  

## 2. concepts
* 特点
> * 微内核  插件  -》 解析xml，管理生命周期，管理maven插件-》其他功能委派给maven插件-》编译源码，打包war文件，单元测试，发布站点--》mvn install 先下载核心插件
 * 约定优于配置,项目模型,核心概念
 * pom：项目的属性，依赖，构建配置被抽象成pom--》基本组成：项目基本信息，构建环境（开发，生产），pom关系（依赖，继承），构建设置（更改默认设置）
--》
* 项目坐标groupid：artifactid：packaging：vsrsion
### 为了看清楚可以在一个子模块 pom 所在目录下，执行以下命令,可以看到最终起效果的 pom ，这在找错时很有效
* mvn help:effective-pom

### 插件与目标
1. 调用插件目标的两种方式:将插件目标与生命周期绑定，执行生命周期，
2. 直接执行插件目标。
3. 插件列表[apache](http://maven.apache.org/plugins/index.html) or [mojohaus](http://www.mojohaus.org/plugins.html)
4. 注：依赖的远程仓库    ！=  插件的远程仓库，Maven会区别对待他们。  
Maven需要的依赖在本地仓库中不存在时，Maven会去配置的远程仓库中查找  
Maven需要的插件在本地仓库中不存在时，Maven不会去这些远程仓库查找。 
```xml
// 所以要进行配置
<pluginRepositories>
        <pluginRepository>
            <id>spring-milestones</id>
            <name>Spring Milestones</name>
            <url>https://repo.spring.io/milestone</url>
            <snapshots>
                <enabled>false</enabled>
            </snapshots>
        </pluginRepository>
</pluginRepositories>
``` 
* 项目的生命周期  
Maven 把构建项目的过程，总体分为三个生命周期（lifecycle）：   
    1、默认构建：default   
    2、项目清理：clean   
    3、项目建站：site   

每个生命周期又由许多阶段（phase）组成。 
而每个阶段，都可以指定默认执行的目标（goal），去具体执行某项工作。 

在命令行中使用阶段来执行构建。只需输入阶段名称即可。 
Maven会按顺序执行该阶段之前的所有阶段。 
例如： 
mvn clean dependency:copy-dependencies package  
以上命令会执行 clean ，然后执行 dependency 插件的 copy-dependencies 目标（goal）， 
最后执行 package 阶段。 

* 使用内置 packaging 类型时，构建的阶段都是绑定了一个或多个插件，这些插件被称为【核心插件】。    
核心插件的命名规则为：maven-name-plugin 
而自定义插件的命名规则为：name-maven-plugin

* http://maven.apache.org/ref/3.6.0/maven-core/lifecycles.html
* https://lixh1986.iteye.com/blog/2383960
### 构建时会编译三套 ClassPath，分别对应：编译期，运行期，测试期，而 ClassPath 是个逻辑概念，指定所依赖 Jar 的可见性。
* 编译范围（compile）
* 已提供范围（provided）
* 运行时范围（runtime）
* 测试范围（test）
* 系统范围（system）
* [Maven的继承以及import作用域](http://www.cnblogs.com/techroad4ca/p/6512591.html)

* maven仓库：一个存放了所有依赖的仓库，其通过依赖的坐标对其进行管理。--》mvn install --》pom里远程仓库配置
http://search.maven.org/   maven central repo


* 项目站点报告：在项目pom里配置 site插件
```xml
<plugin>
        <groupId>org.apache.maven.plugins</groupId>
        <artifactId>maven-site-plugin</artifactId>
        <version>3.3</version>
        <configuration>
          <locales>zh_CN</locales>
        </configuration>
      </plugin>
      <!-- 使用mvn clean site -->
```

* cmd 构建maven项目  
mvn archetype:generate -->mvn package--》war包放在tomcat下webapps目录下，启动bin目录下的startup.bat 文件，浏览器访问地址是war包名
* packaging标签 jar war ear pom（父）modules>module 相对路径

* 更改setting的localrepo 位置后，cmd mvn help:system 下载的jar包

## 3. command

* Maven 参数  
-D 传入属性参数  
-P 使用pom中指定的配置   
-e 显示maven运行出错的信息     
-o 离线执行命令,即不去远程仓库更新包   
-X 显示maven允许的debug信息   
-U 强制去远程参考更新snapshot包   
例如 mvn install -Dmaven.test.skip=true -Poracle   
其他参数可以通过mvn help 获取  


* maven常用命令  
mvn clean   
说明:清理项目生产的临时文件,一般是模块下的target目录   
mvn package   
说明: 项目打包工具,会在模块下的target目录生成jar或war等文件   
mvn test   
说明:测试命令,或执行src/test/java/下junit的测试用例.   
mvn install   
说明:模块安装命令,将打包的的jar/war文件复制到你的本地仓库中,
供其他模块使用`-Dmaven.test.skip=true` 跳过测试(同时会跳过test compile) mvn package -Dmaven.test.failture.ignore=true  
mvn deploy   
说明: 发布命令 ，将打包的文件发布到远程仓库,提供其他人员进行下载依赖  
mvn dependency:resolve   
处理项目依赖情况   
mvn clean dependency:tree -Dverbose -Dincludes=org.springframework:spring-tx -DDexcludes=| grep log
mvn org.apache.maven.plugins:maven-dependency-plugin:2.10:tree|grep fastjson -C10   
打印出项目的整个依赖树 并查找特定jar包
-Doutput=*.txt   
mvn dependency:analyze   
帮助你分析依赖关系, 用来取出无用, 重复依赖的好帮手   

mvn help:describe -Dplugin=

https://www.cnblogs.com/takemybreathaway/articles/10677228.html

## 处理版本冲突
```
处理jar包依赖冲突,首先,对于多个jar包都引用同一jar包的情况,最好是在程序中显式定义被共同引用的jar包的依赖,来统一版本号,方便维护

如果A和B都依赖同一jar包C,可能会出现两种情况

1.A和B引用的C版本相同,这时按照pom定义顺序选择第一个即可,没有冲突问题,如果在项目的maven中显示定义了C依赖,那么用选择项目定义的依赖,反正version都一样,没有影响

2.A和B依赖的C版本不同,选择版本高的那个,这时会出现两种结果

  (1) 高版本兼容低版本,所以不会出现问题

  (2)高版本不兼容低版本,假如A依赖C2版本,B依赖C3版本,C3不兼容C2,maven选择了高版本C3,对A来说会出现问题

  有3种解决方法

　　[1]提升A版本,找到依赖C3的A版本

　　[2]如果B版本也可依赖C2,在项目的maven中显示定义对C2的依赖,这样所有都使用C2版本

　　[3]如果B版本不支持C2版本,只能降低B版本,找到依赖C2的B版本

　　从功能性和可维护性考虑,高版本提供的功能更多,bug更少,优先考虑1

　　再考虑2

　　最后考虑3
```
## 4. 实战
### [ pom.xml的继承、聚合与依赖](http://elim.iteye.com/blog/2055745)
* 聚合 VS 父POM  
虽然聚合通常伴随着父POM的继承关系，但是这两者不是必须同时存在的，从上面两者的介绍可以看出来，这两者的都有不同的作用，他们的作用不依赖于另一个的配置。  
父POM是为了抽取统一的配置信息和依赖版本控制，方便子POM直接引用，简化子POM的配置。聚合（多模块）则是为了方便一组项目进行统一的操作而作为一个大的整体，所以要真正根据这两者不同的作用来使用，不必为了聚合而继承同一个父POM，也不比为了继承父POM而设计成多模块。
### maven用库顺序
* 当前项目的repository，然后找本地，然后再找私服，最后找中央仓库
* [mirror 和 repository 区别](http://www.cnblogs.com/jiuyi/p/6207246.html)
```xml
<repositories>
    <!--阿里云仓库-->
    <repository>
        <id>aliyun</id>
        <url>http://maven.aliyun.com/nexus/content/groups/public/</url>
    </repository>
</repositories>
```


### 阿里云镜像
```xml
<mirrors>
        <mirror>
            <id>pmz-mirror</id>
            <mirrorOf>!pmz-central,!pmz-snapshots,*</mirrorOf>
            <url>http://dev.pmz.com.cn/nexus/repository/maven-remote/</url>
        </mirror>
        <mirror>
            <id>alimaven</id>
            <name>aliyun maven</name>
            <url>http://maven.aliyun.com/nexus/content/groups/public/</url>
            <mirrorOf>central</mirrorOf>
        </mirror>
    </mirrors>
```
### 引用本地jar包
```xml
//groupId和artifactId以及version都是可以随便填写的 ，scope必须填写为system，而systemPath我们现在我们jar包的目录地址就可以了
<dependency>
            <groupId>com.zzxapi</groupId>
            <artifactId>api</artifactId>
            <version>1</version>
            <scope>system</scope>
            <systemPath>${pom.basedir}/src/main/webapp/WEB-INF/lib/ZzxOAuthMobileServerApi-2.3.jar</systemPath>
        </dependency>

<plugin>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-maven-plugin</artifactId>
    <configuration>
        <includeSystemScope>true</includeSystemScope>
    </configuration>
</plugin>
```
### 将jar包安装到本地repository中
```shell
mvn install:install-file  
-Dfile= jar文件所存放的地址     
-DgroupId= jar文件所属的group：包名   
-DartifactId=  jar的项目名 名称，一般就是去掉后缀的文件名     
-Dversion=版本号  
-Dpackaging=jar：此包的打包形式，就是jar  
-DgeneratePom=true  
<!-- 例如 -->
mvn install:install-file -Dfile=D:\JAR_LIB\rabbitmq-client.jar -DgroupId=com.rabbitmq -DartifactId=client -Dversion=3.5.0 -Dpackaging=jar  -DgeneratePom=true -DcreateChecksum=true
<!-- 之后就可以正常引用 -->

mvn install:install-file -Dfile=lib/jmxtools-1.2.1.jar -DgroupId=com.sun.jdmk -DartifactId=jmxtools -Dversion=1.2.1 -Dpackaging=jar
```
## 添加 in project repository
```xml
设置项目的库目录
<repository>

    <id>in-project</id>

    <name>In Project Repo</name>

    <url>file://${project.basedir}/lib</url>

</repository>
添加依赖：


<dependency>

    <groupId>com.rabbitmq</groupId>

    <artifactId>client</artifactId>

    <version>3.5.0</version>

</dependency>
<!-- 本例中： lib/com/rabbitmq/client/3.5.0/rabbitmq-client-3.5.0.jar -->
```
### nexus私服配置

#### 依赖搜索顺序
本地-中央-远程私服

* [nexux 使用 ](http://blog.csdn.net/huxu981598436/article/details/54945589)
```xml
<!-- 私服的配置推荐用profile配置而不是mirror（毕竟mirror是镜像，私服其实是n个镜像及自己的开发库等的合集） -->
  <profiles>
    <profile>
      <id>nexus</id>
      <repositories>
        <repository>
          <id>nexus</id>
          <url>http://192.168.163.xx:xx/nexus/content/groups/public/</url>
          <releases>
            <enabled>true</enabled>
          </releases>
          <snapshots>
            <enabled>true</enabled>
          </snapshots>
        </repository>
      </repositories>
      <pluginRepositories>
        <pluginRepository>
          <id>nexus</id>
          <url>http://192.168.163.xx:xx/nexus/content/groups/public/</url>
          <releases>
            <enabled>true</enabled>
          </releases>
          <snapshots>
            <enabled>true</enabled>
          </snapshots>
        </pluginRepository>
      </pluginRepositories>
    </profile>
  </profiles>
  <activeProfiles>
    <activeProfile>nexus</activeProfile>
    <!-- <activeProfile>nexus</activeProfile> 可以同时激活多个，相同配置项取值规则：根据profile定义的先后顺序来进行覆盖取值的，后面定义的会覆盖前面定义-->
  </activeProfiles>

  <!--项目发布到私服，maven项目使用命令：mvn clean deploy；需要在pom文件中配置一下代码；-->
  <distributionManagement>
          <repository>
              <id>user-release</id>
              <name>User Project Release</name>
              <url>http://192.168.1.103:8081/nexus/content/repositories/releases/</url>
          </repository>
  
          <snapshotRepository>
              <id>user-snapshots</id>
             <name>User Project SNAPSHOTS</name>             <url>http://192.168.1.103:8081/nexus/content/repositories/snapshots/</url>
         </snapshotRepository>
     </distributionManagement>
<!--注意还需要配置mvn发布的权限，否则会报401错误，在settings.xml中配置权限，其中id要与pom文件中的id一致-->
<server>
      <id>user-release</id>
      <username>admin</username>
      <password>admin123</password>
  </server>
  <server>
      <id>user-snapshots</id>
      <username>admin</username>
      <password>admin123</password>
 </server>

 <build>  
        <plugin>  
            <groupId>org.apache.maven.plugins</groupId>  
            <artifactId>maven-release-plugin</artifactId>  
            <version>2.4.1</version>  
        </plugin>  
        <!--打包jar包-->  
        <plugin>  
            <groupId>org.apache.maven.plugins</groupId>  
            <artifactId>maven-deploy-plugin</artifactId>  
            <version>2.7</version>  
            <configuration>  
                <updateReleaseInfo>true</updateReleaseInfo>  
            </configuration>  
        </plugin>  
        <!--打包源码-->  
        <plugin>  
            <groupId>org.apache.maven.plugins</groupId>  
            <artifactId>maven-source-plugin</artifactId>  
            <version>2.2.1</version>  
            <executions>  
                <execution>  
                    <phase>package</phase>  
                    <goals>  
                        <goal>jar</goal>  
                    </goals>  
                </execution>  
            </executions>  
        </plugin>   
</build>  

<!-- 或者 -->
<?xml version="1.0" encoding="UTF-8" ?>

<settings xmlns="http://maven.apache.org/SETTINGS/1.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://maven.apache.org/SETTINGS/1.0.0 http://maven.apache.org/xsd/settings-1.0.0.xsd">
    <localRepository>D:\maven\localRepository</localRepository>
    <pluginGroups>
    </pluginGroups>
    <proxies>
    </proxies>
    <servers>
        <server>
            <id>tomcat</id>
            <username>admin</username>
            <password>admin123</password>
        </server>
    </servers>
    <mirrors>
        <mirror>
            <id>nexus-public</id>
            <mirrorOf>public</mirrorOf>
            <name>192.168.205.11-nexus</name>
            <url>http://192.168.205.11:8282/repository/public/</url>
        </mirror>

		<mirror>
			<id>alimaven</id>
			<name>aliyun maven</name>
			<url>http://maven.aliyun.com/nexus/content/groups/public/</url>
			<mirrorOf>central</mirrorOf>        
		</mirror>
    </mirrors>
    <profiles>
        <profile>
            <id>nexus</id>
            <repositories>
                <repository>
                    <id>nexus</id>
                    <name>192.168.200.125-nexus</name>
                    <url>http://192.168.205.11:8282/repository/public/</url>
                    <releases>
                        <enabled>true</enabled>
                    </releases>
                    <snapshots>
                        <enabled>true</enabled>
                    </snapshots>
                </repository>
				<repository>
					<id>alimaven</id>
					<url>http://maven.aliyun.com/nexus/content/groups/public/</url>
                </repository>
                <repository>
                    <id>Alfresco Maven Repository</id>
                    <url>https://maven.alfresco.com/nexus/content/groups/public/</url>
                </repository>
            </repositories>
            <pluginRepositories>
                <pluginRepository>
                    <id>nexus</id>
                    <name>192.168.200.125-nexus</name>
                    <url>http://192.168.205.11:8282/repository/public/</url>
                    <releases>
                        <enabled>true</enabled>
                    </releases>
                    <snapshots>
                        <enabled>true</enabled>
                    </snapshots>
                </pluginRepository>
            </pluginRepositories>
        </profile>		
    </profiles>
    <activeProfiles>
        <activeProfile>nexus</activeProfile>
    </activeProfiles>
</settings>
```
* `mvn help:active-profiles`查看处于激活状态的profile
* 参考 [maven profile介绍 by Elim](http://elim.iteye.com/blog/1900568)
* 参考 [maven profile使用 by 每日懂一点](http://www.cnblogs.com/lzxianren/p/maven-profile.html)

### 开发、测试、生产环境 配置分离
* 参考 [Maven 打包实现生产环境与测试环境配置分离 by 有爱的小止](https://ixiaozhi.com/java-maven-archive-different-profile/)

```xml
<!-- pom.xml -->
<profiles>
        <profile>
            <id>product</id>
            <properties>
              <sys.jdbc.config.path>file:/home/config/iBase4J/jdbc-sys.properties</sys.jdbc.config.path>
              <system.config.path>file:/home/config/iBase4J/system.properties</system.config.path>
            </properties>
            <build>
                <filters>
                    <filter>${basedir}/filters/jdbc-product.properties</filter>
                </filters>
            </build>
        </profile>
        <profile>
            <id>test</id>
            <build>
                <filters>
                    <filter>${basedir}/filters/jdbc-test.properties</filter>
                </filters>
            </build>
        </profile>
        <profile>
            <id>dev</id>
            <activation>
                <activeByDefault>true</activeByDefault>
            </activation>
            <build>
            <finalName>${project.name}</finalName>
            <resources>
              <resource>
                <directory>src/main/java</directory>
                <includes>
                  <include>**/*.properties</include>
                  <include>**/*.xml</include>
                </includes>
                <filtering>true</filtering>
              </resource>
              <resource>
                <directory>src/main/resources</directory>
              </resource>
            </resources>
                <filters>
                    <filter>${basedir}/filters/jdbc-test.properties</filter>
                </filters>
                <pluginManagement>
          <plugins>
            <plugin>
              <groupId>org.apache.tomcat.maven</groupId>
              <artifactId>tomcat7-maven-plugin</artifactId>
              <version>2.2</version>
              <executions>
                <execution>
                  <id>run-war-only</id>
                  <phase>pre-integration-test</phase>
                  <goals>
                    <goal>run-war-only</goal>
                  </goals>
                </execution>
              </executions>
              <configuration>
                <warDirectory>target/${project.name}</warDirectory>
                <path>/</path>
                <contextReloadable>true</contextReloadable>
                <uriEncoding>UTF-8</uriEncoding>
                <port>${server.port}</port>
                <url>http://localhost:${server.port}/manager</url>
                <server>tomcat</server>
                <username>admin</username>
                <password>admin</password>
                <contextReloadable>true</contextReloadable>
                <systemProperties>
                  <webapps>
                    <webapp>
                      <groupId>${project.name}</groupId>
                      <artifactId>${project.name}</artifactId>
                      <version>${project.version}</version>
                      <type>${project.packaging}</type>
                      <asWebapp>true</asWebapp>
                      <contextPath>/</contextPath>
                    </webapp>
                  </webapps>
                </systemProperties>
              </configuration>
            </plugin>
          </plugins>
        </pluginManagement>
            </build>
        </profile>
    </profiles>
```
### 假如你的Project A的某个依赖D添加了<optional>true</optional>，当别人通过pom依赖Project A的时候，D不会被传递依赖进来  

当你依赖某各工程很庞大或很可能与其他工程的jar包冲突的时候建议加上该选项，可以节省开销，同时减少依赖冲突


## [maven-assembly-plugin](http://maven.apache.org/plugins/maven-assembly-plugin/examples/index.html)
* [使用](http://ee-dreamer.com/?p=1129)
* [使用](https://www.jianshu.com/p/14bcb17b99e0)
* [boot ](https://github.com/geekidea/spring-boot-assembly)
* [profile](https://lotabout.me/2018/Maven-Profile-and-Spring-Profile/)


## [maven-shade-plugin](http://maven.apache.org/plugins/maven-shade-plugin/examples/resource-transformers.html#AppendingTransformer)
* https://www.jianshu.com/p/d9fb7afa634d
* https://zhuanlan.zhihu.com/p/62796806
* [filter](https://gist.github.com/yangl/830e7338faf460bc5acc0442c6f6c132)

### 依赖冲突

Maven 解析 pom.xml 文件时，同一个 jar 包只会保留一个，这样有效的避免因引入两个 jar 包导致的工程运行不稳定性。

Maven 默认处理策略
最短路径优先
Maven 面对 D1 和 D2 时，会默认选择最短路径的那个 jar 包，即 D2。E->F->D2 比 A->B->C->D1 路径短。

最先声明优先
如果路径一样的话，举个�： A->B->C1, E->F->C2 ，两个依赖路径长度都是 2，那么就选择最先声明。

移除依赖
如果我们不想通过 A->B->D1 引入 D1 的话，那么我们在声明引入 A 的时候将 D1 排除掉，这样也避免了包冲突。
举个：将 zookeeper 的 jline 依赖排除 用exclusions标签


### [maven 执行主类](https://www.jianshu.com/p/ad83c9d53ec4)
* https://segmentfault.com/a/1190000005043251


# 下载源码，javadoc classifier
http://maven.apache.org/plugins/maven-dependency-plugin/get-mojo.html

mvn dependency:get -Dartifact=org.elasticsearch.client:elasticsearch-rest-high-level-client:5.6.16:jar:sources

mvn dependency:get -Dartifact=org.janusgraph:janusgraph-core:0.2.3:jar:sources

mvn dependency:get -Dartifact=org.elasticsearch.client:elasticsearch-rest-high-level-client:5.6.16:jar:javadoc

mvn dependency:get -Dartifact=cn.hutool:hutool-all:5.4.6:jar:sources

## 公有jar包打规范(推荐)
当你发布公共jar包或者dubbo应用api接口共有jar包时，在maven的plugs中加入maven-source-plugin,示例如下：  
```xml
<!-- Source -->
<plugin>
    <groupId>org.apache.maven.plugins</groupId>
    <artifactId>maven-source-plugin</artifactId>
    <version>3.2.1</version>
    <executions>
        <execution>
            <phase>package</phase>
            <goals>
                <goal>jar-no-fork</goal>
            </goals>
        </execution>
    </executions>
</plugin>
```
这样发布的时候就会生成一个[your jar name]-sources.jar的源码包，这个包也会一起发布到私有仓库。这样就可以通过classifier来指定sources了。如果还是不清楚可以直接参考smart-doc源码的pom.xml配置
```xml
<!--依赖库源码-->
<dependency>
    <groupId>com.github.shalousun</groupId>
    <artifactId>common-util</artifactId>
    <version>1.8.6</version>
    <classifier>sources</classifier>
    <!--设置为test,项目发布时source不会放入最终的产品包-->
    <scope>test</scope>
</dependency>
在加载jar包和source源码jar包时，如出现代码导入错误可尝试变更二者依赖顺序
```
### mvn clean package -pl module-b -am

https://www.cnblogs.com/hiver/p/7850954.html
