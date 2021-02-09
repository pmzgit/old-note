

## 启动
```sh
./bin/mycat start 启动
./bin/mycat stop 停止
./bin/mycat console 前台运行
./bin/mycat restart 重启服务
./bin/mycat pause 暂停
./bin/mycat status 查看启动状态
```

## 日志 
log4j2.xml 文件设置level 级别至 debug  
无论是启动（ wrapper.log）还是运行过程中（ mycat.log）

## 连接
```sh
目前 mycat 有两个端口， 8066 数据端口， 9066 管理端口，命令行的登陆是通过 9066 管理端口来操
作，登录方式类似于 mysql 的服务端登陆。
mysql -h127.0.0.1 -utest -ptest -P9066 [-dmycat]
-h 后面是主机，即当前 mycat 按照的主机地址，本地可用 127.0.0.1 远程需要远程 ip
-u Mycat server.xml 中配置的逻辑库用户
-p Mycat server.xml 中配置的逻辑库密码
-P 后面是端口 默认 9066，注意 P 是大写
-d Mycat server.xml 中配置的逻辑库
数据端口与管理端口的配置端口修改：
数据端口默认 8066，管理端口默认 9066 ，如果需要修改需要配置 serve.xml
<system>
<property name="serverPort">8067</property>
<property name="managerPort">9066</property>
</system>


show @@help; 可以查看所有的命令
```