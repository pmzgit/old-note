### 判断用户将页面滚动到底部 [参考](http://www.cnblogs.com/zxjwlh/p/6284330.html)
* 滚动底部的条件是: 滚动的高度 + windows 窗口高度 >= 滚动条总高度
```js
//原生JavaScript：

 $(window).scroll(function(event){  
    var wScrollY = window.scrollY; // 当前滚动条位置    
    var wInnerH  = window.innerHeight; // 设备窗口的高度（不会变）    
    var bScrollH = document.body.scrollHeight; // 滚动条总高度        
    if (wScrollY + wInnerH >= bScrollH) {            
        console.log("到底了.");
    }    
});
//JQuery ：

$(window).scroll(function () {
    if ($(document).scrollTop() + $(window).height() >= $(document).height()) {
        console.log("到底了.");
    }
});
```
* js 滚动页面到底部  
`window.scrollTo(0,document.body.scrollHeight - window.innerHeight)`
### 事件是可以被javascript检测到的行为
* 在事件值里直接写js代码  
onchange   文本内容改变事件  
onselect   文本内容选中事件  
onblur   光标移开事件  
onUnload   关闭网页事件  

* dom.property  dom API  
dom.style.property  css API  

* dom.add/remove EventListener();  推荐使用这种方式  ，且各事件不会相互覆盖

* 事件流  页面中接收事件的顺序  事件冒泡和捕获  常用冒泡

### 事件处理  (三种)
1. html  耦合
2. dom0 级
dom事件处理属性  onclick属性  
缺点 覆盖  
移除是赋值null  

3. dom2 级
 addEventListener（‘事件名注意去掉on’，‘事件处理函数’，‘true：事件捕获，false：冒泡’）  
 attachEvent/detachEvent("onclick",function)  ie8以下  


### 事件对象  (触发dom事件时产生一个对象)

* 属性方法  
  e.type  e.target  e.stopPropagation  e.preventDefault();


### dom
NodeList数组  每一个node都有很多属性  事件的this传入触发该事件的元素dom
ByName     dom数组
ByTagName  dom数组

getAttribute/set   dataset.attr    属性值大多为String  存取数据

dom.nodeType  数字  nodeName  大写String

表单dom 都有type value 属性

parent.insertBefore（dom, refChild）;

document.body.offsetHeight||document.documentElement.scrollHeight;   是否包括滚动条


### 模块化规范

* AMD --RequireJS     异步加载，依赖前置，提前执行     
* CMD --SeaJS      同步加载，依赖就近，延迟执行  

### Prototype模式的验证方法
为了配合prototype属性，Javascript定义了一些辅助方法，帮助我们使用它。  
* isPrototypeOf()  
这个方法用来判断，某个proptotype对象和某个实例之间的关系。  
　　alert(Cat.prototype.isPrototypeOf(cat1)); //true  
　　alert(Cat.prototype.isPrototypeOf(cat2)); //true  
* hasOwnProperty()  
每个实例对象都有一个hasOwnProperty()方法，用来判断某一个属性到底是本地属性，还是继承自prototype对象的属性。  
　　alert(cat1.hasOwnProperty("name")); // true  
　　alert(cat1.hasOwnProperty("type")); // false  
* in运算符
in运算符可以用来判断，某个实例是否含有某个属性，不管是不是本地属性。  
　　alert("name" in cat1); // true  
　　alert("type" in cat1); // true  
in运算符还可以用来遍历某个对象的所有属性。  
　　for(var prop in cat1) { alert("cat1["+prop+"]="+cat1[prop]); }


### js snipe
```js
var i = 100;
	~function(){
		console.log(i);
	}();
// 作用相当于（） 把后面变成表达式
```


* indexOf  

```javascript
//表示从该位置开始向后匹配；对于lastIndexOf，表示从该位置起向前匹配。

"hello world".indexOf("o", 6)
// 7

"hello world".lastIndexOf("o", 6)
// 4
```


### js中`!!`运算符
> `!! 表达式`类似于三元运算符，**目的是把其他类型的变量转化成boolean型	**当表达式的值是非空字符串、非零数字、返回true；当值是空字符串、数字0，null,false,undefined,NaN返回false
```
!! ""
false
!! "s"
true
!! "0"
true
!! 0
false
!! null
false
!! true
true
!! false
false
```

### 浏览器canvas检测
```javascript
//判断浏览区是否支持canvas
    function isSupportCanvas(){
        var elem = document.createElement('canvas');
        return !!(elem.getContext && elem.getContext('2d'));
    }
```
### js中`||`和`&&` 运算符
> 遵循短路原则，常用于判断逻辑，默认值赋值等
>
`2>3 && 5`返回值：false
>
eg:
成长速度为5显示1个箭头；
成长速度为10显示2个箭头；
成长速度为12显示3个箭头；
成长速度为15显示4个箭头；
其他都显示都显示0各箭头。
```
var add_level = (add_step==5 && 1) || (add_step==10 && 2) || (add_step==12 && 3) || (add_step==15 && 4) || 0;
//or
var add_level={'5':1,'10':2,'12':3,'15':4}[add_step] || 0;
```
eg:
成长速度为>12显示4个箭头；
成长速度为>10显示3个箭头；
成长速度为>5显示2个箭头；
成长速度为>0显示1个箭头；
成长速度为<=0显示0个箭头。
```
var add_level = (add_step>12 && 4) || (add_step>10 && 3) || (add_step>5 && 2) || (add_step>0 && 1) || 0;
```
