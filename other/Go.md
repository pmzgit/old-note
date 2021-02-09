是Google开发的一种静态强类型、编译型、并发型，并具有垃圾回收功能的编程语言。

Go于2009年11月正式宣布推出，成为开放源代码项目，并在Linux及Mac OS X平台上进行了实现，后来追加了Windows系统下的实现。[5] 在2016年，Go被软件评价公司TIOBE 选为“TIOBE 2016 年最佳语言”。[6] ​ 当前，Go每半年发布一个二级版本（即从a.x升级到a.y）。

Go的语法接近C语言，但对于变量的声明有所不同。Go支持垃圾回收功能。Go的并行模型是以东尼·霍尔的通信顺序进程（CSP）为基础，采取类似模型的其他语言包括Occam和Limbo，[2]，但它也具有Pi运算的特征，比如通道传输。在1.8版本中开放插件（Plugin）的支持，这意味着现在能从Go中动态加载部分函数。

与C++相比，Go并不包括如枚举、异常处理、继承、泛型、断言、虚函数等功能，但增加了 切片(Slice) 型、并发、管道、垃圾回收、接口（Interface）等特性的语言级支持[2]。Go 2.0版本将支持泛型[7]，对于断言的存在，则持负面态度，同时也为自己不提供类型继承来辩护。

不同于Java，Go内嵌了关联数组（也称为哈希表（Hashes）或字典（Dictionaries）），就像字符串类型一样。

简洁、快速、安全
并行、有趣、开源
内存管理、数组安全、编译迅速

撰写风格
在Go中有几项规定，而且这些是强制的，当不匹配以下规定时编译将会产生错误。

每行程序结束后不需要撰写分号（;）。
大括号（{）不能够换行放置。
if判断式和for循环不需要以小括号包覆起来。
Go亦有内置gofmt工具，能够自动整理代码多余的空白、变量名称对齐、并将对齐空格转换成Tab。

项目架构
Go的工作区的目录结构如下[8]：

src
pkg
bin





tar -C /usr/local -xzf go1.12.1.linux-amd64.tar.gz

/etc/profile
export PATH=$PATH:/usr/local/go/bin:$(go env GOPATH)/bin
export GO111MODULE=auto
source /etc/profile

GVM 

GOPATH 可用于 Go 导入、安装、构建和更新，还会被 Gogland 自动识别（见第四节）。

go version

go mod init hello

子目录里是不需要init的，所有的子目录里的依赖都会组织在根目录的go.mod文件里

按照过去的做法，要运行hello.go需要执行go get 命令 下载beego包到 $GOPATH/src

但是，使用了新的包管理就不在需要这样做了

直接 go run hello.go

稍等片刻… go 会自动查找代码中的包，下载依赖包，并且把具体的依赖关系和版本写入到go.mod和go.sum文件中。
查看go.mod，它会变成这样：

module hello

go 1.12

require github.com/astaxie/beego v1.11.1

使用Go的包管理方式，依赖的第三方包被下载到了$GOPATH/pkg/mod路径下。

依赖包的版本号是什么？ 是包的发布者标记的版本号，格式为 vn.n.n (n代表数字)，本例中的beego的历史版本可以在其代码仓库release看到


auto 自动模式下，项目在$GOPATH/src里会使用$GOPATH/src的依赖包，在$GOPATH/src外，就使用go.mod 里 require的包
on 开启模式，1.12后，无论在$GOPATH/src里还是在外面，都会使用go.mod 里 require的包
off 关闭模式，就是老规矩。

replace golang.org/x/text => github.com/golang/text latest



https://github.com/urfave/cli/tree/v2