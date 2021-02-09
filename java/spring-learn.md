# spring
## aware
spring中提供了一些Aware结尾的接口，比如：BeanFactoryAware、BeanNameAware、ApplicationContextAware、ResourceLoaderAware、ServletContextAware等，这些接口的作用是：实现这些接口的Bean被实例化后，可以取得一些相对的资源
因为ApplicationContext 接口集成了MessageSource 接口、ApplicationEventPublisher 接口和ResourceLoader 接口，所以Bean 继承ApplicationContextAware 可以获得Spring 容器的所有服务，原则上用到什么接口，就实现什么接口

## [@Import](http://weiqingfei.iteye.com/blog/2361152)

@Import 是被用来整合所有在@Configuration注解中定义的bean配置


## BeanPostProcessor、BeanFactoryPostProcessor、BeanValidationPostProcessor，ConfigurationClassPostProcessor等一系列后处理器


## [Configuration和@Component](https://blog.csdn.net/isea533/article/details/78072133)


配置类不能是 final 类（没法动态代理）
配置类不能是本地化的，亦即不能将配置类定义在其他类的方法内部；
配置类必须有一个无参构造函数
(1)、@Bean注解在返回实例的方法上，如果未通过@Bean指定bean的名称，则默认与标注的方法名相同； 

(2)、@Bean注解默认作用域为单例singleton作用域，可通过@Scope(“prototype”)设置为原型作用域； 

(3)、既然@Bean的作用是注册bean对象，那么完全可以使用@Component、@Controller、@Service、@Ripository等注解注册bean，当然需要配置@ComponentScan注解进行自动扫描。

* [Spring @Configuration 使用](https://www.jianshu.com/p/06b2f181d799)

CachingConfigurer

* [JSR-330标准注解](https://blog.csdn.net/EthanWhite/article/details/51879871)

## servlet URL
```java
basePath:http://localhost:8080/test/

getContextPath:/test 
getServletPath:/test.jsp 
getRequestURI:/test/test.jsp 
getRequestURL:http://localhost:8080/test/test.jsp 
getRealPath:D:\Tomcat 6.0\webapps\test\ 
getServletContext().getRealPath:D:\Tomcat 6.0\webapps\test\ 
getQueryString:p=fuck

在一些应用中，未登录用户请求了必须登录的资源时，提示用户登录，此时要记住用户访问的当前页面的URL，当他登录成功后根据记住的URL跳回用户最后访问的页面：

String lastAccessUrl = request.getRequestURL() + "?" + request.getQueryString();


```

## aop
* https://www.cnblogs.com/liaojie970/p/7883687.html

# spring-boot

## 初始化 

* http://start.spring.io/
* spring-boot-starter-parent是一个特殊的starter,它用来提供相关的Maven默认依赖，使用它之后，常用的包依赖可以省去version标签
* 你不想使用某个依赖默认的版本，您还可以通过覆盖自己的项目中的属性来覆盖各个依赖项(spring-boot-dependencies pom 中找)
* Spring Boot通过提供众多起步依赖降低项目依赖的复杂度。起步依赖本质上是一个Maven项目对象模型（Project Object Model，POM），定义了对其他库的传递依赖，这些东西加在一起即支持某项功能。很多起步依赖的命名都暗示了它们提供的某种或者某类功能。
* spring-boot-maven-plugin
把项目打包成一个可执行的超级JAR（uber-JAR）,包括把应用程序的所有依赖打入JAR文件内，并为JAR添加一个描述文件，其中的内容能让你用java -jar来运行应用程序。
搜索public static void main()方法来标记为可运行类。
* @SpringBootApplication是Sprnig Boot项目的核心注解，主要目的是开启自动配置
* Spring Boot使用了一个全局的配置文件application.properties，放在src/main/resources目录下或者类路径的/config下。Sping Boot的全局配置文件的作用是对一些默认配置的配置值进行修改。
* 各个参数之间也可以直接引用来使用  
${conf1}在此${conf2}
* 在Spring Boot中多环境配置文件名需要满足application-{profile}.properties的格式,想要使用对应的环境，只需要在application.properties中使用spring.profiles.active属性来设置，值对应上面提到的{profile},也可以 命令行启动加：--spring.profiles.active=dev

* 在代码里，我们还可以直接用@Profile注解来进行配置，spring.profiles.include来叠加profile

* @EnableAutoConfiguration自动配置的魔法骑士就变成了：从classpath中搜寻所有的META-INF/spring.factories配置文件，并将其中org.springframework.boot.autoconfigure.EnableutoConfiguration对应的配置项通过反射（Java Refletion）实例化为对应的标注了@Configuration的JavaConfig形式的IoC容器配置类，然后汇总为一个并加载到IoC容器。
### https://www.hifreud.com/2017/06/23/spring-boot-05-Externalized-Configuration/
* springboot 有读取外部配置文件的方法，如下优先级：
第一种是在jar包的同一目录下建一个config文件夹，然后把配置文件放到这个文件夹下。
第二种是直接把配置文件放到jar包的同级目录。
第三种在classpath下建一个config文件夹，然后把配置文件放进去。
第四种是在classpath下直接放配置文件。

* 内外都有配置文件，配置文件读取是有优先级,外配置文件优于内配置文件读取。（这个没疑问）。
如果内配置文件里有外配置文件没有的配置，那两者互补。比如外配置文件没有配置数据库，内配置文件里配置了数据库，那内配置文件的配置会被使用。
如果内配置文件里和外配置文件里都有相同的配置，比如两者都配置了数据库，但是两个连接的不同，那外配置文件会覆盖内配置文件里的配置。

### 参考自
* [嘟嘟独立博客](http://tengj.top/2017/02/26/springboot1/)
* [嘟嘟独立博客](http://tengj.top/2017/02/28/springboot2/)
* [嘟嘟独立博客](http://tengj.top/2017/03/09/springboot3/)

## 启动：三种方式
### maven插件
* mvn spring-boot:help -Dgoal=run -Ddetail=true
* mvn spring-boot:run -Dspring-boot.run.arguments="--server.port=8111"
### java -jar
* mvn clean install -Dmaven.test.skip=true
* java -Ddebug -jar emample.jar --server.port=8081 --debug 该命令行参数，将会覆盖application.properties中的端口配置; -D传入系统参数（System.getProperty()） --spring.config.location=./target/cti-scs-sinc/config/
### main 方法


### spring-boot 配置，依赖分离
* https://www.zhangjava.com/springboot%E5%B0%86%E9%A1%B9%E7%9B%AE%E4%B8%8E%E4%BE%9D%E8%B5%96%E5%88%86%E5%BC%80%E6%89%93%E5%8C%85/

## SpringBoot打成jar包后获取classpath下文件失败
Thread.currentThread().getContextClassLoader().getResource("/").getPath();
ClassPathResource resource = new ClassPathResource("application.yml");
File file = resource.getFile();
FileUtils.readLines(file).forEach(System.out::println);
未打包时可以获取到文件，打包成jar后报错。

这是因为打包后Spring试图访问文件系统路径，但无法访问jar包中的路径。因此必须使用resource.getInputStream()

ClassPathResource resource = new ClassPathResource("application.yml");
InputStream inputStream = resource.getInputStream();
IOUtils.readLines(inputStream).forEach(System.out::println);

## spring-boot 热部署 
* jvm 参数`-javaagent:D:/code/springloaded-1.2.8.RELEASE.jar -noverify`
* -Ddebug 或者在application.properties文件这添加属性debug= true。这样，当我们以调试模式启动应用程序时，SpringBoot就可以帮助我们创建自动配置的运行报告。
* https://blog.csdn.net/fxbin123/article/details/80518664

* mvn spring-boot:run -Dspring-boot.run.profiles=local -Ddebug 
* Arguments that should be passed to the application. On command line use
      commas to separate multiple arguments.
      User property: spring-boot.run.arguments



## https://github.com/spotify/dockerfile-maven


# spring-cloud

[sofastack](https://www.sofastack.tech/)

[云原生](https://skyao.io/learning-cloudnative/)

[服务网格](https://www.cnblogs.com/xishuai/p/microservices-and-service-mesh.html)

https://skyao.io/

[TP50,TP90，TP99，TP999](https://www.cnblogs.com/robinunix/p/7827423.html)


## spring-boot
[参数校验](https://www.cnblogs.com/mr-yang-localhost/p/7812038.html)