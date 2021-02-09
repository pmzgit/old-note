* yum（全称为 Yellow dog Updater, Modified）是一个在Fedora和RedHat以及SUSE中的Shell前端软件包管理器。
基於RPM包管理，能够从指定的服务器自动下载RPM包并且安装，可以自动处理依赖性关系，并且一次安装所有依赖的软体包，无须繁琐地一次次下载、安装。
yum提供了查找、安装、删除某一个、一组甚至全部软件包的命令，而且命令简洁而又好记。

* YUM是RedHat Linux在线安装更新及软件的工具，但是这是RHEL5的收费功能，如果没有购买Redhat的服务时不能使用RHEL的更新源的，会提示注册。

* 由于CentOS是从RedHat演化而来的免费Linux版本，因此可以利用CentOS的yum更新源来实现RHEL5的YUM功能
# yum 客户端配置
* yum respository（yum 仓库）  
    yum repo，存储了众多rpm包，以及包的相关的元数据文件（放置于特定目录repodata下）
* yum中常用的文件服务器类型  
    ftp://  
    http://  
    file:///（本地yum源）  
* yum客户端的配置文件  
    /etc/yum.conf:为所有仓库提供公共配置  
    /etc/yum.repos.d/*.repo:为仓库的指向提供配置  
* 仓库指向的定义  
```sh
[repositoryID]
name=Some name for this repository  
baseurl=url://path/to/repository/  
enabled={1|0} 
gpgcheck={1|0}
gpgkey=URL
enablegroups={1|0}
failovermethod={roundrobin|priority}
默认为：roundrobin，意为随机挑选；
cost= 默认为1000注意：

参数不是全部都需要进行配置，但最基本的必须包括以下三点
    （1）：[repositoryID]
    （2）：baseurl=url://path/to/repository/
    （3） enabled={1|0}

``` 
* yum-config-manager  
yum-config-manager --disbale "仓库名" 禁用仓库  
yum-config-manager --enable "仓库名" 启用仓库  
yum-config-manager --enable fedora（仓库名是在配置时中括号中的名字）
## rpm
```shell
rpm -qa | grep mysql　　// 这个命令就会查看该操作系统上是否已经安装了mysql数据库

rpm -ivh --force --nodeps package.rpm
rpm -Uvh pac.rpm 升级
rpm -ql 包名 查看安装列表

rpm -qpi package.rpm 查询软件描述信息
rpm -qpl package.rpm 列出软件文件信息

rpm -e mysql　　// 普通删除模式
rpm -e --nodeps mysql　　// 强力删除模式，如果使用上面命令删除时，提示有依赖的其它文件，则用该命令可以对其进行强力删除

which mysql 找出可执行文件

rpm -qilf `which 程序名` 安装来源

```

## yum
```shell

yum的命令形式一般是如下：yum [options] [command] [package ...]
其中的[options]是可选的，选项包括-h（帮助），-y（当安装过程提示选择全部为"yes"），-q（不显示安装的过程）等等。[command]为所要进行的操作，[package ...]是操作的对象。

概括了部分常用的命令包括：

自动搜索最快镜像插件：   yum install yum-fastestmirror
安装yum图形窗口插件：    yum install yumex
查看可能批量安装的列表： yum grouplist

1 安装
yum install 全部安装
yum install package1 [package2] [...] 安装指定的安装包package1
yum groupinsall group1 安装程序组group1

2 更新和升级
yum update 全部更新
yum update package1 更新指定程序包package1
yum check-update 检查可更新的程序
yum upgrade package1 升级指定程序包package1
yum groupupdate group1 升级程序组group1

3 查找和显示
yum info package1 显示安装包信息package1
yum list 显示所有已经安装和可以安装的程序包
yum list updates 列出所有可更新的软件包
yum list installed 列出所有已安装的软件包
yum list extras 列出所有已安装但不在 Yum Repository 內的软件包
yum list package1 显示指定程序包安装情况package1
yum groupinfo group1 显示程序组group1信息
yum search string 根据关键字string查找安装包

4 删除程序
yum remove|erase package1 删除程序包package1
yum groupremove group1 删除程序组group1
yum deplist package1 查看程序package1依赖情况

5 清除缓存
yum clean packages 清除缓存目录/var/cache/yum下的软件包
yum clean headers 清除缓存目录下的 headers
yum clean oldheaders 清除缓存目录下旧的 headers
yum clean, yum clean all (= yum clean packages; yum clean oldheaders) 清除缓存目录下的软件包及旧的headers
yum makecache fast
``` 
# 删除centos自带yum 包
`rpm -aq | grep yum |xargs rpm -e --nodeps`
# 下载、安装yum

访问 http://mirrors.163.com/centos/6/os/x86_64/Packages 搜索相应的包文件
* python-iniparse
* python-urlgrabber
* yum-metadata-parser
* yum-plugin-fastestmirror
* yum  
按照以上顺序安装，注意最后两个rpm 包，一起安装  
`rpm -ivh python-iniparse.rpm`  
`rpm -ivh python-urlgrabber.rpm`
`rpm -ivh yum-metadata-parser.rpm`  
`rpm -ivh yum.rpm yum-plugin-fastestmirror.rpm`
#### 我这服务器在安装yum的时候，提示 python-urlgrabber rpm包版本较低，所以需要先卸载，再重新下载相应的包（还是从上面的连接里找），安装即可
# 添加阿里云的yum源
`wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-6.repo`
## 修改配置文件，并更新缓存
* `sed -i 's/\$releasever/6/g' CentOS-Base.repo`
* `yum clean all` // 清空 yum 缓存
* `yum makecache fast` //将服务器上的软件包信息缓存到本地

# 配置第三方源 
Extra Packages for Enterprise Linux (EPEL):
该组织致力于为 RHEL 发行版创建和维护更多可用的软件包。
* [参考：CentOS 添加常用 yum 源](https://blog.itnmg.net/2012/09/17/centos-yum-source/)  

```sh
wget http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
wget http://rpms.famillecollet.com/enterprise/remi-release-6.rpm
rpm -ivh remi-release-6.rpm
rpm -ivh epel-release-6-8.noarch.rpm

rhel7
wget http://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm && rpm -ivh epel-release-latest-7.noarch.rpm
```
### 安装完运行yum报错：

Error: Cannot retrieve metalink for repository: epel. Please verify its path and try again

### 解决办法 [参考：在Centos 5.x或6.x上安装RHEL EPEL Repo](https://teddysun.com/153.html)
* `vi /etc/yum.repos.d/epel.repo`  
编辑[epel]下的baseurl前的#号去掉，mirrorlist前添加#号。

* 再运行 `yum makecache`
## 参考
[CentOS 添加常用 yum 源](https://blog.itnmg.net/2012/09/17/centos-yum-source/)  
[RHEL6配置yum源为网易镜像](http://www.jianshu.com/p/446e3fe7d710)  
[rhel源更换为centos源](https://www.cnblogs.com/blackchain/p/4877132.html)  