# [Shell的相关概念和配置方法](http://harttle.land/2016/06/08/shell-config-files.html)

# Bash Shell 中文件名不同颜色的含义
* 蓝色－目录
* 绿色－可执行文件
* 红色－压缩文件
* 浅蓝色－链接文件
* 灰色－其他文件
* 紫色－图形文件
* 黄色－设备文件
* 棕色－FIFO文件（先进先出，命令管道）

# 查看系统信息
* 发行版本：cat /etc/issue  或者 cat /etc/debian_version 
* 内核版本：cat /proc/version
* 设置http代理：  export http_proxy=http://hostname:port
* 修改当前用户密码：  
修改用户密码步骤：  
1、命令行下输入命令 passwd 用户名  
2、提示你输入当前用户的当前密码  
3、输入新密码  
4、再次输入新密码  
5、输入命令exit退出  
6、用新密码登录

# 终端快捷键
光标移动
* Ctrl+a	将光标移至输入行头，相当于Home键
* Ctrl+e	将光标移至输入行末，相当于End键
* Ctrl + xx	当前位置与行首之间光标切换
---
剪切粘贴
* Ctrl+k	剪切从光标所在位置到行末 
* Ctrl+u 与上面相反  
* CTRL + w - 剪切光标前一个单词
* ctrl + y 粘贴上一次删除的文本
---
终端指令
* Ctrl+d	键盘输入结束或退出终端
* Ctrl+s	暂定当前程序，暂停后按下任意键恢复运行
* Ctrl+z	将当前程序放到后台运行，恢复到前台为命令fg
* ctrl+l 清屏
* Shift+PgUp	将终端显示向上滚动
* Shift+PgDn	将终端显示向下滚动
---
历史命令
* Ctrl + r	向后搜索历史命令，再次按下 ctrl + r 组合键将向上查询另一条包含指定字符串的命令。 
* 按左键或者右键，退出搜索模式 
* !!  直接调用上一条命令。
* 输入“!9527”，回调 history 列表中的第 9527 条命令    
* Ctrl + g	退出搜索
HISTTIMEFORMAT="%F %T `whoami` "
---
* crtl + alt + 方向键 ：工作区切换
* shift + crtl + alt + 方向键 ：把当前窗口移到另一个工作区
* super + d ：显示桌面
* shift + f10 ： 鼠标右键
* ctrl + alt + backspace ： 重启会话
* super + l ： 锁定屏幕
* alt + f7 ： 激活移动窗口功能，方向键移动，enter键确定
* alt + enter ： 显示文件属性

# [Linux文件存储结构，包括目录项、inode、数据块](http://c.biancheng.net/cpp/html/2780.html)



# nohup 和 & 后台执行 [转载](http://blog.csdn.net/zhang_red/article/details/52789691)
* nohup是永久执行
* & 是指在后台运行
* 就是指，用nohup运行命令可以使命令永久的执行下去，和用户终端没有关系，例如我们断开SSH连接都不会影响他的运行，注意了nohup没有后台运行的意思；&才是后台运行
* 那么，我们可以巧妙的吧他们结合起来用就是 `nohup COMMAND &`这样就能使命令永久的在后台执行
* nohup执行后，会产生日志文件，把命令的执行中的消息保存到这个文件中，一般在当前目录下，如果当前目录不可写，那么自动保存到执行这个命令的用户的home目录下，例如root的话就保存在/root/下
*  `nohup --help` 输出如下：
```sh
Usage: nohup COMMAND [ARG]...
  or:  nohup OPTION
Run COMMAND, ignoring hangup signals.

      --help     display this help and exit
      --version  output version information and exit

If standard input is a terminal, redirect it from /dev/null.
If standard output is a terminal, append output to `nohup.out' if possible,
`$HOME/nohup.out' otherwise.
If standard error is a terminal, redirect it to standard output.
To save output to FILE, use `nohup COMMAND > FILE'.
```
# man
在Research UNIX、BSD、OS X 和 Linux 中，手册通常被分为8个区段，安排如下：

区段	说明  
1	一般命令   
2	系统调用   
3	库函数，涵盖了C标准函数库  
4	特殊文件（通常是/dev中的设备）和驱动程序  
5	文件格式和约定  
6	游戏和屏保  
7	杂项  
8	系统管理命令和守护进程  
要查看相应区段的内容，就在 man 后面加上相应区段的数字即可，如：  

$ man 3 printf


通常 man 手册中的内容很多，你可能不太容易找到你想要的结果，不过幸运的是你可以在 man 中使用搜索，/<你要搜索的关键字>，查找到后你可以使用n键切换到下一个关键字所在处，shift+n为上一个关键字所在处。使用Space(空格键)翻页，Enter(回车键)向下滚动一行，或者使用j,k（vim编辑器的移动键）进行向前向后滚动一行,按f 或 space 向下翻一页,按b向前翻一页, F 实时刷新。按下h键为显示使用帮助(因为man使用less作为阅读器，实为less工具的帮助)，按下q退出。
* m 小写字母   加书签
* '(单引号) 小写字母  引用书签
* :e 打开另一个文件；：n 下一个文件； ：p 上一个文件

想要获得更详细的帮助，你还可以使用info命令，不过通常使用man就足够了。如果你知道某个命令的作用，只是想快速查看一些它的某个具体参数的作用，那么你可以使用--help参数，大部分命令都会带有这个参数
# 作业管理
1. 将“当前”作业放到后台“暂停”：  
ctrl+z
 
2. 观察当前后台作业状态：jobs  
参数：  
 -l 除了列出作业号之外同时列出PID    
 -r：列出仅在后台运行（run）的作业  
 -s：仅列出暂停的作业  
 
3. 将后台作业拿到前台处理：fg   
 fg %jobnumber (%可有可无)
 
4. 让作业在后台运行：bg  
ctrl+z让当前作业到后台去暂停，bg 作业号就可以在后台run
 
5. 管理后台作业：kill  
我们可以让一个已经在后台的作业继续执行，也可以让该作业使用fg拿到前台。如果直接删除该作业，或者让作业重启，需要给作业发送信号。  
`kill -signal %jobnumber `  
参数：  
-l 列出当前kill能够使用的信号  
signal：表示给后台的作业什么指示，用man 7 signal可知  
>-1（数字）：重新读取一次参数的设置文件（类似reload）  
-2：表示与由键盘输入ctrl-c同样的动作  
-9：立刻强制删除一个作业  
-15：以正常方式终止一项作业。与-9不一样。  

6. 特殊参数!，将扩展为最近执行的后台命令的进程号   
`echo $!`
# find
### 1. 注意 find 命令的路径是作为第一个参数的， 基本命令格式为  
find [path] [option] [表达式] [action]
### 2. 使用
* 指定目录下搜索指定文件名的文件：  
$ find /etc/ -name "通配符表达式"
* 通过正则匹配   
`find . -regex ".*\(\.txt\|\.pdf\)$"`   
`-iregex 忽略大小写`
* 限定路径层级   
`find . -maxdepth 1 -iname '*mongo*'`

* 通过文件类型   
`find . -type f` 文件类型     
`find . -type d` 文件夹    
-type b/d/c/p/l/f	匹配文件类型（后面的字幕字母依次表示块设备、目录、字符设备、管道、链接文件、文本文件）

* -size	匹配文件的大小（+50k为查找超过50k的文件，而-50M为查找小于50M的文件）
* Find files matching more than one search criteria:  
`find {{root_path}} -name '{{*.py}}' -or -name '{{*.r}}'`
* Find files matching a given pattern, while excluding specific paths:
`find {{root_path}} -name '{{*.py}}' -not -path '{{*/site-packages/*}}'`
* Find files matching path pattern:
`find {{root_path}} -path '{{**/lib/**/*.ext}}'`
* 与时间相关的命令参数：

参数	说明
-atime	最后访问时间  
-ctime	创建时间  
-mtime	最后修改时间  
下面以-mtime参数举例：   

-mtime n: n 为数字，表示为在n天之前的”一天之内“修改过的文件   
-mtime +n: 列出在n天之前（不包含n天本身）被修改过的文件  
-mtime -n: 列出在n天之内（包含n天本身）被修改过的文件  
newer file: file为一个已存在的文件，列出比file还要新的文件名    
-newer f1 !f2	匹配比文件f1新但比f2旧的文件

列出 home 目录中，当天（24 小时之内）有改动的文件：  

$ find ~ -mtime 0  
列出用户家目录下比Code文件夹新的文件：  

$ find ~ -newer /home/shiyanlou/Code
* -perm	匹配权限（mode为完全匹配，-mode为包含即可）
* -user	匹配所有者
* -group	匹配所有组

* find . -type f -name "*.png" -exec rm -f {} \;
### 参考
* [find 文档](http://man.linuxde.net/find "find")
* [Linux 命令行：find 的 26 个用法示例](http://www.codebelief.com/article/2017/02/26-examples-of-find-command-on-linux/)


# 文件压缩
## zip unzip 
* 安装 
`yum install -y unzip zip`
* zip   
-r 递归打包 -o 输出文件，其后紧跟打包输出文件名 -q安静模式 -【1-9】压缩级别，默认为最高9  -x 排除文件不压缩，只能使用绝对路径，否则不起作用。  
zip -r -9 -q -o shiyanlou_9.zip /home/shiyanlou -x ~/*.zip
* -e 加密 -l参数将LF转换为CR+LF 兼容windows  
* unzip -d 目标目录 -l 不解压只查看压缩包内容 -O（大写） 指定编码  -o  overwrite existing files without prompting -j     junk paths.  The archive's directory structure is not recreated; all files are deposited in the extraction directory (by default, the current one).
```sh 
unzip -q shiyanlou.zip -d ziptest  
unzip -l shiyanlou.zip  
unzip -O GBK 中文压缩文件.zip 
``` 
## rar
rar a 添加一个目录  
d删除某个文件   
l 查看不解压    
rar a shiyanlou.rar .  
rar d shiyanlou.rar .zshrc  
rar l shiyanlou.rar  
unrar x 全路经解压  e 去掉路径解压  
unrar x shiyanlou.rar  
mkdir tmp  
$ unrar e shiyanlou.rar tmp/  

## tar 
tar -c 创建一个tar包 -f指定创建的文件名 -v可视化输出打包文件（默认去掉前面的绝对路径/使用-P保留绝对路径） 解包一个文件(-x参数)到指定路径的已存在目录(-C参数)：  只查看不解包文件-t参数, r 追加文档到tar文件尾部.  
保留文件属性和跟随链接（符号链接或软链接），有时候我们使用tar备份文件当你在其他主机还原时希望保留文件的属性(-p参数)和备份链接指向的源文件而不是链接本身(-h参数)：

tar -cf shiyanlou.tar ~  
mkdir tardir  
$ tar -xf shiyanlou.tar -C tardir  
tar -tf shiyanlou.tar  
tar -cphf etc.tar /etc  
tar -rvf shiyanlou.tar file_extra.txt  
我们只需要在创建 tar 文件的基础上添加-z参数，使用gzip来压缩/解压缩文件：  
压缩文件格式	参数  
*.tar.gz	-z  
*.tar.xz	-J  
*tar.bz2	-j  
  
tar -czf shiyanlou.tar.gz ~  
tar -xzf shiyanlou.tar.gz  

* --exclude 命令排除打包的时候，不能加“/”；直接跟目录名，不用加相对、绝对目录

tar -zcvf tomcat.tar.gz --exclude=tomcat/logs --exclude=tomcat/libs --exclude=tomcat/xiaoshan.txt tomcat


### du
--max-depth（所查看文件的深度）  
-s    summarize
```sh
du -h --max-depth=1 dir # 只显示指定目录中文件和目录大小，不显示子目录内容。另外会显示该目录的汇总大小
du -sh      # 显示当前目录总的大小信息，不显示该目录下文件和子目录的大小信息
du -sh ./*
```

### uniq
* 用于移除或发现文件中重复的条目 -u / -d

### tr
* tr 命令用于转换字符、删除字符和压缩重复的字符。它从标准输入读取数据并将结果输出到标准输出。 
* tr a-z A-Z
* tr -s [:space:] '\t'
* tr -d a-z
* tr -cd a-z  删除指定的字符外的其他字符
### ln [创建链接：官方文档](http://man.linuxde.net/ln)

* Linux具有为一个文件起多个名字的功能，称为链接。被链接的文件可以存放在相同的目录下，但是必须有不同的文件名，而不用在硬盘上为同样的数据重复备份。另外，被链接的文件也可以有相同的文件名，但是存放在不同的目录下，这样只要对一个目录下的该文件进行修改，就可以完成对所有目录下同名链接文件的修改。对于某个文件的各链接文件，我们可以给它们指定不同的存取权限，以控制对信息的共享和增强安全性。

* 文件链接有两种形式，即硬链接和符号链接。
### 查看当前服务和监听端口  `sudo netstat -atunlp | grep mongo`
### ubuntu 修改主机名
```
//查看主机名
topcom@master:~$ hostname
master
//永久修改
vim /etc/hostname
```
### 复制符号连接，保留文件属性，递归操作 -dpr
`cp -av source dest`

### 查看硬链接ln关联的所有文件及路径  
```bash
ls -i  myInfo.txt
3814056 myInfo.txt
find / -inum 3814056
/home/homer/me/myInfo.txt
/home/homer/me/.me/myInfo.txt_ln
/home/homer/bin/myInfo.txt
```

## jdk install
我们把JDK安装到这个路径：/usr/lib/jvm
如果没有这个目录（第一次当然没有），我们就新建一个目录

cd /usr/lib
sudo mkdir jvm
建立好了以后，我们来到刚才下载好的压缩包的目录，解压到我们刚才新建的文件夹里面去，并且修改好名字方便我们管理

sudo tar zxvf ./jdk-7-linux-i586.tar.gz  -C /usr/lib/jvm
cd /usr/lib/jvm
sudo mv jdk1.7.0_05/ jdk7

 * 配置环境变量

gedit /etx/profile

在打开的文件的末尾添加

export JAVA_HOME=/usr/lib/jvm/jdk7


export JRE_HOME=${JAVA_HOME}/jre

export CLASSPATH=.:${JAVA_HOME}/lib:${JRE_HOME}/lib:$CLASSPATH


export PATH=${JAVA_HOME}/bin:$PATH

保存退出，然后输入下面的命令来使之生效

source ~/.bashrc

 * 配置默认JDK

由于一些Linux的发行版中已经存在默认的JDK，如OpenJDK等。所以为了使得我们刚才安装好的JDK版本能成为默认的JDK版本，我们还要进行下面的配置。
执行下面的命令：

sudo update-alternatives --install /usr/bin/java java /usr/lib/jvm/jdk7/bin/java 300


sudo update-alternatives --install /usr/bin/javac javac /usr/lib/jvm/jdk7/bin/javac 300

 注意：如果以上两个命令出现找不到路径问题，只要重启一下计算机在重复上面两行代码就OK了。

执行下面的代码可以看到当前各种JDK版本和配置：

sudo update-alternatives --config java

 * 测试

打开一个终端，输入下面命令：

java -version

显示结果：

java version "1.7.0_05"
Java(TM) SE Runtime Environment (build 1.7.0_05-b05)


Java HotSpot(TM) Server VM (build 23.1-b03, mixed mode)

这表示java命令已经可以运行了。
## uniq
> 管道过滤唯一字符  

## ln [创建链接：官方文档](http://man.linuxde.net/ln)
## 查看当前服务和监听端口  `sudo netstat -atunlp | grep mongo`
## ubuntu 修改主机名
```
//查看主机名
topcom@master:~$ hostname
master
//永久修改
vim /etc/hostname
```
## 复制符号连接，保留文件属性，递归操作 -dpr
`cp -av source dest`

## 查看硬链接ln关联的所有文件及路径  
```bash
ls -i  myInfo.txt
3814056 myInfo.txt
find / -inum 3814056 
/home/homer/me/myInfo.txt
/home/homer/me/.me/myInfo.txt_ln
/home/homer/bin/myInfo.txt
```
## strings 命令
* 在对象文件或二进制文件查找可打印的字符串
`Print all strings in a binary: strings file`
`strings /usr/lib64/libssl.so |grep OpenSSL`

## 修改max open files（参考：http://blog.csdn.net/alibert/article/details/50915123）
* 使用ulimit -a 可以查看当前系统的所有限制值，使用ulimit -n 可以查看当前的最大打开文件数。
* 使用 ulimit -n 65535 可即时修改，但重启后就无效了。（注ulimit -SHn 65535 等效 ulimit -n 65535，-S指soft，-H指hard)

有如下三种修改方式：

1. 在/etc/rc.local 中增加一行 ulimit -SHn 65535
2. 在/etc/profile 中增加一行 ulimit -SHn 65535
3. 在/etc/security/limits.conf最后增加如下两行记录
* soft nofile 65535

* hard nofile 65535

具体使用哪种，试试哪种有效吧，我在 CentOS中使用第1种方式无效果，使用第3种方式有效果，而在Debian中使用第2种有效果

其实CentOS ulimit命令本身就有分软硬设置，加-H就是硬，加-S就是软默认显示的是软限制，如果运行CentOS ulimit命令修改的时候没有加上的话，就是两个参数一起改变.生效
修改完重新登录就可以见到.(我的系统是CentOS5.1.修改了，重新登录后就立刻生效.可以用CentOS ulimit -a 查看确认.) 

即使是写在pam相关配置文件中的相关配置，也可能不是系统全局的。如果你想给某一个后台进程设置ulimit，最靠谱的办法还是在它的启动脚本中进行配置。无论如何，只要记得一点，如果相关进程的ulimit没生效，要想的是它的父进程是谁？它的父进程是不是生效了？  

ulimit参数中绝大多数配置都是root才有权限改的更大，而非root身份只能在现有的配置基础上减小限制。如果你执行ulimit的时候报错了，请注意是不是这个原因。

ulimit – l 32；限制最大可加锁内存大小为 32 Kbytes。

## 常用端口和名字的对应关系可在linux系统中的/etc/services文件中找到

## 快速清空文件内容
```sh
$ : > filename 
$ > filename 
$ echo "" > filename 
$ echo > filename 
$ cat /dev/null > filename
```
# Linux SSH终端terminal配色更改为256色
* 查看当前终端类型：  
echo $TERM   
xterm-color
* 查看当前服务器终端色彩：  
tput colors  
8 
* 配置Linux终端如果支持就调整为256色终端，添加到.bashrc文件内。  
```sh
if [ -e /usr/share/terminfo/x/xterm-256color ]; then
#debian在/lib/terminfo/x/xterm-256color
        export TERM='xterm-256color'
else
        export TERM='xterm-color'
fi
```
* 如不支持xterm-256color安装：  
apt-get install ncurses-base  
yum install ncurses

# 用户可以用chmod指令来为文件设置强制位与冒险位。

强制位有：setuid和setgid，主要用于文件及目录  
冒险位有：sticky，只用于目录，多数是共享目录

– set uid：chmod u+s 文件名

– set gid：chmod g+s 文件名

– sticky：chmod o+t 文件名

*  强制位与冒险位也可以通过一个数字加和，放在读写执行的三位数字前来指定。

– 4(set uid)

– 2(set gid)

– 1(sticky)

设置s u i d / g u i d

命令 结果 含义

chmod 4755 -rwsr-xr-x suid、文件属主具有读、写和执行的权限，所有其他用户具有读和执行的权限

chmod 6711 -rws--s--x suid、sgid、文件属主具有读、写和执行的权限，所有其他用户具有执行的权限

chmod 4511 -rwS--x—x suid、文件属主具有读、写的权限，所有其他用户具有执行的权限

上面的表中有具有这样权限的文件：rwS --x -- x，其中S为大写。它表示相应的执行权限位并未被设置，这是一种没有什么用处的suid设置可以忽略它的存在。

注意，chmod命令不进行必要的完整性检查，可以给某一个没用的文件赋予任何权限，但 chmod 命令并不会对所设置的权限组合做什么检查。因此，不要看到一个文件具有执行权限，就认为它一定是一个程序或脚本。

## 端口是否占用
* `ss -pl |grep 8002`
* `lsof -i :8002`
* netstat -atunlp |grep 8002

## 测试ip和端口是否通
* wget ip:port
* ssh -v -p port ip

## ssh，scp免密登陆linux服务器&别名登陆

```sh
# 免密登录
# 1 本地使用指定用户生成公私钥
ssh-keygen -t rsa
# 连续按三次回车键，不需要输入密码,也可以指定邮箱-C "youremail@example.com"
# ~/.ssh/id_rsa.pub文件存在，会提示是否覆盖，如果不存在，则会生成该文件。

# 2 把公钥写入服务器指定用户主目录下~/.ssh/authorized_keys 文件中
ssh-copy-id root@192.168.200.67
or
scp ~/.ssh/id_rsa.pub root@192.168.200.67:~/.ssh
cat id_rsa.pub >> .ssh/authorized_keys

# 别名登录
# 1 在本地~/.ssh目录下新建config文件
vi ~/.ssh/config
# 2 写入下面配置

Host 67 

HostName 192.168.200.67

User root

IdentityFile ~/.ssh/id_rsa
#其中67是你设置的别名，192.168.200.67是你的服务器的公用ip，root是远程服务器的登录用户，IdentityFile是本地生成的私钥。这个地方一定不要弄成公钥

ssh 67 # 免密别名登录

```

## Linux下如何确认磁盘是否为SSD
* cat /sys/block/sda/queue/rotational进行查看，返回值0即为SSD；返回1即为HDD。
* lsblk -d -o name,rota
* lsscsi - list SCSI devices (or hosts) and their attributes
## sysctl命令被用于在内核运行时动态地修改内核的运行参数，可用的内核参数在目录/proc/sys中。它包含一些TCP/ip堆栈和虚拟内存系统的高级选项，用sysctl可以读取设置超过五百个系统变量。
```sh
sysctl命令
用法： 
sysctl [options] [variable[=value] …]

常用选项： 
-n：打印时只打印值，不打印参数名称； 
-e：忽略未知关键字错误； 
-N：打印时只打印参数名称，不打印值； 
-w：设置参数的值（不过好像不加这个选项也可以直接设置）； 
-p：从配置文件“/etc/sysctl.conf”加载内核参数设置； 
-a：打印所有内核参数变量； 
-A：以表格方式打印所有内核参数变量。

sudo sysctl -w net.core.rmem_max=212992
sysctl net.core.rmem_max
sysctl -a | grep rmem_max
echo "net.ipv4.ip_forward=1" >>/etc/sysctl.conf
sudo sysctl -p --system
```

## 手动释放cache

```sh

释放方法有三种（系统默认值是0，释放之后你可以再改回0值）：

To free pagecache:  echo 1 > /proc/sys/vm/drop_caches

To free dentries and inodes:  echo 2 > /proc/sys/vm/drop_caches

To free pagecache, dentries and inodes:  echo 3 > /proc/sys/vm/drop_caches

注意：在清空缓存前我们需要在linux系统中执行一下sync命令，将缓存中的未被写入磁盘的内容写到磁盘上
```

## iptables
防火墙会从上至下的顺序来读取配置的策略规则，在找到匹配项后就立即结束匹配工作并去执行匹配项中定义的行为（即放行或阻止）。防火墙策略规则的匹配顺序是从上至下的，因此要把较为严格、优先级较高的策略规则放到前面，以免发生错误.如果在读取完所有的策略规则之后没有匹配项，就去执行默认的策略。一般而言，防火墙策略规则的设置有两种：一种是“通”（即放行），一种是“堵”（即阻止）。当防火墙的默认策略为拒绝时（堵），就要设置允许规则（通），否则谁都进不来；如果防火墙的默认策略为允许时，就要设置拒绝规则，否则谁都能进来，防火墙也就失去了防范的作用。

iptables服务把用于处理或过滤流量的策略条目称之为规则，多条规则可以组成一个规则链，而规则链则依据数据包处理位置的不同进行分类，具体如下：

在进行路由选择前处理数据包（PREROUTING）；

处理流入的数据包（INPUT）；

处理流出的数据包（OUTPUT）；

处理转发的数据包（FORWARD）；

在进行路由选择后处理数据包（POSTROUTING）。

一般来说，从内网向外网发送的流量一般都是可控且良性的，因此我们使用最多的就是INPUT规则链，该规则链可以增大黑客人员从外网入侵内网的难度。

但是，仅有策略规则还不能保证社区的安全，保安还应该知道采用什么样的动作来处理这些匹配的流量，比如“允许”、“拒绝”、“登记”、“不理它”。这些动作对应到iptables服务的术语中分别是ACCEPT（允许流量通过）、REJECT（拒绝流量通过）、LOG（记录日志信息）、DROP（拒绝流量通过）。“允许流量通过”和“记录日志信息”都比较好理解，这里需要着重讲解的是REJECT和DROP的不同点。就DROP来说，它是直接将流量丢弃而且不响应；REJECT则会在拒绝流量后再回复一条“您的信息已经收到，但是被扔掉了”信息，从而让流量发送方清晰地看到数据被拒绝的响应信息。
```sh
-P	设置默认策略
-F	清空规则链
-L	查看规则链
-A	在规则链的末尾加入新规则
-I num	在规则链的头部加入新规则
-D num	删除某一条规则
-s	匹配来源地址IP/MASK，加叹号“!”表示除这个IP外
-d	匹配目标地址
-i 网卡名称	匹配从这块网卡流入的数据
-o 网卡名称	匹配从这块网卡流出的数据
-p	匹配协议，如TCP、UDP、ICMP
--dport num	匹配目标端口号
--sport num	匹配来源端口号

iptables -I INPUT -s 192.168.10.0/24 -p tcp --dport 22 -j ACCEPT
iptables -A INPUT -p tcp --dport 22 -j REJECT
```
## [firewall-cmd](https://jpopelka.fedorapeople.org/firewalld/doc/firewalld.richlanguage.html)
* sudo firewall-cmd --get-active-zones
firewall-cmd --list-all-zones
* sudo firewall-cmd --zone=public --list-all
* sudo firewall-cmd --list-rich-rules
* sudo firewall-cmd --get-services
* firewall-cmd --zone=public --add-port=3306/tcp --permanent
* firewall-cmd --zone=public --remove-port=12345/tcp --permanent
* 重启防火墙：firewall-cmd --reload
* 查看已经开放端口：firewall-cmd --list-ports



## 挂载硬件设备

* 拿到一块全新的硬盘存储设备后要先分区，然后格式化，最后才能挂载并正常使用  

`mount 文件系统 挂载目录`  
`umount [挂载点/设备文件]`

* mpfs是一种虚拟内存文件系统，而不是块设备。是基于内存的文件系统，创建时不需要使用mkfs等初始化，LINUX中可以把一些程序的临时文件放置在tmpfs中，利用tmpfs比硬盘速度快的特点提升系统性能
[参考](https://blog.csdn.net/haibusuanyun/article/details/17199617)

它最大的特点就是它的存储空间在VM(virtual memory)，VM是由linux内核里面的vm子系统管理的。
linux下面VM的大小由RM(Real Memory)和swap组成,RM的大小就是物理内存的大小，而Swap的大小是由自己决定的。
Swap是通过硬盘虚拟出来的内存空间，因此它的读写速度相对RM(Real Memory）要慢许多，当一个进程申请一定数量的内存时，如内核的vm子系统发现没有足够的RM时，就会把RM里面的一些不常用的数据交换到Swap里面，如果需要重新使用这些数据再把它们从Swap交换到RM里面。如果有足够大的物理内存，可以不划分Swap分区。
VM由RM+Swap两部分组成，因此tmpfs最大的存储空间可达（The size of RM + The size of Swap）。 但是对于tmpfs本身而言，它并不知道自己使用的空间是RM还是Swap，这一切都是由内核的vm子系统管理的。

tmpfs默认的大小是RM的一半，假如你的物理内存是1024M，那么tmpfs默认的大小就是512M
一般情况下，是配置的小于物理内存大小的。
tmpfs配置的大小并不会真正的占用这块内存，如果/dev/shm/下没有任何文件，它占用的内存实际上就是0字节；如果它最大为1G，里头放有100M文件，那剩余的900M仍然可为其它应用程序所使用，但它所占用的100M内存，是不会被系统回收重新划分的。
当删除tmpfs中文件，tmpfs 文件系统驱动程序会动态地减小文件系统并释放 VM 资源。

* 共享内存主要用于进程间通信，Linux有两种共享内存(Shared Memory)机制:

POSIX共享内存是基于tmpfs来实现的。实际上，更进一步，不仅PSM(POSIX shared memory)，而且SSM(System V shared memory)在内核也是基于tmpfs实现的。


## top
top -Hp 23344可以查看该进程下各个线程的cpu使用情况

## 进程启动时间
ps -p 24614 -o lstart

## crontab
crontab -u root -l


其一：/var/spool/cron/
该目录下存放的是每个用户（包括root）的crontab任务，文件名以用户名命名
其二：/etc/cron.d/
这个目录用来存放任何要执行的crontab文件或脚本。

1.  linux
看 /var/log/cron这个文件就可以，可以用tail -f /var/log/cron观察(不能用cat查看)
 
2.  unix
在 /var/spool/cron/tmp文件中，有croutXXX001864的tmp文件，tail 这些文件就可以看到正在执行的任务了。
 
3. mail任务
在 /var/spool/mail/root 文件中，有crontab执行日志的记录，用tail -f /var/spool/mail/root 即可查看最近的crontab执行情况。

sudo service crond start     #启动服务
sudo service crond stop      #关闭服务
sudo service crond restart   #重启服务
sudo service crond reload    #重新载入配置
sudo service crond status    #查看服务状态



## iconv
LANG="en_US.UTF-8"
file -i file.txt
iconv -f US-ASCII -t UTF-8//TRANSLIT fa.txt -o out.file

## native2ascii

native2ascii -reverse命令中-encoding指定的编码为源文件的编码格式。  
native2ascii 命令中-encoding指定的编码为（生成的）目标文件的编码格式  
对于纯数字和字母的文本类型文件（只有ASCII码），转码前后的内容是一样的

## docker 引擎日志

journalctl -l --no-pager -u docker |less 

## 查看那些程序使用tcp的80端口
fuser -v 80/tcp 80/udp


## 统计文件夹下文件个数，包括子文件

ls -lR | grep "^-" | wc -l


## iostat
iostat [参数] [间隔时间] [报告次数]  
https://shockerli.net/post/linux-tool-iostat/