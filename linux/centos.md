## 查看发行版信息
`cat /etc/issue`  
`cat /etc/centos-release `  
or  
`lsb_release -a` 查看当前系统版本信息  
## linux 查看硬件信息
* `cat /proc/cpuinfo or lscpu` 查看cpu统计信息 
```
socket：物理CPU的插槽
Core per Socket：每一个插槽对应的物理CPU上有多少个核
Thread per Core：每个核上有多少个线程

看个图：（几核几线程就是指有多少个“Core per Socket”多少个“Thread per Core”,当后者比前者多时，
说明启用了超线程技术）
```
* `free -h` 查看概要内存情况  
* `cat /proc/meminfo` 查看内存详细使用情况 
* `dmidecode -t memory ` or ` cat /proc/meminfo` 查看内存硬件（主板槽位信息）
* `getconf LONG_BIT` 查看操作系统位数  
* `uname -a` 查看系统内核信息
* `df -ahT` 查看磁盘容量  
* `du -sh dir` Show the size of a single folder, in human readable units:
* dmidecode

Dmidecode 这款软件允许你在 Linux 系统下获取有关硬件方面的信息。Dmidecode 遵循 SMBIOS/DMI 标准，其输出的信息包括 BIOS、系统、主板、处理器、内存、缓存等等。偶发现这个工具很有用，就总结一下。

一、DMI简介：

　　DMI (Desktop Management Interface, DMI)就是帮助收集电脑系统信息的管理系统，DMI信息的收集必须在严格遵照SMBIOS规范的前提下进行。 SMBIOS(System Management BIOS)是主板或系统制造者以标准格式显示产品管理信息所需遵循的统一规范。SMBIOS和DMI是由行业指导机构Desktop Management Task Force (DMTF)起草的开放性的技术标准，其中DMI设计适用于任何的平台和操作系统。

　　DMI充当了管理工具和系统层之间接口的角色。它建立了标准的可管理系统更加方便了电脑厂商和用户对系统的了解。DMI的主要组成部分是Management Information Format (MIF)数据库。这个数据库包括了所有有关电脑系统和配件的信息。通过DMI，用户可以获取序列号、电脑厂商、串口信息以及其它系统配件信息。

* 查看当前主机是物理机还是虚拟机
```sh
dmidecode -s system-product-name
dmesg | grep -i virtual
cat /proc/scsi/scsi | grep Vendor
```
## [理解Linux系统/etc/init.d目录和/etc/rc.local脚本](http://blog.csdn.net/acs713/article/details/7322082)

## 中文语言
* echo $LANG 
查看当前语言
* locale -a
查看是否安装中文语言包（zh_CN.UTF-8）  
* 安装中文语言包  
`yum groupinstall chinese-support`  

* `vim  /etc/sysconfig/i18n` 配置文件   
设置 `LANG="zh_CN.UTF-8"`
重启
* 临时设置 LANG 环境变量也可，即时生效
## 关机or重启
`shutdown -h now`  
`sudo shutdown -r +1 "off"`
## lrzsz
* rz -bey ：上传
* sz 文件  ：下载
`yum install lrzsz`

## ssh 远程登陆超时自动退出 时间配置 
`vim /etc/profile`
```shell
# 单位毫秒，0 
TMOUT=0
export TMOUT
```
`source /etc/profile`
## CentOS ping: unknown host 解决方法

1. 配置dns   
您必须是管理员root或者具有管理员权限   
sudo vim /etc/resolv.conf   
nameserver 8.8.8.8    
nameserver 8.8.4.4
nameserver 1.1.1.1  
nameserver 1.0.0.1                                
nameserver 223.5.5.5  
nameserver 223.6.6.6  
* 保存退出，然后使用dig 验证:  
dig www.taobao.com +short  
若出现结果则表示正常。  
2. 确保路由表正常  
netstat -rn (route -n 获取网关)
如果未设置, 则通过如下方式增加网关:
route add default gw 192.168.1.1
3. 确保可用dns解析
grep hosts /etc/nsswitch.conf 
> hosts:      files dns  
4. 重启网络  
service network restart 或 /etc/init.d/network restart 

## 查看运行级别用：runlevel  /etc/inittab  startx或者xinit 
0：停止系统运行。init 0〈回车〉相当于 halt〈回车〉。
6：重启系统。init 6〈回车〉相当于 reboot〈回车〉。

## centos7 修改主机名
hostnamectl --help
hostnamectl status
hostnamectl --static set-hostname [主机名]

三种主机名
docker pull docker.elastic.co/elasticsearch/elasticsearch:6.5.4
This tool distinguishes three different hostnames: the high-level "pretty" hostname which might include all kinds of special characters (e.g. "Lennart's
Laptop"), the static hostname which is used to initialize the kernel hostname at boot (e.g. "lennarts-laptop"), and the transient hostname which might be
assigned temporarily due to network configuration and might revert back to the static hostname if network connectivity is lost and is only temporarily
written to the kernel hostname (e.g. "dhcp-47-11").
Note that the pretty hostname has little restrictions on the characters used, while the static and transient hostnames are limited to the usually accepted
characters of Internet domain names.

使用命令：chkconfig sshd on 设置为开机启动
使用命令：chkconfig --list |grep sshd查看设置结果，
service sshd start

## 查看位数
file /sbin/init 或者 file /bin/ls   
uname -a:
## 安装ftp客户端
`rpm -Uvh http://mirror.centos.org/centos/6/os/x86_64/Packages/ftp-0.17-54.el6.x86_64.rpm`  
or  
`yum install ftp`  
* ftp 登陆命令  
`ftp ip port`

## vsftpd
vim /etc/vsftpd/vsftpd.conf
```sh
# 匿名访问模式  账户统一为anonymous，密码为空, 默认访问的是/var/ftp,目录的所有者身份改成系统账户ftp；关闭selinux
chown -Rf ftp /var/ftp/pub
# 配置
anonymous_enable=YES
anon_umask=022
anon_upload_enable=YES
anon_mkdir_write_enable=YES
anon_other_write_enable=YES

# 本地用户模式
anonymous_enable=NO
local_enable=YES
write_enable=YES
local_umask=022
userlist_deny=YES	 # 默认值，启用“禁止用户名单”，名单文件为ftpusers和user_list
userlist_enable=YES	#开启用户作用名单文件功能

# 虚拟用户模式

# 创建用于进行FTP认证的用户数据库文件，其中奇数行为账户名，偶数行为密码，明文信息既不安全，也不符合让vsftpd服务程序直接加载的格式，因此需要使用db_load命令用哈希（hash）算法将原始的明文信息文件转换成数据库文件，并且降低数据库文件的权限（避免其他人看到数据库文件的内容），然后再把原始的明文信息文件删除。
# db_load 将用户信息文件转换为数据库并使用hash加密，-T选项，-T允许应用程序能够将文本文件转译载入进数据库。由于我们之后是将虚拟用户的信息以文件方式存储在文件里的，为了让Vsftpd这个应用程序能够通过文本来载入用户数据，必须要使用这个选项。如果指定了选项-T，那么一定要追跟子选项-t；-t子选项-t，追加在在-T选项后，用来指定转译载入的数据库类型。扩展介绍下，-t可以指定的数据类型有Btree、Hash、Queue和Recon数据库。-f参数后面接包含用户名和密码的文本文件，文件的内容是：奇数行用户名、偶数行密码

db_load -T -t hash -f vuser.list vuser.db
file vuser.db
chmod 600 vuser.db
rm -f vuser.list
# 创建vsftpd服务程序用于存储文件的根目录以及虚拟用户映射的系统本地用户
useradd -d /var/ftproot -s /sbin/nologin virtual
ls -ld /var/ftproot/
chmod -Rf 755 /var/ftproot/
# 建立用于支持虚拟用户的PAM文件
# PAM（可插拔认证模块）是一种认证机制，通过一些动态链接库和统一的API把系统提供的服务与认证方式分开，使得系统管理员可以根据需求灵活调整服务程序的不同认证方式。通俗来讲，PAM是一组安全机制的模块，系统管理员可以用来轻易地调整服务程序的认证方式，而不必对应用程序进行任何修改。PAM采取了分层设计（应用程序层、应用接口层、鉴别模块层）的思想

# 新建一个用于虚拟用户认证的PAM文件vsftpd.vu，其中PAM文件内的“db=”参数为使用db_load命令生成的账户密码数据库文件的路径，但不用写数据库文件的后缀
vim /etc/pam.d/vsftpd.vu
auth       required     pam_userdb.so db=/etc/vsftpd/vuser
account    required     pam_userdb.so db=/etc/vsftpd/vuser

# 在vsftpd服务程序的主配置文件中通过pam_service_name参数将PAM认证文件的名称修改为vsftpd.vu，PAM作为应用程序层与鉴别模块层的连接纽带，可以让应用程序根据需求灵活地在自身插入所需的鉴别功能模块

anonymous_enable=NO	# 禁止匿名开放模式
local_enable=YES	#允许本地用户模式
guest_enable=YES	#开启虚拟用户模式
guest_username=virtual	#指定虚拟用户账户
pam_service_name=vsftpd.vu	#指定PAM文件
allow_writeable_chroot=YES	#允许对禁锢的FTP根目录执行写入操作，而且不拒绝用户的登录请求

# 为虚拟用户设置不同的权限；这可以通过vsftpd服务程序来实现。只需新建一个目录，在里面分别创建两个以zhangsan和lisi命名的文件，其中在名为zhangsan的文件中写入允许的相关权限（使用匿名用户的参数）
mkdir /etc/vsftpd/vusers_dir/
cd /etc/vsftpd/vusers_dir/
touch lisi
vim zhangsan
anon_upload_enable=YES
anon_mkdir_write_enable=YES
anon_other_write_enable=YES

vsftpd主配置文件，通过添加user_config_dir参数来定义这两个虚拟用户不同权限的配置文件所存放的路径，重启vsftpd服务

```
## centos 编译安装git
```sh
// 卸载自带的git
yum remove git
// 依赖
yum install curl-devel expat-devel gettext-devel \
  openssl-devel zlib-devel
下载最新版git
wget https://www.kernel.org/pub/software/scm/git/git-2.17.0.tar.gz
解压
tar zxvf git-2.17.0.tar.gz
cd git-2.17.0
编译安装
make prefix=/usr/local all
sudo make prefix=/usr/local install
修改环境变量
sudo vim /etc/profile
在最后一行添加
export PATH=/usr/local/git/bin:$PATH
保存后使其立即生效
source /etc/profile
查看是否安装成功
git --version
```

## scp
* 命令基本格式： scp [可选参数] file_source file_target 
* ssh -p port user@host
* scp -r /home/space/music/ root@www.cumt.edu.cn:/home/root/others/   
 上面 命令 将 本地 music 目录 复制 到 远程 others 目录下，即复制后有 远程 有 ../others/music/ 目录 
* 可选参数  
```shell
-v 和大多数 linux 命令中的 -v 意思一样 , 用来显示进度 . 可以用来查看连接 , 认证 , 或是配置错误 . 

-C 使能压缩选项 . 

-P 选择端口 . 注意 -p 参数用来保证复制后的文件各属性不变. 

-4 强行使用 IPV4 地址 . 

-6 强行使用 IPV6 地址 .

-2 强制scp命令使用协议ssh2
```

* 注意两点：  
1. 如果远程服务器防火墙有特殊限制，scp便要走特殊端口，具体用什么端口视情况而定，命令格式如下：  
`scp -P 4588 remote@www.abc.com:/usr/local/sin.sh /home/administrator`   
2. 使用scp要注意所使用的用户是否具有可读取远程服务器相应文件的权限。

## msyql yum install
* 查看msyql 运行状态  
service mysqld status  
ps aux |grep mysqld  

* 启动 重启  
service mysqld start  
service mysqld restart  
* 是不是开机启动   
chkconfig --list |grep mysqld
* chkconfig --list如果列表中没有mysqld这个，需要先用这个命令添加：
chkconfig add mysqld  
* 设置开机启动   
 chkconfig mysqld on  
*  为root账号设置密码   
/usr/bin/mysqladmin -u root password 'new-password'  　　

* 登录  
mysql -u root -p  

* 配置  
/etc/my.cnf  
   

## [rar/unrar](https://www.rarlab.com/download.htm)
* rar软件不需要安装，直接解压到/usr/local下，以下操作需要有root权限。

* 然后执行以下命令  
`ln -s /usr/local/rar/rar /usr/local/bin/rar;ln -s /usr/local/rar/unrar /usr/local/bin/unrar` 
`

# centos 7
* yum upgrade && yum install net-tools



## [chrony](https://renwole.com/archives/1032)
                      