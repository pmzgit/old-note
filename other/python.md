# [基础](https://www.liaoxuefeng.com/wiki/1016959663602400)
* 还有同学问，能不能像.exe文件那样直接运行.py文件呢？在Windows上是不行的，但是，在Mac和Linux上是可以的，方法是在.py文件的第一行加上：`#!/usr/bin/env python3`
* `# -*- coding: utf-8 -*-` 告诉解释器用utf-8读取源代码

https://docs.python.org/3/library/functions.html

https://www.liaoxuefeng.com/wiki/1016959663602400

https://shockerli.net/post/python-study-note/#%E7%94%9F%E6%88%90%E5%99%A8

# env管理

## virtualenv
mkdir myproject
virtualenv --no-site-packages venv
source venv/bin/activate
deactivate

https://hugo1030.github.io/tech/pynv-virtualenv/  

https://github.com/pyenv/pyenv    
https://www.jianshu.com/p/f15cb9571cab

https://github.com/pyenv/pyenv/wiki/common-build-problems

https://blog.zengrong.net/post/python_packaging/

https://pypi.org/

https://www.anaconda.com/distribution/

PYTHONPATH
PYTHON_HOME

python --version  
python3 --version
pip --version  
pip help

## 构建
https://packaging.python.org/tutorials/installing-packages/  
http://blog.konghy.cn/2018/04/29/setup-dot-py/

wheel 还提供了一个 bdist_wheel 作为 setuptools 的扩展命令，这个命令可以用来生成 wheel 包  
pip 提供了一个 wheel 子命令来安装 wheel 包。当然，需要先安装 wheel 模块。  
pip install wheel    ->    pip install  **.whl  


### https://github.com/bndr/pipreqs

pip install pipreqs
pipreqs /home/project/location


pip freeze > requirements.txt
pip install -r requirements.txt 
python setup.py install

查看包 pip list  

pip show pycurl  

pip uninstall pycurl  

安装a.whl包 pip install a.whl

升级包 pip install --upgrade a.whl

卸载包 pip uninstall a.whl

查看待更新包 pip list --outdate

升级pip自己 pip install --upgrade pip

升级某个版本的包

pip install SomePackage # latest version

pip install SomePackage==1.0.4 # specific version

## [docker](https://hub.docker.com/_/python)
```sh

# Dockerfile

FROM python:3

WORKDIR /usr/src/app

COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

COPY ./MySqlClient.py ./Sms.py ./

CMD [ "python", "./Sms.py" ]

# 构建、运行

docker build -t my-python-app .
docker run -it --rm --name my-running-app my-python-app


docker run -it --rm --name my-running-script -v "$PWD":/usr/src/myapp -w /usr/src/myapp python:3 python your-daemon-or-script.py
```

# [异常](https://docs.python.org/3/library/exceptions.html#exception-hierarchy)

# [doc](https://www.cnblogs.com/kaid/p/7992240.html)

* 调试

启动Python解释器时可以用-O参数来关闭assert，关闭后，你可以把所有的assert语句当成pass来看。

python -O err.py

python -m pdb err.py

输入命令l来查看代码  
输入命令n可以单步执行代码  
任何时候都可以输入命令 `p 变量名` 来查看变量  
输入命令q结束调试

* 断点

python err.py 
import pdb，然后，在可能出错的地方放一个pdb.set_trace()，就可以设置一个断点：  
运行代码，程序会自动在pdb.set_trace()暂停并进入pdb调试环境，可以用命令p查看变量，或者用命令c继续运行

## 函数
Python的函数具有非常灵活的参数形态，既可以实现简单的调用，又可以传入非常复杂的参数。

默认参数一定要用不可变对象，如果是可变对象，程序运行时会有逻辑错误！

要注意定义可变参数和关键字参数的语法：

*args是可变参数，args接收的是一个tuple；

**kw是关键字参数，kw接收的是一个dict。

以及调用函数时如何传入可变参数和关键字参数的语法：

可变参数既可以直接传入：func(1, 2, 3)，又可以先组装list或tuple，再通过*args传入：func(*(1, 2, 3))；

关键字参数既可以直接传入：func(a=1, b=2)，又可以先组装dict，再通过**kw传入：func(**{'a': 1, 'b': 2})。

使用*args和**kw是Python的习惯写法，当然也可以用其他参数名，但最好使用习惯用法。

命名的关键字参数是为了限制调用者可以传入的参数名，同时可以提供默认值。

定义命名的关键字参数在没有可变参数的情况下不要忘了写分隔符*，否则定义的将是位置参数。

参数定义的顺序必须是：

必选参数、默认参数、可变参数、命名关键字参数和关键字参数


对于任意函数，都可以通过类似func(*args, **kw)的形式调用它，无论它的参数是如何定义的。

函数体中没有 return 语句时，函数运行结束会隐含返回一个 None 作为返回值，类型是 NoneType，与 return 、return None 等效，都是返回 None。

如果 Python 函数直接返回多个值，Python 会自动将多个返回值封装成元组，使用多个变量接收函数返回的多个值

## 面向对象
继承可以把父类的所有功能都直接拿过来，这样就不必重零做起，子类只需要新增自己特有的方法，也可以把父类不适合的方法覆盖重写。

动态语言的鸭子类型特点决定了继承不像静态语言那样是必须的。

type()函数，返回对应的Class类型，基本数据类型可以直接写int，str
types模块中定义的常量，types.FunctionType，types.BuiltinFunctionType
isinstance()判断的是一个对象是否是该类型本身，或者位于该类型的父继承链上。
isinstance([1, 2, 3], (list, tuple))

要获得一个对象的所有属性和方法，可以使用dir()函数，它返回一个包含字符串的list，比如，获得一个str对象的所有属性和方法：


配合getattr()、setattr()以及hasattr()，我们可以直接操作一个对象的状态
 getattr(obj, 'z', 404) # 获取属性'z'，如果不存在，返回默认值404，获取函数并赋值变量

 不要对实例属性和类属性使用相同的名字，因为相同名称的实例属性将屏蔽掉类属性，但是当你删除实例属性后，再使用相同的名称，访问到的将是类属性


# [requests](https://cn.python-requests.org/zh_CN/latest/)

# [PyMySQL](https://pymysql.readthedocs.io/en/latest/user/index.html)
pip install PyMySQL

https://shockerli.net/post/python3-pymysql/

https://segmentfault.com/a/1190000014619788