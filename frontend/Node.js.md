# Node.js 简介
* Node.js是一个事件驱动非阻塞型I/O服务端JavaScript环境，基于Google的V8引擎，V8引擎执行Javascript的速度非常快，性能非常好。  
* [Node.js概述 by阮一峰](http://javascript.ruanyifeng.com/nodejs/basic.html)   
* [CommonJS规范 by阮一峰](http://javascript.ruanyifeng.com/nodejs/module.html)  
## yarn / npm 国内源
```sh
yarn config get registry

yarn config set registry https://registry.npm.taobao.org

npm config set registry=https://registry.npm.taobao.org
# 建议不要直接使用 cnpm 安装依赖，会有各种诡异的 bug。可以通过如下操作解决 npm 下载速度慢的问题
npm install --registry=https://registry.npm.taobao.org

```
* 下载cnpm：npm install -g cnpm --registry=https://registry.npm.taobao.org
## 事件循环 
* Node.js 的事件循环对开发者不可见，由 libev 库实现。libev
支持多种类型的事件，如 ev_io、ev_timer、ev_signal、ev_idle 等，在 Node.js 中均被EventEmitter 封装。libev 事件循环的每一次迭代，在 Node.js 中就是一次 Tick，libev 不断检查是否有活动的、可供检测的事件监听器，直到检测不到时才退出事件循环，进程结束。

* Node.js 所有的异步I/O 操作在完成时都会发送一个事件到事件队列。
$ sudo npm install -g supervisor

* foo.js文件的第一行，如果加入了解释器的位置，就可以将其作为命令行工具直接调用。
`#!/usr/bin/env node` 调用前，需更改文件的执行权限。
```sh
$ chmod u+x myscript.js
$ ./foo.js arg1 arg2 ...
```
# semver
* [语义化版本规范](https://cnodejs.org/topic/570f8331510629637266685a)
# npm 模块
* “该用require还是import？”这个问题，因为这个问题就目前而言，根本没法回答，因为目前所有的引擎都还没有实现import，我们在node中使用babel支持ES6，也仅仅是将ES6转码为ES5再执行，import语法会被转码为require。这也是为什么在模块导出时使用module.exports，在引入模块时使用import仍然起效，因为本质上，import会被转码为require去执行。
* 而当我们使用全局模式安装时，npm 会将包安装到系统目录，譬如 /usr/local/lib/node_modules/，同时 package.json 文件中 bin 字段包含的文件会被链接到 /usr/local/bin/。/usr/local/bin/ 是在PATH 环境变量中默认定义的，因此就可以直接在命令行中使用
* （此描述有待验证）使用全局模式安装的包并不能直接在 JavaScript 文件中用 require 获得，因为 require 不会搜索 /usr/local/lib/node_modules/。
* 如果把包安装到全局，可以提高程序的重复利用程度，避免同样的内容的多份副本，但坏处是难以处理不同的版本依赖。
* 如果把包安装到当前目录，或者说本地，则不会有不同程序依赖不同版本的包的冲突问题，同时还减轻了包作者的 API 兼容性压力，但缺陷则是同一个包可能会被安装许多次。
* require 不会重复加载模块，模块一旦被加载以后，就会被系统缓存。如果第二次还加载该模块，则会返回缓存中的版本，这意味着模块实际上只会执行一次。如果希望模块执行多次，则可以让模块返回一个函数，然后多次调用该函数。
* 如果模块目录中没有package.json文件，node.js会尝试在模块目录中寻找index.js或index.node文件进行加载。
* exports 实际上只是一个和 module.exports 指向同一个对象的变量，它本身会在模块执行结束后释放，但 module 不会，因此只能通过指定module.exports 来改变访问接口。不可以通过对 exports 直接赋值代替对 module.exports 赋值。
* package.json文件可以手工编写，也可以使用npm init命令自动生成。  
* npm help config   查看npm 命令文档
* npm info underscore description  查看某个模块的信息
* npm install sax@latest
* npm install sax@0.1.1
* npm install sax@">=0.1.0 <0.2.0"   选择安装模块的特定版本
```sh
npm install express --save
npm install express --save-dev  // 或 npm i -D packageName
```
上面代码表示单独安装express模块，--save参数表示将该模块写入dependencies属性，--save-dev表示将该模块写入devDependencies属性。
* npm一次性安装多个依赖模块，模块之间用空格隔开
* npm允许使用特殊符号，指定所要使用的版本范围，假定当前版本是1.0.4。
只接受补丁包：1.0 或者 1.0.x 或者 ~1.0.4  
只接受小版本和补丁包：1 或者 1.x 或者 ^1.0.4  
接受所有更新：* or x  

* 还可以使用数学运算符（比如>, <, =, >= or <=等），指定版本范围。  
```sh
version 完全匹配
>version 大于这个版本
>=version大于或等于这个版本
<version
<=version
~version 非常接近这个版本
^version 与当前版本兼容
http://... Unix系统下使用的tarball的URL。
* 任何版本都可以
""任何版本都可以
version1 - version2  等价于 >=version1 <=version2.
range1 || range2 满足任意一个即可
git://github.com/package/path.git Git地址
user/repo
注意，如果使用连字号，它的两端必须有空格。如果不带空格，会被npm理解成预发布的tag，比如1.0.0-rc.1。
```
* npm update
```
This command will update all the packages listed to the latest version (specified by the tag config), respecting semver.

It will also install missing packages. As with all commands that install packages, the --dev flag will cause devDependencies to be processed as well.

If the -g flag is specified, this command will update globally installed packages.

If no package name is specified, all packages in the specified location (global or local) will be updated.

As of npm@2.6.1, the npm update will only inspect top-level packages. Prior versions of npm would also recursively inspect all dependencies. To get the old behavior, use npm --depth 9999 update.

```

*  uninstall  更新和卸载模块（-g） 参数全局

* npm list -g 

* npm search
## npm shrinkwrap [](https://tech.meituan.com/npm-shrinkwrap.html)
可以按照当前项目 node_modules 目录内的安装包情况生成稳定的版本号描述。
# npm 脚本
* package.json文件有一项scripts，用于指定脚本命令，供npm直接调用。scripts指定了运行脚本命令的npm命令行缩写，比如start指定了运行npm run start时，所要执行的命令。
* 如果直接运行npm run不给出任何参数，就会列出scripts属性下所有命令。  
* npm run会创建一个shell，执行指定的命令，并将node_modules/.bin加入PATH变量，这意味着本地模块可以直接运行。也就是说，npm run lint直接运行jshint **.js即可，而不用./node_modules/.bin/jshint **.js。  

* 执行顺序   
"build": "npm run build-js && npm run build-css"
上面的写法是先运行npm run build-js，然后再运行npm run build-css，两个命令中间用&&连接。如果希望两个命令同时平行执行，它们中间可以用&连接。

# ESLint
* [ref](https://www.jianshu.com/p/22e6197e5cff)
* [配置](https://eslint.org/docs/user-guide/configuring)
* [ide 集成](https://eslint.org/docs/user-guide/integrations)
# css Moudles
* [阮一峰](http://www.ruanyifeng.com/blog/2016/06/css_modules.html)
* [插件](https://github.com/css-modules/css-modules/blob/master/docs/get-started.md)
# 自定义node 包
* 例如创建一个名为 byvoidmodule 的目录，然后在这个目录中运行npm init：这样就在 byvoidmodule 目录中生成一个符合 npm 规范的 package.json 文件。
* 创建一个index.js 作为包的接口，一个简单的包就制作完成了。
* 在发布前，我们还需要获得一个账号用于今后维护自己的包，使用 npm adduser 根据提示输入用户名、密码、邮箱，等待账号创建完成。完成后可以使用 npm whoami 测验是否已经取得了账号。
* 接下来，在 package.json 所在目录下运行 npm publish，稍等片刻就可以完成发布了。
* 打开浏览器，访问 http://search.npmjs.org/ 就可以找到自己刚刚发布的包了。现在我们可以在世界的任意一台计算机上使用 npm install byvoidmodule 命令来安装它。
* 如果你的包将来有更新，只需要在 package.json 文件中修改 version 字段，然后重新使用 npm publish 命令就行了。如果你对已发布的包不满意（比如我们发布的这个毫无意义的包），可以使用 npm unpublish 命令来取消发布。



# 调试
在命令行下执行 node debug debug.js，
run 执行脚本，在第一行暂停
restart 重新执行脚本
cont, c 继续执行，直到遇到下一个断点
next, n 单步执行
step, s 单步执行并进入函数
out, o 从函数中步出
setBreakpoint(), sb() 在当前行设置断点
setBreakpoint(‘f()’), sb(...) 在函数f的第一行设置断点
setBreakpoint(‘script.js’, 20), sb(...) 在 script.js 的第20行设置断点
clearBreakpoint, cb(...) 清除所有断点
backtrace, bt 显示当前的调用栈
list(5) 显示当前执行到的前后5行代码
watch(expr) 把表达式 expr 加入监视列表
unwatch(expr) 把表达式 expr 从监视列表移除
watchers 显示监视列表中所有的表达式和值
repl 在当前上下文打开即时求值环境
kill 终止当前执行的脚本
scripts 显示当前已加载的所有脚本
version 显示 V8 的版本



V8 提供的调试功能是基于 TCP 协议的，因此 Node.js 可以轻松地实现远程调试。在命
令行下使用以下两个语句之一可以打开调试服务器：
node --debug[=port] script.js
node --debug-brk[=port] script.js

node --debug 命令选项可以启动调试服务器，默认情况下调试端口是 5858，也可以
使用 --debug=1234 指定调试端口为 1234。使用 --debug 选项运行脚本时，脚本会正常
执行，但不会暂停，在执行过程中调试客户端可以连接到调试服务器。如果要求脚本暂停执
行等待客户端连接，则应该使用 --debug-brk 选项。这时调试服务器在启动后会立刻暂停
执行脚本，等待调试客户端连接。
当调试服务器启动以后，可以用命令行调试工具作为调试客户端连接，例如：
//在一个终端中
$ node --debug-brk debug.js
debugger listening on port 5858
//在另一个终端中
$ node debug 127.0.0.1:5858
connecting... ok
debug> n
break in /home/byvoid/debug.js:2
1 var a = 1;
2 var b = 'world';
3 var c = function (x) {
4 console.log('hello ' + x + a);
debug>
事实上，当使用 node debug debug.js 命令调试时，只不过是用 Node.js 命令行工
具将以上两步工作自动完成而已。
