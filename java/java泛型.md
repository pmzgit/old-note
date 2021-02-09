## 别看我写的了，看大神的吧[贾博岩：Java泛型的学习和使用](http://www.jianshu.com/p/e4e4401c3d46)
本文只是自己的整理，后来看到了大神的博客，觉得自己整理的不好，强烈推荐上面的外链

## Java-Type体系
* 包含：原始类型(Class)、参数化类型(ParameterizedType)、数组类型(GenericArrayType)、类型变量(TypeVariable)、WildcardType，基本类型(Class);
* 这块内容作用，利用反射得出的元素，都实现了type相关的方法，可以得出元素的泛型信息

## 基础

* 泛型，即“参数化类型”。  
一提到参数，最熟悉的就是定义方法时有形参，然后调用此方法时传递实参。那么参数化类型怎么理解呢？顾名思义，就是将类型由原来的具体的类型参数化，类似于方法中的变量参数，此时类型也定义成参数形式（可以称之为类型形参），然后在使用/调用时传入具体的类型（类型实参）。

```java
class Box<T> {

    private T data;

    public Box() {

    }

    public Box(T data) {
        setData(data);
    }

    public T getData() {
        return data;
    }

    public void setData(T data) {
        this.data = data;
    }

}
```
* 类型擦除   
究其原因，在于Java中的泛型这一概念提出的目的，导致其只是作用于代码编译阶段，在编译过程中，对于正确检验泛型结果后，会将泛型的相关信息擦出，也就是说，成功编译过后的class文件中是不包含任何泛型信息的。泛型信息不会进入到运行时阶段。所以：泛型类型在逻辑上看以看成是多个不同的类型，实际上都是相同的基本类型。
* 由于泛型擦除机制的存在，在运行期间无法获取关于泛型参数类型的任何信息，自然也就无法对类型信息进行操作；例如：instanceof 、创建对象等
```java
public class GenericTest {

    public static void main(String[] args) {

        Box<String> name = new Box<String>("corn");
        Box<Integer> age = new Box<Integer>(712);

        System.out.println("name class:" + name.getClass());      // com.qqyumidi.Box
        System.out.println("age class:" + age.getClass());        // com.qqyumidi.Box
        System.out.println(name.getClass() == age.getClass());    // true

    }

}
}
```
* 类型通配符  
类型通配符一般是使用 ? 代替具体的类型实参。注意了，此处是类型实参，而不是类型形参！且Box<?>在逻辑上是Box<Integer>、Box<Number>...等所有Box<具体类型实参>的父类。由此，我们依然可以定义泛型方法，来完成此类需求。  

```java
public class GenericTest {

    public static void main(String[] args) {

        Box<String> name = new Box<String>("corn");
        Box<Integer> age = new Box<Integer>(712);
        Box<Number> number = new Box<Number>(314);

        getData(name);
        getData(age);
        getData(number);
    }

    public static void getData(Box<?> data) {
        System.out.println("data :" + data.getData());
    }
}
```
* 类型通配符上限、下限  
类型通配符上限通过形如Box<? extends Number>形式定义，相对应的，类型通配符下限为Box<? super Number>形式，其含义与类型通配符上限正好相反

```java
public class GenericTest {

    public static void main(String[] args) {

        Box<String> name = new Box<String>("corn");
        Box<Integer> age = new Box<Integer>(712);
        Box<Number> number = new Box<Number>(314);

        getData(name);
        getData(age);
        getData(number);

        //getUpperNumberData(name); // 1
        getUpperNumberData(age);    // 2
        getUpperNumberData(number); // 3
    }

    public static void getData(Box<?> data) {
        System.out.println("data :" + data.getData());
    }

    public static void getUpperNumberData(Box<? extends Number> data){
        System.out.println("data :" + data.getData());
    }

}
```
【注意点】
1. 对象实例化时不指定泛型，默认为：Object。  
2. 泛型不同的引用不能相互赋值（需要用通配符才能完成此类功能）。  
3. 加入集合中的对象类型必须与指定的泛型类型一致。  
4. 泛型类中泛型成员不能应用在静态域中（注意泛型方法与成员泛型方法的区别）。  
5. 如果泛型类是一个接口或抽象类，则不可创建泛型类的对象。  
6. 不能在catch中使用泛型  
7. 从泛型类派生子类，子类中继承的父类，泛型类型需具体化（两种具体化方式）  
8. 并且还要注意的一点是，Java中没有所谓的泛型数组一说。
9. 泛型与继承的关系
A类是B类的子类，G是带泛型声明的类或接口。那么`G<A>`不是`G<B>`的子类！

* 通配符?  
    A类是B类的子类，G是带泛型声明的类或接口。则G<?> 是`G<A>`、`G<B>`的父类！  
①以List<?>为例，能读取其中的数据。因为不管存储的是什么类型的元素，其一定是Object类的或其子类的。  
①以List<?>为例，不可以向其中写入数据。因为没有指明可以存放到其中的元素的类型！唯一例外的是：null

* List<? extends A>,可以将`List<A>`的对象或`List<B>`的对象赋给`List<? extends A>`。其中B 是A的子类
* List<? super A>, 可以将`List<A>`的对象或`List<B>`的对象赋给`List<? super A>`。其中B 是A的父类
```java
java 中数组是协变的，所以子类型的数组可以赋值给父类型的数组，编译期无法对coder做出限制，发现问题；尽管 Apple 是 Fruit 的子类型，但是 ArrayList<Apple> 不是 ArrayList<Fruit> 的子类型，泛型不支持协变；但是通配符是折中方案，既能限制，又能赋值；
通配符的使用可以对泛型参数做出某些限制，使代码更安全，对于上边界和下边界限定的通配符总结如下：

使用 List<? extends C> list 这种形式，表示 list 可以引用一个 ArrayList ( 或者其它 List 的 子类 ) 的对象，这个对象包含的元素类型是 C 的子类型 ( 包含 C 本身）的一种。
使用 List<? super C> list 这种形式，表示 list 可以引用一个 ArrayList ( 或者其它 List 的 子类 ) 的对象，这个对象包含的元素就类型是 C 的超类型 ( 包含 C 本身 ) 的一种。

public class Collections { 
  public static <T> void copy(List<? super T> dest, List<? extends T> src) 
  {
      for (int i=0; i<src.size(); i++) 
        dest.set(i,src.get(i)); 
  } 
}
List<? super T> dest中，我们不知道实际类型是什么，但是这个类型肯定是 T 的父类型。因此，我们可以知道向这个 List 添加一个 T 或者其子类型的对象是安全的，这些对象都可以向上转型为 T;

扩展说一下 PECS(Producer Extends Consumer Super)原则：第一、频繁往外读取内
容的，适合用<? extends T>。第二、经常往里插入的，适合用<? super T>
```

## 进阶
* [java 泛型总结 by polly](https://juejin.im/entry/58f044ccb123db023928d626)
* [参考（个人认为写的非常好）](https://segmentfault.com/a/1190000005179147)

### 其中一些观点
* 泛型类：泛型擦除机制 导致 子类无法重载父类
* Pair<?> 就是 Pair<? extends Object>
* P<?> 不等于 P<Object>  P<Object>是P<?>的子类。
* 类型通配符小结

    1. 限定通配符总是包括自己；
    2. 子类型通配符：set方法受限，只可读，不可写；
    3. 超类型通配符：get方法受限，不可读(Object除外)，只可写；
    4. 无限定通配符，只可读不可写；
    5. 如果你既想存，又想取，那就别用通配符；
    6. 不可同时声明子类型和超类型限定符，及extends和super只能出现一个。
    通配符的受限只针对setter(T)和T getter(),如果定义了一个setter(Integer)这种具体类型参数的方法，无限制。 
    * 类型变量的上限可以为多个，必须使用&符号相连接，例如 List<T extends Number & Serializable>；其中，& 后必须为接口； 
    * GenericDeclaration；含义为：声明类型变量的所有实体的公共接口；也就是说该接口定义了哪些地方可以定义类型变量（泛型）；通过查看源码发现，GenericDeclaration下有三个子类，分别为Class、Method、Constructor；也就是说，我们定义泛型只能在一个类中这3个地方自定义泛型；
    * 可以看出，当我们没有声明泛型的时候，我们获得的generictype就是一个Class类型，是Type中的一种；




* 通配符捕获， 只允许捕获单个、确定的类型，如：ArrayList<Pair<?>> 是无法使用 ArrayList<Pair<T>> 捕获的。

* 继承泛型类时，必须对父类中的类型参数进行初始化。或者说父类中的泛型参数必须在子类中可以确定具体类型。或者在继承时，父类不使用泛型