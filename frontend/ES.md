# [致敬阮一峰大神](https://wangdoc.com/javascript)

# ES5
### 构造函数的继承
```js
#### 第一步是在子类的构造函数中，调用父类的构造函数。让子类实例具有父类实例的属性

function Sub(value) {
  Super.call(this);
  this.prop = value;
}
#### 第二步，是让子类的原型指向父类的原型，这样子类就可以继承父类原型。
Sub.prototype = Object.create(Super.prototype);
Sub.prototype.constructor = Sub;
Sub.prototype.method = '...';
Sub.prototype是子类的原型，要将它赋值为Object.create(Super.prototype)，而不是直接等于Super.prototype。否则后面两行对Sub.prototype的操作，会连父类的原型Super.prototype一起修改掉。
```
* 原型对象的所有属性和方法，都能被实例对象共享。也就是说，如果属性和方法定义在原型上，那么所有实例对象就能共享，不仅节省了内存，还体现了实例对象之间的联系。
JavaScript 规定，每个函数都有一个prototype属性，指向一个对象。  
也就是说，当实例对象本身没有某个属性或方法的时候，它会到原型对象去寻找该属性或方法。这就是原型对象的特殊之处。  
如果实例对象自身就有某个属性或方法，它就不会再去原型对象寻找这个属性或方法。
function f() {}  
typeof f.prototype // "object"  
* JavaScript 规定，所有对象都有自己的原型对象（prototype）。一方面，任何一个对象，都可以充当其他对象的原型；另一方面，由于原型对象也是对象，所以它也有自己的原型。因此，就会形成一个“原型链”（prototype chain）：对象到原型，再到原型的原型……  
如果一层层地上溯，所有对象的原型最终都可以上溯到Object.prototype，即Object构造函数的prototype属性。也就是说，所有对象都继承了 Object.prototype的属性。这就是所有对象都有valueOf和toString方法的原因，因为这是从Object.prototype继承的。    
那么，Object.prototype对象有没有它的原型呢？回答是Object.prototype的原型是null。null没有任何属性和方法，也没有自己的原型。因此，原型链的尽头就是null。  
```javascript
生成实例对象的常用方法是，使用new命令让构造函数返回一个实例。但是很多时候，只能拿到一个实例对象，它可能根本不是由构建函数生成的，那么能不能从一个实例对象，生成另一个实例对象呢？

JavaScript 提供了Object.create方法，用来满足这种需求。该方法接受一个对象作为参数，然后以它为原型，返回一个实例对象。该实例完全继承原型对象的属性。
Object.create方法生成的新对象，动态继承了原型。在原型上添加或修改任何方法，会立刻反映在新对象之上。
var obj1 = { p: 1 };
var obj2 = Object.create(obj1);

obj1.p = 2;
obj2.p // 2
除了对象的原型，Object.create方法还可以接受第二个参数。该参数是一个属性描述对象，它所描述的对象属性，会添加到实例对象，作为该对象自身的属性。
//Object.create()
function _create(super_obj){
    function F(){};
    F.prototype = super_obj;
    return new F();
}
function inheritPrototype(Super,Sub){
    var prototype = _create(Super.prototype);
    prototype.constructor = Sub;
    Sub.prototype = prototype;
}

function Super(name){
    this.name=name;
    this.colors = ["red","blue"];
};
Super.prototype.showName= function(){
    console.log(this.name);
}
function Sub(name,age){
    Super.call(this,name);
    this.age = age;
}
inheritPrototype(Super,Sub);
Sub.prototype.showAge = function(){
    console.log(this.age);
}
var obj1= new Sub("john",21);
var obj2= new Sub("peter",33);

```

### [object](https://wangdoc.com/javascript/stdlib/object.html#object-%E6%9E%84%E9%80%A0%E5%87%BD%E6%95%B0)
* Object.assign(target, source1, source2);  
将源对象（ source ）的所有可枚举属性,不包括继承，复制到目标对象（ target ）  
如果目标对象与源对象有同名属性，或多个源对象有同名属性，则后面的属性会覆盖前面的属性。
如果只有一个参数，Object.assign会直接返回该参数，如果该参数不是对象，则会先转成对象，然后返回。
由于undefined和null无法转成对象，所以如果它们作为参数，就会报错。  
非对象参数出现在源对象的位置（即非首参数），那么处理规则有所不同。首先，这些参数都会转成对象，如果无法转成对象，就会跳过。这意味着，如果undefined和null不在首参数，就不会报错。 
其他类型的值（即数值、字符串和布尔值）不在首参数，也不会报错。但是，除了字符串会以数组形式，拷贝入目标对象，其他值都不会产生效果。 
Object.assign可以用来处理数组，但是会把数组视为对象。   
Object.assign方法实行的是浅拷贝，而不是深拷贝。也就是说，如果源对象某个属性的值是对象，那么目标对象拷贝得到的是这个对象的引用。  
对于嵌套的对象，一旦遇到同名属性，Object.assign的处理方法是替换，而不是添加。      
const merge =(...sources) => Object.assign({}, ...sources); 
* [类型转换](https://wangdoc.com/javascript/features/conversion.html)
强制转换主要指使用Number()、String()和Boolean()三个函数，手动将各种类型的值，分别转换成数字、字符串或者布尔值    
自动转换，它是以强制转换为基础的  
自动转换的规则是这样的：预期什么类型的值，就调用该类型的转换函数。比如，某个位置预期为字符串，就调用String函数进行转换。如果该位置即可以是字符串，也可能是数值，那么默认转为数值。  
由于自动转换具有不确定性，而且不易除错，建议在预期为布尔值、数值、字符串的地方，全部使用Boolean、Number和String函数进行显式转换。  
 null转为数值时为0，而undefined转为数值时为NaN。

### instanceof的原理是检查右边构造函数的prototype属性，是否在左边对象的原型链上。
* 注意，instanceof运算符只能用于对象，不适用原始类型的值。  
var s = 'hello';
s instanceof String // false

* 此外，对于undefined和null，instanceOf运算符总是返回false。

undefined instanceof Object // false
null instanceof Object // false

### 如何启用Source map
只要在转换后的代码尾部，加上一行就可以了。  
`//@ sourceMappingURL=/path/to/file.js.map`　  
map文件可以放在网络上，也可以放在本地文件系统。  
[参考 by ruanyf](http://www.ruanyifeng.com/blog/2013/01/javascript_source_map.html)
### 最新的浏览器提供了自动生成和解析base64的方法
```js
btoa('a:a')
// => "YTph"
atob('YTph')
// => "a:a"
```
### || 和 && 表达式
* 如果||左侧表达式的值为真值，则返回左侧表达式的值；否则返回右侧表达式的值。
* 如果&&左侧表达式的值为真值，则返回右侧表达式的值；否则返回左侧表达式的值。
### 逗号表达式 [转载](http://www.cnblogs.com/hellolong/p/4210297.html)
* 逗号表达式的一般形式是：表达式1，表达式2，表达式3……表达式n 
* 逗号表达式的求解过程是：先计算表达式1的值，再计算表达式2的值，……一直计算到表达式n的值。最后整个逗号表达式的值是表达式n的值。   
看下面几个例子：
```js
x=8*2,x*4 /*整个表达式的值为64，x的值为16*/ 
(x=8*2,x*4),x*2 /*整个表达式的值为128，x的值为16*/ 
x=(z=5,5*2) /*整个表达式为赋值表达式，它的值为10，z的值为5*/ 
x=z=5,5*2 /*整个表达式为逗号表达式，它的值为10，x和z的值都为5*/ 
```
### 判断一个变量是否为对象

```javascript
function isObject(o){
  return o = Object(o);
}
isObject([]) // true
isObject(true) // false
```

### call apply bind
```js
apply( )
apply 方法传入两个参数：一个是作为函数上下文的对象，另外一个是作为函数参数所组成的数组。

var obj = {
    name : 'linxin'
}

function func(firstName, lastName){
    console.log(firstName + ' ' + this.name + ' ' + lastName);
}

func.apply(obj, ['A', 'B']);    // A linxin B
可以看到，obj 是作为函数上下文的对象，函数 func 中 this 指向了 obj 这个对象。参数 A 和 B 是放在数组中传入 func 函数，分别对应 func 参数的列表元素。

call( )
call 方法第一个参数也是作为函数上下文的对象，但是后面传入的是一个参数列表，而不是单个数组。

var obj = {
    name: 'linxin'
}

function func(firstName, lastName) {
    console.log(firstName + ' ' + this.name + ' ' + lastName);
}

func.call(obj, 'C', 'D');       // C linxin D
对比 apply 我们可以看到区别，C 和 D 是作为单独的参数传给 func 函数，而不是放到数组中。

对于什么时候该用什么方法，其实不用纠结。如果你的参数本来就存在一个数组中，那自然就用 apply，如果参数比较散乱相互之间没什么关联，就用 call。

apply 和 call 的用法
1.改变 this 指向
var obj = {
    name: 'linxin'
}

function func() {
    console.log(this.name);
}

func.call(obj);       // linxin
我们知道，call 方法的第一个参数是作为函数上下文的对象，这里把 obj 作为参数传给了 func，此时函数里的 this 便指向了 obj 对象。此处 func 函数里其实相当于

function func() {
    console.log(obj.name);
}
2.借用别的对象的方法
先看例子

var Person1  = function () {
    this.name = 'linxin';
}
var Person2 = function () {
    this.getname = function () {
        console.log(this.name);
    }
    Person1.call(this);
}
var person = new Person2();
person.getname();       // linxin
从上面我们看到，Person2 实例化出来的对象 person 通过 getname 方法拿到了 Person1 中的 name。因为在 Person2 中，Person1.call(this) 的作用就是使用 Person1 对象代替 this 对象，那么 Person2 就有了 Person1 中的所有属性和方法了，相当于 Person2 继承了 Person1 的属性和方法。

3.调用函数
apply、call 方法都会使函数立即执行，因此它们也可以用来调用函数。

function func() {
    console.log('linxin');
}
func.call();            // linxin
call 和 bind 的区别
在 EcmaScript5 中扩展了叫 bind 的方法，在低版本的 IE 中不兼容。它和 call 很相似，接受的参数有两部分，第一个参数是是作为函数上下文的对象，第二部分参数是个列表，可以接受多个参数。
它们之间的区别有以下两点。

1.bind 发返回值是函数
var obj = {
    name: 'linxin'
}

function func() {
    console.log(this.name);
}

var func1 = func.bind(obj);
func1();                        // linxin
bind 方法不会立即执行，而是返回一个改变了上下文 this 后的函数。而原函数 func 中的 this 并没有被改变，依旧指向全局对象 window。

2.参数的使用
function func(a, b, c) {
    console.log(a, b, c);
}
var func1 = func.bind(null,'linxin');

func('A', 'B', 'C');            // A B C
func1('A', 'B', 'C');           // linxin A B
func1('B', 'C');                // linxin B C
func.call(null, 'linxin');      // linxin undefined undefined

call 是把第二个及以后的参数作为 func 方法的实参传进去，而 func1 方法的实参实则是在 bind 中参数的基础上再往后排。

在低版本浏览器没有 bind 方法，我们也可以自己实现一个。

if (!Function.prototype.bind) {
        Function.prototype.bind = function () {
            var self = this,                        // 保存原函数
                context = [].shift.call(arguments), // 保存需要绑定的this上下文
                args = [].slice.call(arguments);    // 剩余的参数转为数组
            return function () {                    // 返回一个新函数
                self.apply(context,[].concat.call(args, [].slice.call(arguments)));
            }
        }
    }
```


### 枚举对象属性、计算对象属性个数

```javascript
// 枚举
var a = ["hello","world"];
Object.keys(a);
// ["0", "1"] 不包含 不可枚举的属性
Object.getOwnPropertyNames(a);
// ["0", "1", "length"]
// 计算属性个数
Object.keys(a).length // 2
Object.getOwnPropertyNames(a).length // 3
```
### [].slice(start, end); slice方法用于提取目标数组的一部分，返回一个新数组，原数组不变。
```js
它的第一个参数为起始位置（从0开始），第二个参数为终止位置（但该位置的元素本身不包括在内）。如果省略第二个参数，则一直返回到原数组的最后一个成员。

var a = ['a', 'b', 'c'];

a.slice(0) // ["a", "b", "c"]
a.slice(1) // ["b", "c"]
a.slice(1, 2) // ["b"]
a.slice(2, 6) // ["c"]
a.slice() // ["a", "b", "c"]
上面代码中，最后一个例子slice没有参数，实际上等于返回一个原数组的拷贝。

如果slice方法的参数是负数，则表示倒数计算的位置。

var a = ['a', 'b', 'c'];
a.slice(-2) // ["b", "c"]
a.slice(-2, -1) // ["b"]
上面代码中，-2表示倒数计算的第二个位置，-1表示倒数计算的第一个位置。

如果第一个参数大于等于数组长度，或者第二个参数小于第一个参数，则返回空数组。

var a = ['a', 'b', 'c'];
a.slice(4) // []
a.slice(2, 1) // []
slice方法的一个重要应用，是将类似数组的对象转为真正的数组。

Array.prototype.slice.call({ 0: 'a', 1: 'b', length: 2 })
// ['a', 'b']

Array.prototype.slice.call(document.querySelectorAll("div"));
Array.prototype.slice.call(arguments);
上面代码的参数都不是数组，但是通过call方法，在它们上面调用slice方法，就可以把它们转为真正的数组。
```
### [].splice(startIndex,countToRemove,newEleToInsert);

```javascript
splice的第一个参数是删除的起始位置，第二个参数是被删除的元素个数。如果后面还有更多的参数，则表示这些就是要被插入数组的新元素。

var a = ["a","b","c","d","e","f"];

a.splice(4,2)
// ["e", "f"]

a
// ["a", "b", "c", "d"]
上面代码从原数组位置4开始，删除了两个数组成员。

var a = ["a","b","c","d","e","f"];

a.splice(4,2,1,2)
// ["e", "f"]

a
// ["a", "b", "c", "d", 1, 2]
上面代码除了删除成员，还插入了两个新成员。

如果只是单纯地插入元素，splice方法的第二个参数可以设为0。

var a = [1,1,1];

a.splice(1,0,2)
// []

a
// [1, 2, 1, 1]
如果只提供第一个参数，则实际上等同于将原数组在指定位置拆分成两个数组。

var a = [1,2,3,4];

a.splice(2)
// [3, 4]

a
// [1, 2]
```

### 判断某对象是不是数组

```javascript
var a = [];
typeof a; // object
Array.isArray(a); // true
```

### [].toString()方法返回数组的字符串形式。

```javascript
var a = [1, 2, 3];
a.toString() // "1,2,3"

var a = [1, 2, 3, [4, 5, 6]];
a.toString() // "1,2,3,4,5,6"
```

### 字符串和数组 转换

```javascript
split方法还可以接受第二个参数，限定返回数组的最大成员数。
"a|b|c".split("|", 2) // ["a", "b"]
"a|b|c".split("|", 3) // ["a", "b", "c"]
"a|b|c".split("|", 4) // ["a", "b", "c"]

如果分割规则为空字符串，则返回数组的成员是原字符串的每一个字符。

"a|b|c".split("")
// ["a", "|", "b", "|", "c"]

如果满足分割规则的两个部分紧邻着（即中间没有其他字符），则返回数组之中会有一个空字符串。

"a||c".split("|")
// ["a", "", "c"]

["a","b","c"].toString()
"a,b,c"

join方法以参数作为分隔符，将所有数组成员组成一个字符串返回。如果不提供参数，默认用逗号分隔。

var a = [1,2,3,4];

a.join() // "1,2,3,4"
a.join('') // '1234'
a.join("|") // "1|2|3|4"

如果数组成员是undefined或null或空位，会被转成空字符串。

[undefined, null].join('#')
// '#'

['a',, 'b'].join('-')
// 'a--b'
通过函数的call方法，join方法（即Array.prototype.join）也可以用于字符串。

Array.prototype.join.call('hello', '-')
// "h-e-l-l-o"
```

### [].shift() 和 [].unshift()

```javascript
shift()
shift方法用于删除数组的第一个元素，并返回该元素。注意，该方法会改变原数组。

var a = ['a', 'b', 'c'];

a.shift() // 'a'
a // ['b', 'c']
shift方法可以遍历并清空一个数组。

var list = [1, 2, 3, 4, 5, 6];
var item;

while (item = list.shift()) {
  console.log(item);
}

list // []
push和shift结合使用，就构成了“先进先出”的队列结构（queue）。

unshift()
unshift方法用于在数组的第一个位置添加元素，并返回添加新元素后的数组长度。注意，该方法会改变原数组。

var a = ['a', 'b', 'c'];

a.unshift('x'); // 4
a // ['x', 'a', 'b', 'c']
unshift方法可以在数组头部添加多个元素。

var arr = [ 'c', 'd' ];
arr.unshift('a', 'b') // 4
arr // [ 'a', 'b', 'c', 'd' ]
```

### charAt
```js
charAt方法返回一个字符串的给定位置的字符，位置从0开始编号。

var s = new String("abc");

s.charAt(1) // "b"
s.charAt(s.length-1) // "c"
这个方法完全可以用数组下标替代。

"abc"[1] // "b"
```
### 自调用匿名函数(两种写法)
```javascript
(function() {
    console.info( this );
    console.info( arguments );
}( window ) );
(function() {
    console.info( this );
    console.info( arguments );
})( window );
```

# ES6

### let,const,TDZ
* let，const只在声明所在的块级作用域内有效
* 暂时性死区的本质就是，只要一进入当前作用域，所要使用的变量就已经存在了，但是不可获取，只有等到声明变量的那一行代码出现，才可以获取和使用该变量。
* var,let,const不允许在相同作用域内，重复声明同一个变量
* ES5 只有全局作用域和函数作用域，没有块级作用域,所以导致以下两个问题
```js
内层变量可能会覆盖外层变量
var tmp = new Date();

function f() {
  console.log(tmp);
  if (false) {
    var tmp = 'hello world';
  }
}

f(); // undefined
用来计数的循环变量泄露为全局变量
var s = 'hello';

for (var i = 0; i < s.length; i++) {
  console.log(s[i]);
}

console.log(i); // 5
```
* const声明的变量不得改变值，这意味着，const一旦声明变量，就必须立即初始化，不能留到以后赋值
* const实际上保证的，并不是变量的值不得改动，而是变量指向的那个内存地址所保存的数据不得改动。对于简单类型的数据（数值、字符串、布尔值），值就保存在变量指向的那个内存地址，因此等同于常量。但对于复合类型的数据（主要是对象和数组），变量指向的内存地址，保存的只是一个指向实际数据的指针，const只能保证这个指针是固定的（即总是指向另一个固定的地址），至于它指向的数据结构是不是可变的，就完全不能控制了。因此，将一个对象声明为常量必须非常小心。
* ES6 为了改变这一点，一方面规定，为了保持兼容性，var命令和function命令声明的全局变量，依旧是顶层对象的属性；另一方面规定，let命令、const命令、class命令声明的全局变量，不属于顶层对象的属性。也就是说，从 ES6 开始，全局变量将逐步与顶层对象的属性脱钩。

### 变量的解构赋值
* 解构不成功，变量的值就等于undefined
* 只要某种数据结构具有 Iterator 接口，都可以采用数组形式的解构赋值
* 解构赋值允许指定默认值,ES6 内部使用严格相等运算符（===），判断一个位置是否有值。所以，只有当一个数组成员严格等于undefined，默认值才会生效。如果默认值是一个表达式，那么这个表达式是惰性求值的，即只有解构失败时，才会执行这个表达式；默认值可以引用解构赋值的其他变量，但该变量必须已经声明
* 对象的解构与数组有一个重要的不同。数组的元素是按次序排列的，变量的取值由它的位置决定；而对象的属性没有次序，变量必须与属性同名，才能取到正确的值
* 对象的解构赋值的内部机制，是先找到同名属性，然后再赋给对应的变量。真正被赋值的是后者，而不是前者。
```js
let { foo: baz } = { foo: "aaa", bar: "bbb" };
baz // "aaa"
foo // error: foo is not defined

let obj = {};
let arr = [];
嵌套赋值
({ foo: obj.prop, bar: arr[0] } = { foo: 123, bar: true });

obj // {prop:123}
arr // [true]
默认值
var {x: y = 3} = {x: 5};
y // 5
```
* 字符串也可以解构赋值。这是因为此时，字符串被转换成了一个类似数组的对象
```js
let {length : len} = 'hello';
len // 5
```

* 解构赋值的规则是，只要等号右边的值不是对象或数组，就先将其转为对象。由于undefined和null无法转为对象，所以对它们进行解构赋值，都会报错。

* 函数参数的解构也可以使用默认值。

```js
function move({x = 0, y = 0} = {}) {
  return [x, y];
}

move({x: 3, y: 8}); // [3, 8]
move({x: 3}); // [3, 0]
move({}); // [0, 0]
move(); // [0, 0]
```