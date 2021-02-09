# Listary
* 启动  
    1. 文件管理器模式：直接输入 双击
    2. 启动器模式： ct 两下  
* 快捷键  
    ↓ 键 或 Ctrl + N：选择下一项；

    ↑ 键 或 Ctrl + P：选择上一项；

    → 键 或 Ctrl + O：打开选中项的动作菜单。

# mobaxterm

### keymap
* ctrl+shift+q 连接新session
* ctrl+alt+q 关闭
* ctrl+shift+f 搜索

# [热键冲突删除](https://github.com/BlackINT3/OpenArk)

# [cmder](https://github.com/cmderdev/cmder)
* https://cmder.net/
### 添加至右键菜单  [参考](http://www.cnblogs.com/zqzjs/archive/2016/12/19/6188605.html)

进入cmder的根目录执行注册要右键菜单即可。

C:\Windows\system32>d:

D:\>cd cmder

D:\cmder>Cmder.exe /REGISTER ALL

### 快捷键
* Ctrl + ` : Global Summon from taskbar
* shift + Alt + number : Fast new tab:
1. CMD
2. PowerShell
* ctrl + tab 切换窗口
* Ctrl + w : 与vim 冲突，建议修改[issues](https://github.com/cmderdev/cmder/issues/293)
* Win + Alt + T ：配置第一个bash as admin
### 设置中文显示
* set LANG=zh_CN.UTF-8

### [idea terminal](https://github.com/cmderdev/cmder/issues/282)

# svn
### 解除版本控制
* 在要解除版本控制的文件夹右键TortoiseSVN–>Export–>选择同一个文件夹（目标文件夹一定要和你右击的文件夹是同一个文件夹），这时就会出现“是否解除版本控制”的对话框。 

#  Atom
### setting
1. Editor tab length 设置为4
### Packages

1. atom-beautify
2. vim-mode-plus and ex-mode (可以添加esc键映射)  
```
'atom-text-editor.vim-mode':
        'escape': 'vim-mode:reset-normal-mode'
```
3. terminal-plus
4. emmet  `tab` `ctrl+e`
5. autocomplete-plus `ctrl+space` 已内置，主插件
6. linter `语法检查主插件`
7. linter-jshint `javascript+json`
8. git-plus
9. copy-as-rtf 转换成富文本格式到剪切板

### thems
1. atom-material-ui
2. seti-ui

### 快捷键（vim插件环境下）
* 注释 ctrl+/


#  idea
### 字体 Droid Sans Mono
### jetbrains toolbox 路径  
`C:\Users\pmz\AppData\Local\JetBrains\Toolbox`
### 中文乱码
* [参考](http://blog.csdn.net/u013361445/article/details/51113692)
* [参考](http://blog.csdn.net/frankcheng5143/article/details/50779149)
### 坚果云配置（${idea.home}/bin/idea.properties）
* acejump Ctrl+ALT+; target word
* Find Action Ctrl+Shift+A
    1. Search everywhere   跳转到任意地方  
    2. java class 新建java类
    3. fix doc 添加java注释
* [背景护眼色](https://blog.csdn.net/sunhuaqiang1/article/details/62222225)
* [智能提示忽略大小写](https://blog.csdn.net/gaoqiao1988/article/details/73299670)
* Postfix
    1. sout: println
    2. psvm: main
    3. collections.for: forEach
* TranslationPlugin 翻译
* jrebel [参考](http://blog.csdn.net/garfielder007/article/details/53591480)
    
    1. [plugin download](https://plugins.jetbrains.com/plugin/4441-jrebel-for-intellij)
    2. 激活 
    [使用Facebook 注册登陆后得到激活码](https://my.jrebel.com/account/how-to-activate)
    3. 使用
        * http://blog.lanyus.com/archives/133.html
        * 设置 on frame deactivation 为 Update classes and resources
        * [usage1](https://zeroturnaround.com/software/jrebel/quickstart/intellij/?run=ide#!/project-configuration)  
        * [usage2](http://manuals.zeroturnaround.com/license-server/install/index.html#getting-started)  
        * [maven project-configuration](http://manuals.zeroturnaround.com/jrebel/standalone/maven.html)     
    4. tomcat server.xml 的配置
    <Context path="/helloapp" docBase="helloapp" reloadable="true"/>
    5. C:\Users\PMZMS\AppData\Roaming\JetBrains\IntelliJIdea2020.1 
* 注意
一般Jrebel有15天免费试用期，不过Jrebel对于个人是免费的，在Google上搜索myJrebel然后注册就会送个人免费注册码，   
传送带：https://my.jrebel.com/
* spring boot
http://www.jianshu.com/p/97dd8978482f
* 破解  
    https://zhile.io/2020/11/18/jetbrains-eval-reset.html
    https://zhile.io/2018/08/18/jetbrains-license-server-crack.html  
    https://www.macwk.com/article/jetbrains-crack  
    http://idea.medeming.com/jet/  
    http://idea.medeming.com/jets/ 
    https://www.ghpym.com/ideapatch.html  
    https://shop.fulishe.io/product

### idea 设置cmder

"cmd.exe" /k ""E:\soft\cmder\vendor\init.bat""

## keymap(eclipse 模式)  

alt + insert ： getter and setter    
Ctrl+E，可以显示最近编辑的文件列表  
ctrl+alt+v 生成变量名 比较有用 冲突自定义成n  
CTRL+H 全局文本查找  
CTRL+O 显示类结构  
ctrl+F9 编译整个项目  
ctrl+shift+F9 编译当前文件  
Ctrl+T，接口方法的实现  
Alt+左方向键 返回上一个编辑位置，相反亦然  
Ctrl+Tab 打开idea各种panel 例如terminal，maven   
Ctrl+F12，可以显示当前文件的结构    
Ctrl+N，可以快速打开类  
Ctrl+Shift+N，可以快速打开文件  
Ctrl+W可以选择单词继而语句继而行继而函数  
Ctrl+P，可以显示参数信息  
CTRL+SHIFT+ALT+N 查找类中的方法或变量  
CTRL+G 查找调用栈  
CTRL+R 在 当前窗口替换文本  
F3 向下查找关键字出现位置  
SHIFT+F3 向上一个关键字出现位置  
F4 查找变量来源  
CTRL+D 剪切,删除行   
CTRL+/ 注释//  
CTRL+SHIFT+/ 注释/*...*/  
ctrl+shift+f11 添加、删除书签
shift+f11 显示
F11 mark  

##  keymap win自带  

Ctrl+Alt+O     自动删除未使用的import  
Ctrl+N     搜索class类文件  
Ctrl+Shift+N     打开文件、搜索文件  
ctrl+alt+左方向键 返回上一个编辑位置，相反亦然    
Ctrl+Shift+下键     向下移动当前行    
Ctrl+Shift+上键     向上移动当前行     
Ctrl+F12     打开方法列表，快速搜索类方法  
Ctrl+G     跳转到指定行  
Ctrl+/     注释/取消注释当前行  
Ctrl+Shift+/     注释/取消注释(多行，注释时选中要注释的代码，取消注释时，光标在注释内任意位置即可)  
Ctrl+Alt+空格     打开代码提示  
ctrl+alt+v 生成变量名 比较有用 冲突自定义成n    
Ctrl+Shift+R     全局文件替换  
Ctrl+Alt+L     格式化代码  
shift+f6 重命名
alt+f7 调用栈  
alt+f8 热执行   
Ctrl+Shift+f9 编译单文件      
ctrl+f9 编译项目   
Ctrl+Shift+f10 运行光标所在测试用例   
CTRL+SHIFT+a action  
ctrl+shift+t find in path   
shift+f11 显示  
Ctrl+f5 重启服务 
alt+4 run模式下，日志面板打开关闭  
alt+5 debug模式下，日志面板打开关闭  
F11 mark 添加、删除书签  
F8     单步调试   
F9     跳到下一断点或结束调试    
F7     单步进入    
Alt+鼠标选择       列选择模式，按列选择  
Ctrl+Alt+Shift+] run anything
* debug keymap
> f6 下一步  
  f9 下一个断点

### 阿里巴巴 规约插件
* Ctrl+Shift+Alt+J 触发代码扫码

### 重建项目索引

文件 – >无效缓存

# [diagram](https://www.cnblogs.com/deng-cc/p/6927447.html)

显而易见的是：  
蓝色实线箭头是指继承关系  
绿色虚线箭头是指接口实现关系  

# GsonFormat
alt+s
# vsc
## 官方同步token
vscode://vscode.github-authentication/did-authenticate?windowId=1&code=e8cecc14b7bfec337cf3&state=29fa562b-8050-49d6-93e3-ec78426f215e
### 快捷键
* ALT+Z wordwrap
* 文管 c+e
* 全局搜索 C+Sh+f
* git c+sh+g
* debug c+sh+d
* 扩展 c+sh+x
* 预览 c+k v
* 格式化 c+k c+f
* getter，setter alt+insert
* go to line c+g

## vscode set sync
### 插件
Settings Sync 

Gist 可以保存上传的配置文件。拉取配置文件需要配置两个 id，一个是 Gist Id，一个是 Token Id。这两个 Id 前者标识配置文件，后者用于身份验证。我们无法下载的原因就是我们使用单单在 Sync:Download Settings 命令中使用了 Gist id，所以错误提示才是无效的 token。

还是在 VSCode 中输入命令：Sync:Advanced Options，然后选择 Sync:Edit Extension Local Settings，编辑 syncLocalSettings.json 这个配置文件。这个文件中有一项 token 没有设置（或者是配置的就是以前的过期的token），这里就需要设置为 Token Id

https://github.com/settings/tokens  
https://gist.github.com/<username>/<gist id>

GitHub Token: 5b6b532a5fcf33ced126616018a92035feb08860  
GitHub Gist: 694aa154205abde64f89e46b81d3c007  
GitHub Gist Type: Secret  


code setting sync  gitee

token: bc29761cf4a9b07f630dcda96ed66d16

gist id: ez4tvxshcy9gr5j06m78u47

* json-tools

C+A+m

## gist host
192.30.253.118 gist.github.com

### 覆盖默认配置
* "editor.wordWrap": "on", 自动换行
* window.titleBarStyle custom

### https://marketplace.visualstudio.com/items?itemName=Shan.code-settings-sync

### win 下git.path
`D:\\soft\\cmder\\vendor\\git-for-windows\\bin\\git.exe`

# chrome plugins
* 划词翻译   ctrl+q
* colorZilla   提取css颜色 ctrl + alt + z  与qq冲突
* pageRuler  
 General Shortcuts
ctrl + P: Enable / Disable Page Ruler  与chrome冲突  需单独设置
Toolbar Inputs
Up Key: Increase the value by 1
+ Shift: Increase the value by 10
Down Key: Decrease the value by 1
+ Shift: Decrease the value by 10
Ruler
Arrow keys: Move the ruler by 1 pixel in any direction
+ Shift: Move the ruler by 10 pixels
+ Ctrl (Command): Expand the ruler outwards by 1 pixel
+ Shift + Ctrl (Command): Expand the ruler outwards by 10 pixels
+ Ctrl (Command) + Alt: Shrink the ruler inwards by 1 pixel
+ Shift + Ctrl (Command) + Alt: Shrink the ruler inwards by 10 pixels
* cssviewer    chrome单独设置  alt+v
# win softwire
* dev  
    1. Git  
    2. vscode  
    3. jdk  
    4. tomcat  
    5. maven  
    6. idea  
        config  
    7. mysql  
    8. datagrip  
    9. xshell  
    10. chromego  
    10. rdm  
    14. svn  
    15. smartgit

* user  
    1. zip
    2. compare  
    3. fscapcher  
    4. wiz evernote  
    5. idm  
    6. potplayer  
    9. histary  
    10. tim ctrl+alt+Q 屏幕识图 录屏  
    11. teamviewer  
    12. youdaodic 
    13. xmind
    14. office wps  
    18. VC REDIST INSTALLER  
    19. clower
    20. ccleaner

# window path
```dos
Path=D:\soft\install\python\;  
D:\soft\install\python\Scripts;  
C:\Windows\system32;  
C:\Windows;C:\Windows\System32\Wbem;   
C:\Windows\System32\WindowsPowerShell\v1.0\;  
D:\soft\install\Vim\vim74;  
C:\Program Files (x86)\Spoon\Cmd;D:\soft\install\apache-maven-3.3.9\bin;
D:\soft\install\SVN\bin;
D:\soft\install\java\jdk\bin;
C:\Android;
D:\soft\install\Git\cmd;D:\soft\package\nodejs\;
D:\soft\install\gradle-2.10\bin;
D:\soft\install\Tesseract-OCR;
D:\me\redis;
C:\Windows\system32;
C:\Windows;C:\Windows\System32\Wbem;C:\Windows\System32\WindowsPowerShell\v1.0\;
D:\soft\install\Vim\vim74;  
C:\Program Files (x86)\Spoon\Cmd;
D:\soft\install\SVN\bin;
D:\soft\package\mysql-5.5\bin;
C:\Program Files (x86)\QuickTime\QTSystem\;
D:\soft\install\svn\bin;
C:\Users\Administrator\AppData\Local\atom\bin;
C:\Users\Administrator\AppData\Roaming\npm;C:\Program Files (x86)\Microsoft VS Code\bin
```
# win10
* win+shift+s  和 ctrl + shift + printscreen 截屏
* win+空格 切换输入法
* Ct + Sh + b 表情 ct + 方向键 切换
* cmd 支持 ct+v
* win+g 录屏
* Win + Ctrl + D 虚拟桌面
* win+tab 任务视图
* Win+A 操作中心
* Win+S cortana
* Win+I 设置面板
* Win+X 
* Win+K 无线设备搜索
* Win+P 投影
* Win+↑/↓/←/→ 固定并移动窗口
* Alt+↑/←/→ 文件导航
* Alt+空格+N 最小化 r 还原 x最大化

# [firefox](https://ftp.mozilla.org/pub/firefox/releases/84.0.2/win64/zh-CN/)

## [How-To-Speed-Github](https://code.pingbook.top/blog/2020/How-To-Speed-Github.html)

## psiphon3

get@psiphon3.com

## md转换pdf
https://maxiang.io/


## json to java bean

https://codebeautify.org/json-to-java-converter
https://www.bejson.com/json2javapojo/new/ 


## github 图片加载失败

https://www.ipaddress.com/

# DBeaver Enterprise 7
https://zhile.io/2019/05/08/dbeaver-license-crack.html  
http://www.98key.com/  
QLR8ZC-855575-78538556499839374

## [证件照](https://www.yasuotu.com/)
