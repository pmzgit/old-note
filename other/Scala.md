Scala 是一门多范式（multi-paradigm）的编程语言，设计初衷是要集成面向对象编程和函数式编程的各种特性。

Scala 运行在Java虚拟机上，并兼容现有的Java程序。

Scala 源代码被编译成Java字节码，所以它可以运行于JVM之上，并可以调用现有的Java类库。

## 特性
* 面向对象
Scala是一种纯面向对象的语言，每个值都是对象。

类抽象机制的扩展有两种途径：一种途径是子类继承，另一种途径是灵活的混入机制。这两种途径能避免多重继承的种种问题。

* 函数式编程

## 安装

scalac HelloWorld.scala  // 把源码编译为字节码  
scala HelloWorld  // 把字节码放到虚拟机中解释运行



https://www.scala-lang.org/download/

https://www.scala-lang.org/download/all.html

export SCALA_HOME=/usr/local/scala-2.11.8  
export PATH=$PATH:$SCALA_HOME/bin

scala -version

## [语法](https://docs.scala-lang.org/zh-cn/overviews/index.html)
* 类型 

https://blog.chaofan.io/archives/scala%e5%ad%a6%e4%b9%a0%ef%bc%88%e5%9b%9b%ef%bc%89-%e7%b1%bb%e5%9e%8b

http://liangfan.tech/2019/01/10/%E6%AD%A4%E7%94%9F%E6%8C%9A%E5%8F%8BScala%E4%B9%8B2-%E6%95%B0%E6%8D%AE%E7%B1%BB%E5%9E%8B%E6%A6%82%E8%BF%B0/

https://www.zybuluo.com/wuzhimang/note/848212

* oop

http://bigdata-star.com/archives/1555
https://www.jianshu.com/p/5bae278b3966


* 变量，常量声明

val xmax, ymax = 100  // xmax, ymax都声明为100

i to j 语法(包含 j) ，i until j 语法(不包含 j)，左箭头 <- 用于为变量 x 赋值，分号 (;) 来设置多个区间，它将迭代给定区间所有的可能值，用分号(;)来为表达式添加一个或多个的过滤条件

for( a <- 1 to 3; b <- 1 to 3){
    println( "Value of a: " + a );
    println( "Value of b: " + b );
}

for( a <- numList 
if a != 3; if a < 8 ){
    println( "Value of a: " + a );
}
大括号中用于保存变量和条件，retVal 是变量， 循环中的 yield 会把当前的元素记下来，保存在集合中，循环结束后将返回该集合
var retVal = for{ a <- numList 
                        if a != 3; if a < 8
}yield a

val outer = new Breaks;
      val inner = new Breaks;

      outer.breakable {
         for( a <- numList1){
            println( "Value of a: " + a );
            inner.breakable {
               for( b <- numList2){
                  println( "Value of b: " + b );
                  if( b == 12 ){
                     inner.break;
                  }
               }
            } // 内嵌循环中断
         }
      } // 外部循环中断


本地方法，即方法中嵌套方法，局部函数。

PartialFunction其实是Funtion1的子类
那PartialFunction有什么作用呢？

模式匹配！

PartialFunction最重要的两个方法，一个是实际的操作逻辑，一个是校验，其实就是用来做模式匹配的。

* 集合

https://blog.chaofan.io/archives/scala%e5%ad%a6%e4%b9%a0%ef%bc%88%e5%8d%81%e4%ba%8c%ef%bc%89-%e9%9b%86%e5%90%88%e7%b1%bb%e5%9e%8b

https://blog.csdn.net/hellojoy/article/details/81231460

* fp

https://www.jianshu.com/p/9b9519a36d78
https://blog.csdn.net/qq_26222859/article/details/55226349

https://blog.chaofan.io/archives/scala%e5%ad%a6%e4%b9%a0%ef%bc%88%e5%8d%81%e4%b8%80%ef%bc%89-lambda%e8%a1%a8%e8%be%be%e5%bc%8f

scala没有static关键字，搞出了个object关键字来新建单例对象。在单例对象中的成员都是static的。所以要写util类一般都要用这个东西。

这两个概念是相互的。假设有object A 和 class A 两个同名了。这时候就可以说：object A是class A的“伴生对象”；class A是object A的“伴生类”。当一个object B没有同名的class B的时候，object B就叫“做独立对象”。

伴生带来的特权就是：它们可以互相访问私有成员。

class和object的区别：
  1、单例对象不能用new来初始化。
  2、单例对象不能带参数。
  3、单例对象在第一次调用的时候才初始化。
https://www.iteye.com/blog/clojure-2091818
http://yangcongchufang.com/scala-parital-function.html

* 泛型

https://blog.chaofan.io/archives/scala%E5%AD%A6%E4%B9%A0%EF%BC%88%E4%BA%94%EF%BC%89-%E6%B3%9B%E5%9E%8B

* 模式匹配

https://www.cnblogs.com/zlslch/p/6115392.html

* 反射

https://blog.csdn.net/u011152627/article/details/77745119
https://blog.csdn.net/feloxx/article/details/76034023

* 特殊符号

https://notes.mengxin.science/2018/09/07/scala-special-symbol-usage/  

# 编程
* idea  + maven + java + scala

https://dongkelun.com/2019/07/16/ideaMavenScalaJava/  
https://www.cnblogs.com/lingluo2017/p/8673243.html  
https://davidb.github.io/scala-maven-plugin/example_java.html
```sh
# compile only
mvn compile
# or compile and test
mvn test
# or compile, test and package
mvn package


mvn scala:console
```