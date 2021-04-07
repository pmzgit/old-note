## 基础

[sources.list](https://zzz.buzz/zh/2016/03/09/etc-apt-sources-list/)

[apt](https://www.sysgeek.cn/apt-vs-apt-get/)
```sh
apt-get clean  删除所有已下载的包文件

apt-get autoclean   删除已下载的旧包文件
apt autoremove
sudo apt purge
apt search virtualbox
apt show virtualbox
sudo apt full-upgrade
apt-cache show libc6
sudo apt-get install neofetch
```
[添加扩展源](https://niconiconi.fun/2018/12/31/debian-add-official-extension-source/)

[](https://mirror.tuna.tsinghua.edu.cn/help/debian/)

## 安装

```
sha256sum -b yourfile.iso
md5sum -b yourfile.iso
```
[uefi和gpt](https://blog.csdn.net/for_cxc/article/details/88984733)

[NVIDIA Optimus ](https://wiki.archlinux.org/index.php/NVIDIA_Optimus_(%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87))

[闭源显卡](https://bbs.deepin.org/forum.php?mod=viewthread&tid=192750&extra=)

[nvidia 官网](https://www.nvidia.cn/drivers/unix/)

* http://www.gmloc.me/57.html
* https://bbs.deepin.org/forum.php?mod=viewthread&tid=192750&extra=
* https://bbs.deepin.org/forum.php?mod=viewthread&tid=191741

* https://bbs.deepin.org/forum.php?mod=viewthread&tid=178542
```sh
/etc/modprobe.d/blacklist.conf
blacklist nouveau
sudo apt install gcc g++ make make-guile
gcc --version
g++ --version
make -v
sudo apt update
sudo apt install -t buster-backports nvidia-driver nvidia-smi nvidia-settings

lspci | grep -i vga

lspci | grep -i nvidia

nvidia-smi

```
/boot 分区 200m ext4 格式  
swap 分区，物理2倍

## 内核管理
```sh
dpkg -l | grep "linux-image\|linux-header"

#安装LTS内核

sudo apt install linux-image-deepin-amd64 linux-headers-deepin-amd64

#安装stable内核

sudo apt install linux-image-deepin-stable-amd64 linux-headers-deepin-stable-amd64

sudo apt purge linux-image-5.10.18-amd64-desktop linux-headers-5.10.18-amd64-desktop

# 开源维护桌面内核
https://xanmod.org/
```

### 自动时间同步
## 切换2D模式
* `Super + Shift + Tab`
* `sudo deepin-feedback-cli` 日志收集
## 设置root 密码
`sudo passwd root //设置root密码`
## dpkg
`dpkg -l openssh-client`   
`sudo dpkg -P shadowsocks-client`


## 搜狗拼音
```sh
sudo apt install sogoupinyin
sudo dpkg -i sogou.deb
sudo apt install -f
```

## 商店问题
```sh
rm ~/.cache/deepin/deepin-appstore* -rf && sudo apt update -y
apt list --upgradable
```
## [utools](https://u.tools/docs/guide/about-uTools.html)
alt+space
clear

## [flatpak](https://flatpak.org/setup/Debian/)

flatpak uninstall app

## [appimage](https://appimage.github.io/apps/)
* [doc](https://doc.appimage.cn/docs/wiki/)

## 终端环境之`oh-my-zsh`
### 深度终端 theme: one light
### 1. install `zsh`

## apt

```sh
sudo apt-get update --fix-missing
```

* 源码安装（貌似官方推荐安装最新的zsh）
* download: [官方源码zsh-5.5.1.tar.gz](http://zsh.sourceforge.net/Arc/source.html)   
* install:

```bash
//1. 解压
tar xzvf zsh-5.5.1.tar.gz
cd zsh-5.5.1/
//2. 编译安装
sudo ./configure // 提示缺少以下依赖库，先安装
sudo `apt-get install libncurses5-dev`
make
sudo make install //不知道为什么网上有的教程不加sudo？？
(3. 这个版本无此情况：可以查看zsh版本，但是我编译安装后，安装到/usr/local/bin/zsh 不知道为什么，所以一系列的坑由此开始。。。
zsh --version //提示zsh 不在/usr/bin/zsh 位置，当然不在
cd /usr/local/bin/ //到这个目录后 执行 `./zsh` 成功进入zsh，)但首次执行会提示`.~/.zshrc` 不存在，所以你看到的界面貌似是zsh添加这个配置文件的程序，可以直接退出，因为后面的oh-my-zsh 会替换这个配置文件 
//4. make zsh your default shell 用`chsh`命令
//首先你可以查看ubuntu里面都安装了哪些shell
cat /etc/shells
chsh -s $(which zsh) //fail，因为zsh并没有添加到上面那个文件里
//所以zsh必须添加到`/etc/shells`里，才能把zsh改成登陆用户默认的shell
sudo vim /etc/shells // 添加`/usr/local/bin/zsh`
chsh -s $(which zsh) //输入密码 
// 重启系统，打开shell 你会看到已经进入到zsh
echo $SHELL // 查看当前正在运行的shell
=/usr/local/bin/zsh
```

* 参考：[install zsh](https://github.com/ohmyzsh/ohmyzsh/wiki/Installing-ZSH)
 
### 2. 使用`oh-my-zsh`的配置文件  
```bash
// 执行下面命令
sh -c "$(wget https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"
```

* 参考:[github oh-my-zsh](https://github.com/robbyrussell/oh-my-zsh)
* 需要提前安装git

### tmux 
* `sudo apt-get install tmux`
* 使用 见`./tmux.md`

### git
* sudo apt-get install git
* git clone git@github.com:pmzgit/note.git
### [官网](https://www.syntevo.com/smartgit/download/)
* [deepin 仓库](https://wiki.deepin.org/index.php?title=SmartGit) 
* `sudo apt-get install smartgit`
* 安装后jdk 指向jdk9 ，但是仓库版本（17.1）只能用jdk8 所以用sudo update-alternatives --config java 重新指向jdk8
* [破解](https://www.jianshu.com/p/79ff2d63ddc6)
* github auth `b0dadc04b6fc856a6a75` linux `42e22f76d67d2f145ee7` win7
* [环境变量http_proxy/https_proxy代理问题](https://blog.csdn.net/a1059682127/article/details/78632900)

### telnet

sudo apt-get install telnet

### vsc
* [官网](https://code.visualstudio.com/) 
* `dpkg -i vsc.deb`
* 快捷键 见 `../tool/tools.md`

### [note](https://github.com/pmzgit/note.git)
* 自己的笔记库
### [dotfiles](https://github.com/pmzgit/dotfiles.git)
* 自己的配置库
### 有道云笔记
* 还是老实用官方网页版吧 

### 文件、文件夹比较工具
* sudo aptitude install meld
### shadowsocks
* [github](https://github.com/loliMay/shadowsocks-client)
* sudo dpkg -i shadowsocks-client_1.2.1_amd64.deb ; sudo aptitude update &&  sudo aptitude full-upgrade

### [CopyQ](https://github.com/hluk/CopyQ/releases)
* ~~sudo dpkg -i copyq_3.6.1_Debian_9.0-1_amd64.deb~~
* ~~sudo aptitude install -f~~
* flatpak install --user --from https://flathub.org/repo/appstream/com.github.hluk.copyq.flatpakref  
flatpak run com.github.hluk.copyq

* ctrl+b 添加命令

### [Stacer](https://github.com/oguzhaninan/Stacer/releases)

### [dde-sys-monitor-plugin](https://github.com/q77190858/dde-sys-monitor-plugin)

### [freedownloadmanager](https://www.freedownloadmanager.org/zh/)

### [uget](https://ugetdm.com/)

### [rufus](https://rufus.ie/)

### [clockify](https://clockify.me/tracker)
### zeal 文档查看
* sudo apt-get install zeal
### lantern
* [releases](https://github.com/getlantern/lantern/releases/tag/latest)
* dpkg -i deb
* `lantern 命令失败，需要安装下面的包`
* `apt-cache search libappindicator3`
* `apt-get install libappindicator3-1`

### atom
* 商店

### vim
* vim --version
* vim —version 里如果有 xterm_clipboard 支持系统剪切板寄存器
* vim 配置见 `../tool/vim.md`
* 添加行号
```sh
" 注释
set nu
```
* sudo apt-get install vim-gui-common 能支持"+ 剪切板
* /usr/bin/vim .gvim
### teamviewer
* 商店

### anydesk
* sudo apt-get install -f
### jdk
* mkdir /usr/lib/jvm
* 下载jdk tar 文件
* sudo tar xzvf jdk-8u172-linux-x64.tar.gz -C /usr/lib/jvm/
* sudo update-alternatives --install /usr/bin/java java /usr/lib/jvm/jdk1.8.0_172/bin/java 100
* sudo update-alternatives --install /usr/bin/javac javac /usr/lib/jvm/jdk1.8.0_172/bin/javac 100
* java -version
* javac -version
* update-altenativess --display java
* update-altenativess --config java
* sudo vim /etc/profile
```Shell
#java
export JAVA_HOME=/usr/lib/jvm/jdk1.8.0_201
export JRE_HOME=${JAVA_HOME}/jre
export CLASSPATH=${JAVA_HOME}/lib:${JRE_HOME}/lib
#export IDEA_JDK_64=/usr/lib/jvm/jdk1.8
#export IDEA_JDK=/usr/lib/jvm/jdk1.8
export SCALA_HOME=/home/pmz/Desktop/work/bd/scala-2.11.12
# maven
export MAVEN_HOME=/home/pmz/apache-maven-3.6.3

# tomcat
export TOMCAT_HOME=/home/pmz/code/apache-tomcat-8.0.52
export CATALINA_HOME=/home/pmz/code/apache-tomcat-8.0.52

export PATH=${PATH}:${JAVA_HOME}/bin:${MAVEN_HOME}/bin:$SCALA_HOME/bin:/usr/local/go/bin

```
* . /etc/profile // 使配置生效

### ssh  安装卸载 
 * `sudo apt-get install openssh-server`
* `sudo apt-get remove openssh-client`
* `sudo apt-get remove openssh-server`  
* 配置文件  
/etc/ssh/sshd_config  
PermitRootLogin yes # 允许root 登录
* 是否启动  
/etc/init.d/ssh status
### svn 客户端和服务端
* `sudo apt-get install subversion`
* 后边idea 需要用svn 命令行

### idea
* jdk8
* 直接运行jetbrains-toolbox
* file -> export setting 
* dotfiles 或者优盘导入配置
* 注意/etc/hosts

~~[本地服务器激活](http://blog.lanyus.com/archives/174.html)~~  
~~`/usr/local/bin/idea`~~  
~~sudo ./IntelliJIDEALicenseServer_linux_amd64~~ 
~~`./Downloads/idea-IU-163.12024.16/bin/idea.sh `~~

### tomcat
* 下载解压
* . /etc/profile // 配置环境变量，见上面，并运行此命令使配置生效
* idea 先配置tomcat
* /bin/Catalina.sh java_home
* tomcat-users.xml



### mysql
* sudo apt-get install mysql-server mysql-client
* /etc/mysql/my.conf 配置
* /var/lib/mysql 数据库文件 需要迁移
* /usr/bin/mysql mysql 的脚本都在这
* sudo service mysql status
* 密码 root
* sudo /usr/bin/mysqladmin -uroot -p shutdown
* sudo nohup /usr/bin/mysqld_safe &  启动

### redis-desktop-manager
```sh
sudo apt update
sudo apt install snapd
sudo snap install redis-desktop-manager
```
### [snap 使用](https://www.linuxidc.com/Linux/2018-05/152385.htm)

## wireshark
商店
## catfish
`sudo apt install catfish`

## 触摸板驱动
`synclient HorizTwoFingerScroll=1`
### navicat
* https://www.navicat.com/download/navicat-for-mysql
* sudo /opt/navicat112_mysql_en_x64/start_navicat

### wget
* http://man.linuxde.net/wget


### nvm
* https://github.com/creationix/nvm
* 安装 `curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.11/install.sh | bash`
* 使用 [用 apt-get 安装 node 和用 nvm 安装 node 的区别](https://www.jianshu.com/p/aab54ffdd060)
```sh
. ~/.nvm/nvm.sh
nvm ls-remote
nvm install 8.11.3
nvm ls
nvm use 
```
* => Close and reopen your terminal to start using nvm or run the following to use it now:

### yarn
* [安装](https://yarnpkg.com/zh-Hans/docs/install#debian-stable)
```sh
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -

echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list

sudo apt-get update

// 如果你使用nvm，可通过以下操作来避免node的安装

sudo apt-get install --no-install-recommends yarn

yarn --version

```
* 见 node.js.md

### [cerebro](https://github.com/KELiON/cerebro) **不推荐**

* 先安装nvm ，node，yarn
* 安装g++  
sudo apt-get install g++
* 安装
```sh
git clone https://github.com/KELiON/cerebro.git cerebro

cd cerebro && yarn && cd ./app && yarn && cd ../

// Run
yarn run dev
```
### [deepin-topbar](https://github.com/kirigayakazushin/deepin-topbar/wiki)
* https://github.com/SeptemberHX/dde-globalmenu-service

### [第三方开源软件列表](http://www.shenmo.tech:420/)
### nginx
* `apt-get install nginx`
* 配置文件地址 /etc/nginx/nginx.conf
注释掉默认配置
* 测试nginx配置文件
sudo nginx -t -c /etc/nginx/nginx.conf
* 测试通过，重启nginx服务器
/etc/init.d/nginx restart
### [ngrok](http://ngrok.ciqiuwl.cn/)
* 下载并解压，赋予执行权限
* `./ngrok -config=ngrok.cfg -subdomain 自己的自定义域名 80`
### lsof
* `sudo apt-get install lsof`


### aria2
* 安装 `apt-get install aria2`
* 用命令 `dpkg -L aria2` 可以查看安装到哪个目录了
* 安装好后，添加配置文件 aria2.conf
  [aria2 配置详解](http://aria2c.com/usage.html)
  [aria2.conf 示例文件](http://aria2c.com/archiver/aria2.conf)

### albert(亲测效果不行)
* http://www.ruanyifeng.com/blog/2013/07/gpg.html
* https://albertlauncher.github.io/docs/installing/
* alt+x
### teamviewer
* 商店
### 企业邮箱
* 网页版吧
### 企业微信，Tim
* 商店

### [postman](https://www.getpostman.com/apps)
* 解压直接执行根目录下的 Postman
* 或者  
`alias postman='sh -c "/home/pmz/soft/Postman/Postman"'`
### Redis Desktop Manager
* 商店
### Robo 3T
* 商店

### [motrix](https://motrix.app/)

### SecureCRT
* 官网下载，dpkg -i 安装
* 依赖安装`sudo apt install libjpeg8-dev`
* /usr/bin/SecureCRT 启动
* `sudo perl securecrt_linux_crack.pl /usr/bin/SecureCRT`
* 破解
```sh
	Name:		xiaobo_l
	Company:	www.boll.me
	Serial Number:	03-94-294583
	License Key:	ABJ11G 85V1F9 NENFBK RBWB5W ABH23Q 8XBZAC 324TJJ KXRE5D
	Issue Date:	04-20-2017
// 手动填写lisence
```
* 不能用vbs 脚本？那我安装它干嘛。。。。。

### [微信web开发](https://github.com/cytle/wechat_web_devtools) 
* [安装wine](https://wiki.deepin.org/index.php?title=Wine)
* [参考教程](https://www.cnblogs.com/cisum/p/7810346.html)
* [nwjs 下载地址](https://dl.nwjs.io/)

## 看图
* viewnior 商店

## [数据库建模](http://www.pdman.cn/#/)

## [rdesktop](http://vra.github.io/2017/02/18/rdesktop-share-file/)

## Remmina 商店

## [科学上网](https://noparkinghere.top/2017/01/25/2017/2017-01-25-ss-linux%E5%85%A8%E5%B1%80%E4%BB%A3%E7%90%86/)
# chrome 扩展
## [沙拉查词-网页划词翻译](https://github.com/crimx/crx-saladict/wiki)

## 谷歌访问助手 chrome 

## [Proxy SwitchyOmega](https://github.com/FelisCatus/SwitchyOmega/releases)
## 微博图床 

# 其他
* https://laod.cn/hosts/2018-google-hosts.html
*  `sudo systemctl restart NetworkManager`
* https://github.com/denjay/remote