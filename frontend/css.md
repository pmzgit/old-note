### css优先级
* 渲染规则  
    1. 计算权重  
    2. 就近规则  
    3. !important

### css动画

- 2D 3D转换 transform属性
- 过度 transition prop time 效果（属性）+时间
- 动画 animation 名称+时间 属性 遵循@keyframes

```javascript
// apply prefixed event handlers
function PrefixedEvent(element, type, callback) {
    for (var p = 0; p < pfx.length; p++) {
        if (!pfx[p]) type = type.toLowerCase();
        element.addEventListener(pfx[p] + type, callback, false);
    }
};
// handle animation events
function AnimationListener(e) {
    LogEvent("Animation '" + e.animationName + "' type '" + e.type + "' at " + e.elapsedTime.toFixed(2) + " seconds");
    if (e.type.toLowerCase().indexOf("animationend") >= 0) {
        LogEvent("Stopping animation...");
        ToggleAnimation();
    }
}
 // animation listener events
 PrefixedEvent(anim, "AnimationStart", AnimationListener);
 PrefixedEvent(anim, "AnimationIteration", AnimationListener);
 PrefixedEvent(anim, "AnimationEnd", AnimationListener);
var $element = $('.eye').bind("webkitAnimationEnd oAnimationEnd msAnimationEnd animationend", function(event) {
            if (event.animationName === "three") {
                console.log('the event happened');
            }
        }

```

### js动画

```js
// 访问css class列表
var el = document.querySelector(".myclass");
// selectors 是一个字符串，包含一个或是多个 CSS 选择器 ，多个则以逗号分隔。
//如果没有找到匹配元素，则返回 null，如果找到多个匹配元素，则返回第一个匹配到的元素。
// elementList = document.querySelectorAll(selectors);
el.classList.add('className');
el.classList.remove('className');
el.classList.item(index);

// animation
window.requestAnimationFrame = window.requestAnimationFrame || window.mozRequestAnimationFrame || window.webkitRequestAnimationFrame || window.msRequestAnimationFrame;

function Box () {

  var animationStartTime = 0;
  var animationDuration = 500;
  var target = document.querySelector('.box');

  this.startAnimation = function() {
    animationStartTime = Date.now();
    requestAnimationFrame(update);
  };

  function update() {
    var currentTime = Date.now();
    var positionInAnimation = (currentTime - animationStartTime) / animationDuration;

    var xPosition = positionInAnimation * 100;
    var yPosition = positionInAnimation * 100;

    target.style.transform = 'translate(' + xPosition + 'px, ' + yPosition + 'px)';

    if (positionInAnimation <= 1)
      requestAnimationFrame(update);
  }
}

var box = new Box();
box.startAnimation();
````

### [flex](http://www.ruanyifeng.com/blog/2015/07/flex-grammar.html)

### [css 布局](http://zh.learnlayout.com/toc.html)

- 盒子模型

  > border-radius box-shadow border-image  
  > 外边距叠加: 遵循最大原则

- 对齐

  > - margin 水平
  > - position 4个值  [参考](http://zh.learnlayout.com/position.html)  
  >   static  默认
  >   absolute 脱离文档流  
  >   relative  
  >   fixed  脱离文档流，相对于视窗
  > - float 左右  
  >   inline-block 脱离文档流  
  >   .clearfix { overflow: auto; zoom: 1; }

- 选择器

  - 多类选择器   
  css: .class1.class2{ }   
  html: class = "class1 class2"
  - 相邻选择器 +   
  同一个父亲，该元素之后的所有同级元素都起效果
  - 同辈选择器 ~  
  - 属性选择器  
  早在CSS2中就被引入了，其主要作用就是为带有指定属性的HTML元素设置样式。使用CSS3属性选择器，你可以只指定元素的某个属性，或者你还可以同时指定元素的某个属性和其对应的属性值  
  在CSS2中引入了一些属性选择器，而CSS3在CSS2的基础上对属性选择器进行了扩展，新增了3个属性选择器，使得属性选择器有了通配符的概念，这三个属性选择器与CSS2的属性选择器共同构成了CSS功能强大的属性选择器。  
  CSS3的属性选择器主要包括以下几种：
  - E[attr^="value"]：指定了属性名，并且有属性值，属性值是以value开头的；
  - E[attr$="value"]：指定了属性名，并且有属性值，而且属性值是以value结束的；
  - E[attr*="value"]：指定了属性名，并且有属性值，而且属值中包含了value；   
  如下，我们设置a标签的href属性值的背景色：<br>
  .wrap a[href^="http://"]{background:orange;color:blue;}  
  .wrap a[href^="mailto:"]{background:blue;color:orange;}  
    上面代码选择了a标签的href属性，并且选取属性值为"http://"和"mailto:"开头的所有a标签，改变其颜色。


  - 这节内容是CSS3选择器最新部分，有人也称这种选择器为CSS3结构类，下面我们通过实际的应用来具体了解他们的使用和区别，首先列出他具有的选择方法：

      1. :first-child选择某个元素的第一个子元素；
      2. :last-child选择某个元素的最后一个子元素；
      3. :first-of-type选择一个上级元素下的第一个同类子元素；
      4. :last-of-type选择一个上级元素的最后一个同类子元素；
      5. :nth-child()选择某个元素的一个或多个特定的子元素；
      6. :nth-last-child()选择某个元素的一个或多个特定的子元素，从这个元素的最后一个子元素开始算；
      7. :nth-of-type()选择指定的元素；
      8. :nth-last-of-type()选择指定的元素，从元素的最后一个开始计算；
      9. :only-child选择的元素是它的父元素的唯一一个了元素；
      10. :only-of-type选择一个元素是它的上级元素的唯一一个相同类型的子元素；
      11. :empty选择的元素里面没有任何内容。
