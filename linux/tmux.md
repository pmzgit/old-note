# 参考 
[tmux github wiki](https://github.com/tmux/tmux/wiki)

[tmux 使用](http://harttle.com/2015/11/06/tmux-startup.html)

# 安装
## 编译安装（centos6.6）
### 1 下载依赖(最新版本)
* [libevent](http://libevent.org/)
* [ncurses](http://ftp.gnu.org/pub/gnu/ncurses/)
### 2 编译安装
```sh
分别解压。
tar xzvf libevent.tar.gz
进入 libevent 目录，分别执行以下命令：
sudo ./configure
sudo make
sudo make install
// 然后 ncurses ，tmux 都执行上述步骤，进行编译安装
```
### 测试是否成功
`tmux -V`  
可能会出现：
tmux: error while loading shared libraries: libevent-2.1.so.6: cannot open shared object file: No such file or directory   
解决办法：建立相应的symbol link  
`ln -s /usr/local/lib/libevent-2.1.so.6 /usr/lib64/libevent-2.1.so.6`
## yum 源安装
### 1. 添加remi 和 epel 源 (参考我之前的note)
### 2. `yum install tmux `
# 使用
* `prefix ?` 显示keymap
* `tmux kill-server` kill tmux server
## Session相关操作
* `tmux new -s name` 创建指定session名
* `<prefix> d` 退出(detach)当前session
* `tmux ls` 显示session 列表   
或 在tmux 中，用快捷键 `<prefix> s` 显示session 列表，上下方向键来切换session 
* `tmux a -t myname  (or at, or attach)` 进入某个session 
* `prefix $` 重命名当前Session 
或 prefix 加 ： 进入命令模式， 然后输入 `:new -s <session-name>`
* `tmux kill-session -t myname` kill session

## Window相关操作
* `	prefix c` 新建窗口
* `prefix &` 关闭一个窗口
* `prefix ,` 窗口重命名
* `prefix 窗口号` 使用窗口号切换
* `Prefix+p (p for previous)`切换到上一个window 
* `Prefix+n (n for next):` 切换到下一个window
* `Prefix+w (w for windows)` : 列出当前session所有window，通过上、下键可以选择切换到指定window。

## Pane相关操作
* `prefix o`切换到下一个窗格	
* 查看所有窗格的编号	prefix q
* `prefix "` 水平拆分出一个新窗格	
* `prefix % `垂直分出一个新窗格
* `Prefix+x `关闭当前使用中的pane。
* `refix+Space (空格键):` 对当前窗口下的所有pane重新排列布局，每按一次，换一种样式。 	
* `prefix z`暂时把一个窗体放到最大,再按一次后恢复。	

## 多屏操作 
默认情况下，一个window上只有一个pane被激活，接收键盘交互。但是某些场景下需要在多个pane中执行相同的操作，比如同时修改两台或更多台远程机器的nginx配置，这时候可以在分屏后按 Prefix+: 进入命令模式，输入 set synchronize-panes ，即可进入批量操作模式，要退出批量操作模式，再次输入 set synchronize-panes 即可。

## 个性配置
* 先按prefix，然后输入：，进入命令行模式，在命令行模式下输入：

`source-file ~/.tmux.conf`
* 推荐配置 [gpakosz](https://github.com/gpakosz/.tmux)

## [插件安装](https://github.com/tmux-plugins/tpm)

* [tmux-resurrect](https://github.com/tmux-plugins/tmux-resurrect)
* [tmux-continuum](https://github.com/tmux-plugins/tmux-continuum)

* 注意安装时耐心等待
