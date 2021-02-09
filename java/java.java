/*3.变量的运算：
   ①自动类型转换：容量小的数据类型自动转换为容量大的数据类型。
    short s = 12;
     int i = s + 2;
    注意：byte  short char之间做运算，结果为int型！
   ②强制类型转换：是①的逆过程。使用“（）”实现强转。
*/
short s = 10;
s = s + 5;//报编译的异常
s = (short)(s + 5);
s += 5;//s = s + 5，但是结果不会改变s的数据类型。

//2.空指针的异常：NullPointerException
		//第一种：
//		boolean[] b = new boolean[3];
//		b = null;
//		System.out.println(b[0]);

		//第二种：
//		String[] str = new String[4];
//		//str[3] = new String("AA");//str[3] = "AA";
//		System.out.println(str[3].toString());

		//第三种：
		int[][] j = new int[3][];
		j[2][0] = 12;
数组的反转：
// 数组元素的反转
// for(int i = 0;i < arr.length/2;i++){
// int temp = arr[i];
// arr[i] = arr[arr.length-1 - i];
// arr[arr.length - 1 - i] = temp;
// }
for (int x = 0, y = arr.length - 1; x < y; x++, y--) {
	int temp = arr[x];
	arr[x] = arr[y];
	arr[y] = temp;
}
// 使用冒泡排序使数组元素从小到大排列
//		for (int i = 0; i < arr.length - 1; i++) {
//			for (int j = 0; j < arr.length - 1 - i; j++) {
//				if (arr[j] > arr[j + 1]) {
//					int temp = arr[j];
//					arr[j] = arr[j + 1];
//					arr[j + 1] = temp;
//				}
//			}
//		}

//使用直接选择排序使数组元素从小到大排列
//		for(int i = 0; i < arr.length - 1; i++){
//			int t = i;//默认i处是最小的
//			for(int j = i;j < arr.length;j++){
//				//一旦在i后发现存在比其小的元素，就记录那个元素的下角标
//				if(arr[t] > arr[j]){
//					t = j;
//				}
//			}
//			if(t != i){
//				int temp = arr[t];
//				arr[t] = arr[i];
//				arr[i] = temp;
//			}
//		}
还可以调用：Arrays工具类：Arrays.sort(arr);

public String toString() {
        return getClass().getName() + "@" + Integer.toHexString(hashCode());

    }
@Override
	public String toString() {
		return "Season [seasonName=" + seasonName + ", seasonDesc="
				+ seasonDesc + "]";
	}
Set<Map.Entry<String,Integer>> set = map.entrySet();
	for(Map.Entry<String,Integer> o : set){
		System.out.println(o.getKey() + "--->" + o.getValue());
	}

1.泛型在集合中的使用（掌握）
2.自定义泛型类、泛型接口、泛型方法（理解 --->使用）
3.泛型与继承的关系
4.通配符

【注意点】
1.对象实例化时不指定泛型，默认为：Object。
2.泛型不同的引用不能相互赋值。
3.加入集合中的对象类型必须与指定的泛型类型一致。
4.静态方法中不能使用类的泛型。
5.如果泛型类是一个接口或抽象类，则不可创建泛型
  类的对象。
6.不能在catch中使用泛型
7.从泛型类派生子类，泛型类型需具体化


4.泛型与继承的关系
A类是B类的子类，G是带泛型声明的类或接口。那么G<A>不是G<B>的子类！

5.通配符:?
A类是B类的子类，G是带泛型声明的类或接口。则G<?> 是G<A>、G<B>的父类！
①以List<?>为例，能读取其中的数据。因为不管存储的是什么类型的元素，其一定是Object类的或其子类的。
①以List<?>为例，不可以向其中写入数据。因为没有指明可以存放到其中的元素的类型！唯一例外的是：null

6*.  List<？ extends A> :可以将List<A>的对象或List<B>的对象赋给List<? extends A>。其中B 是A的子类
       ? super A:可以将List<A>的对象或List<B>的对象赋给List<? extends A>。其中B 是A的父类


       一、枚举类
1.如何自定义枚举类。 枚举类：类的对象是有限个的，确定的。
   1.1 私有化类的构造器，保证不能在类的外部创建其对象
   1.2 在类的内部创建枚举类的实例。声明为：public static final
   1.3 若类有属性，那么属性声明为：private final 。此属性在构造器中赋值。
2.使用enum关键字定义枚举类
	>2.1其中常用的方法：values()  valueOf(String name);
	>2.2枚举类如何实现接口  ：①让类实现此接口，类的对象共享同一套接口的抽象方法的实现。
						 ①让类的每一个对象都去实现接口的抽象方法，进而通过类的对象调用被重写的抽象方法时，执行的效果不同
public class TestSeason1 {
	public static void main(String[] args) {
		Season1 spring = Season1.SPRING;
		System.out.println(spring);
		spring.show();
		System.out.println(spring.getSeasonName());

		System.out.println();
		//1.values()
		Season1[] seasons = Season1.values();
		for(int i = 0;i < seasons.length;i++){
			System.out.println(seasons[i]);
		}
		//2.valueOf(String name):要求传入的形参name是枚举类对象的名字。
		//否则，报java.lang.IllegalArgumentException异常
		String str = "WINTER";
		Season1 sea = Season1.valueOf(str);
		System.out.println(sea);
		System.out.println();

		Thread.State[] states = Thread.State.values();
		for(int i = 0;i < states.length;i++){
			System.out.println(states[i]);
		}
		sea.show();

	}
}
interface Info{
	void show();
}
//枚举类
enum Season1 implements Info{
	SPRING("spring", "春暖花开"){
		public void show(){
			System.out.println("春天在哪里？");
		}
	},
	SUMMER("summer", "夏日炎炎"){
		public void show(){
			System.out.println("生如夏花");
		}
	},
	AUTUMN("autumn", "秋高气爽"){
		public void show(){
			System.out.println("秋天是用来分手的季节");
		}
	},
	WINTER("winter", "白雪皑皑"){
		public void show(){
			System.out.println("冬天里的一把火");
		}
	};

	private final String seasonName;
	private final String seasonDesc;

	private Season1(String seasonName,String seasonDesc){
		this.seasonName = seasonName;
		this.seasonDesc = seasonDesc;
	}
	public String getSeasonName() {
		return seasonName;
	}
	public String getSeasonDesc() {
		return seasonDesc;
	}

	@Override
	public String toString() {
		return "Season [seasonName=" + seasonName + ", seasonDesc="
				+ seasonDesc + "]";
	}
//	public void show(){
//		System.out.println("这是一个季节");
//	}
}

/*
	Web监听器
	用于监听ServletContext，httpSession，ServletRequest等域对象的创建和销毁事件
	监听域对象属性发生修改的事件
	可以在事件发生前，后做一些操作
	优先级  监听器》过滤器》Servlet 其中监听器和过滤器都是按照注册顺序作为启动顺序
	按监听器对象分类    监听应用程序环境对象ServletContext的事件监听器，用户会话对象HttpSession,请求消息对象ServletRequest
	按监听事件分类    监听域对象自身的创建和销毁，域对象中属性的增加和删除，监听HttpSession域中某对象状态
	一对多  参考js事件模型
	 dom 域对象；
	 事件 创建和销毁
	 事件处理  各实现接口listener的方法
	 事件对象 方法参数
	 作用：定时器   全局属性对象
	 HttpSessionListener  统计在线人数  访问日志记录 sessionConfig
	 ServletRequestListener  读取参数  记录访问历史  先Requestinit  sessioncreate  Requestdestroy

	 以及域对象中各属性的增加，删除和替换注意要和域对象的生命周期结合使用

	 session钝化机制：把服务器中不经常使用的session对象暂时序列化到系统文件或数据库中，当被使用时反序列化到内存中，整个过程有服务器自动完成
	 钝化后的文件保存在：安装路径apache-tomcat-8.0.24\work\Catalina\localhost\项目名\SESSION.ser 当重新启动时，加载并删除
	 session钝化机制由sessionManager管理
	 standardManager和persistentManager默认情况下tomcat提供两个钝化驱动类FileStor  和JDBCStore

	 该监听器不需要在web.xml中注册，且是普通的javabean去继承HttpSessionBindingListener
	 httpsessionactivationListener 以及实现  serialation接口
*/
/*
-Xms2048m -Xmx4096m -XX:MaxNewSize=512m -XX:MaxPermSize=512m

URIEncoding="UTF-8"
 */
