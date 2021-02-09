## 参考
* [java-design-patterns](http://java-design-patterns.com/)
* [设计模式](https://design-patterns.readthedocs.io/zh_CN/latest/structural_patterns/decorator.html)

## 接口和抽象类
* 在interface里面的变量默认都是public static final 的。所以可以直接省略修饰符：`String param="ssm"；//变量需要初始化`
* 假如可以是非static的话，因一个类可以继承多个接口，出现重名的变量，如何区分呢？
* 虽然可以直接修改这些静态成员变量的值，但所有实现类对应的值都被修改了，这跟抽象类有何区别?
* 对修改关闭，对扩展（不同的实现implements）开放，接口是对开闭原则（Open-Closed Principle ）的一种体现。
```
抽象类和接口的对比:

参数	抽象类	接口

默认的方法实现	它可以有默认的方法实现	接口完全是抽象的。它根本不存在方法的实现

实现	子类使用extends关键字来继承抽象类。如果子类不是抽象类的话，它需要提供抽象类中所有声明的方法的实现。	子类使用关键字implements来实现接口。它需要提供接口中所有声明的方法的实现

构造器	抽象类可以有构造器	接口不能有构造器

与正常Java类的区别	除了你不能实例化抽象类之外，它和普通Java类没有任何区别	接口是完全不同的类型

访问修饰符	抽象方法可以有public、protected和default这些修饰符	接口方法默认修饰符是public。你不可以使用其它修饰符。

多继承	抽象方法可以继承一个类和实现多个接口	接口只可以继承一个或多个其它接口

速度	它比接口速度要快	接口是稍微有点慢的，因为它需要时间去寻找在类中实现的方法。

添加新方法	如果你往抽象类中添加新的方法，你可以给它提供默认的实现。因此你不需要改变你现在的代码。	如果你往接口中添加方法，那么你必须改变实现该接口的类。

```

* 什么时候使用抽象类和接口  
     * 如果你拥有一些方法并且想让它们中的一些有默认实现，那么使用抽象类吧。
    * 如果你想实现多重继承，那么你必须使用接口。由于Java不支持多继承，子类不能够继承多个类，但可以实现多个接口。因此你就可以使用接口来解决它。
    * 如果基本功能在不断改变，那么就需要使用抽象类。如果不断改变基本功能并且使用接口，那么就需要改变所有实现了该接口的类。
* Java8中的默认方法和静态方法  
Oracle已经开始尝试向接口中引入默认方法和静态方法，以此来减少抽象类和接口之间的差异。现在，我们可以为接口提供默认实现的方法了并且不用强制子类来实现它。
* [浅谈 Java 8 接口默认方法和静态方法的设计](https://blog.csdn.net/ziwang_/article/details/78680446)
### 参考
* [http://blog.csdn.NET/zhangerqing](http://blog.csdn.net/zhangerqing/article/details/8194653)

### UML类图关系
* [UML类图关系 by 明明的天天](http://www.cnblogs.com/olvo/archive/2012/05/03/2481014.html)

### **重要提示！** 此文档只是学习Java设计模式时，自己做的简要笔记，非常简陋，可以与代码一同参考，代码地址: [github designpattern](https://github.com/pmzgit/parent/tree/master/common-util/src/test/java/designpattern)

## 一、 创建型
#### 工厂模式

1. 静态工厂方法模式
* 角色：产品类 实现 产品功能接口; 工厂类->多个静态生产方法 返回 产品功能接口(实现：不同方法 返回 对应的产品类实例)
```java
// 产品功能接口
public interface Sender {  
    public void Send();  
}  

public class FactoryTest {  
  
    public static void main(String[] args) {      
        Sender sender = SendFactory.produceMail();  
        sender.Send();  
    }  
}  
```
* 一般扩展场景：需要能够增加新的产品时。可以增加新的产品类（实现产品功能接口），修改工厂类（增加对应的静态生产方法）.
* 缺点：不符合开闭原则 
2. 抽象工厂模式
* 角色：产品类 实现 产品功能接口; 工厂类（多个工厂实现类，不同实现类 返回 对应的产品组合实例） 实现 生产产品工厂接口;
```java
// 生产产品接口
public interface Provider {  
    public Sender produce();  
}  

public class Test {  
  
    public static void main(String[] args) {  
        Provider provider = new SendMailFactory();  
        Sender sender = provider.produce();  
        sender.Send();  
    }  
}  
```
* 一般扩展场景：需要能够增加新的产品时。可以增加新的产品类（实现产品功能接口），增加新的工厂类（方法返回 为 新的产品 组合接口）.
* 缺点： 

#### 单例模式：保证在一个JVM中，该对象只有一个实例存在[参考](http://wuchong.me/blog/2014/08/28/how-to-correctly-write-singleton-pattern/)
1. 使用场景
* 需要全局共享，并唯一的数据和功能，例如：核心引擎
* 减少复杂类，大类的实例创建，减轻系统开销
2. 考虑多线程环境下的同步问题
```java
public class Singleton {  
  
    /* 持有私有静态实例，防止被引用，此处赋值为null，目的是实现延迟加载 
       volatile： 禁止指令重排序优化 ,**可选** 当使用双重检验锁时，内部采用调用同步方法而不是写同步块时，可以不用volatile修饰，否则双重检验锁有问题
    */  
    // private volatile  static Singleton instance = null;  
    private static Singleton instance = null;
    /* 私有构造方法，防止被实例化 */  
    private Singleton() {  
    }  
    // 双重检验锁模式（double checked locking pattern）
    private static synchronized void syncInit() {  
        if (instance == null) {  
            instance = new Singleton();  
        }  
    }  
  //不能简单用双重检验锁。原因： jvm 中 分配内存空间，把内存地址分配给变量 和 初始化 分开进行，并不是一个原子操作，多线程环境下会出现问题，所以才会如此用，如果用volatile 修饰变量，可简单使用双重检验锁
    public static Singleton getInstance() {  
        if (instance == null) {  
            syncInit();  
        }  
        return instance;  
    }  
  
    /* 如果该对象被用于序列化，可以保证对象在序列化前后保持一致 */  
    public Object readResolve() {  
        return instance;  
    }  
}  
```
3. 用静态内部类的方式初始化单例（原因：jvm中类加载过程中，能够保证线程互斥.这种写法仍然使用JVM本身机制保证了线程安全问题；由于 SingletonHolder 是私有的，除了 getInstance() 之外没有办法访问它，因此它是懒汉式的；同时读取实例的时候不会进行同步，没有性能缺陷；也不依赖 JDK 版本。
```java
public class Singleton {  
  
    /* 私有构造方法，防止被实例化 */  
    private Singleton() {  
    }  
  
    /* 此处使用一个内部类来维护单例 */  
    private static class SingletonFactory {  
        private static Singleton instance = new Singleton();  
    }  
  
    /* 获取实例 */  
    public static final Singleton getInstance() {  
        return SingletonFactory.instance;  
    }  
  
    /* 如果该对象被用于序列化，可以保证对象在序列化前后保持一致 */  
    public Object readResolve() {  
        return getInstance();  
    }  
}  

```
#### 原型模式 ：将一个**对象**作为原型，对其进行复制、克隆，产生一个和原对象类似的新对象
1. 原型类Prototype 
* 实现Cloneable接口（某些实现需要实现Serializable，例如利用对象流的方式实现深拷贝）
* 重写Object类中的clone方法，并设置作用域为public
2. 使用场景
* 原型模式创建对象比直接new一个对象在性能上要好的多,因为Object类的clone方法是一个本地方法，它直接操作内存中的二进制流，特别是复制大对象时，性能的差别非常明显。
* 深拷贝与浅拷贝，单纯的super.clone方法只是浅拷贝，即8种基本数据类型和他们的封装类。（要实现深拷贝，必须将原型模式中的数组、容器对象、引用对象等另行拷贝，或者在某些场景下进行特殊拷贝逻辑）

#### 适配器模式（Adapter）
1. 使用场景
* 类的适配器模式：当希望将一个类转换成满足另一个新接口的类时，可以使用类的适配器模式，创建一个新类，继承原有的类，实现新的接口即可。
* 对象的适配器模式：当希望将一个对象转换成满足另一个新接口的对象时，可以创建一个Wrapper类，持有原类的一个实例，在Wrapper类的方法中，调用实例的方法就行。
* 接口的适配器模式：当不希望实现一个接口中所有的方法时，可以创建一个抽象类Adapter（这样就能保证，这个类只能被继承，不能实例化），实现所有方法，我们写别的类的时候，继承抽象类即可（e g：spring中的WebMvcConfigurerAdapter）。

#### 装饰器模式（Decorator）: 装饰模式就是给一个对象增加一些新的功能，而且是动态的，要求装饰对象和被装饰对象实现同一个接口，装饰对象持有被装饰对象的实例
1. 装饰器模式的应用场景：  
* 需要扩展一个类的功能。
* 动态的为一个对象增加功能，而且还能动态撤销。（继承不能做到这一点，继承的功能是静态的，不能动态增删。）
2. 缺点：
* 产生过多相似的对象，不易排错！
3. 实现
* 实现原理与 **对象的适配器模式** 相似

#### 代理模式（Proxy）：代理模式就是多一个代理类出来，即给某一个对象提供一个代理, 并由代理对象控制对原对象的引用.
1. 参考：
* [动态代理 by 永顺](https://segmentfault.com/a/1190000007089902)
* [JDK的动态代理](http://blog.jobbole.com/104433/)
2. 静态代理：和装饰器模式类似,代理模式主要涉及三个角色:
* Subject: 抽象角色, 声明真实对象和代理对象的共同接口.
* Proxy: 代理角色, 它是真实角色的封装, 其内部持有真实角色的引用, 并且提供了和真实角色一样的接口, 因此程序中可以通过代理角色来操作真实的角色, 并且还可以附带其他额外的操作.
* RealSubject: 真实角色, 代理角色所代表的真实对象, 是我们最终要引用的对象.
* 原理：需要实现一个从不同存储介质(例如磁盘, 网络, 数据库)加载图片的功能, LoadImageProxy 是代理类, 它会将所有的接口调用都转发给实际的对象, 并从实际对象中获取结果. 因此我们在实例化 LoadImageProxy 时, 提供不同的实际对象时, 就可以实现从不同的介质中读取图片的功能了.
3. 动态代理





## 二、行为型
#### 策略模式（strategy）
* 策略模式定义了一系列算法，并将每个算法封装起来，使他们可以相互替换，且算法的变化不会影响到使用算法的客户。需要设计一个接口，为一系列实现类提供统一的方法，多个实现类实现该接口。
