## host文件位置
* `C:\Windows\System32\drivers\etc`
* [github 谷歌host](https://github.com/racaljk/hosts)

## cmd commond
* del /?  每个命令  
* set 打印系统所有环境变量 
* ipconfig -all 
* 以端口8080为例：  
        1. 查找对应的端口占用的进程：netstat  -aon|findstr  "8080"，找到占用8080端口对应的程序的PID号：  
        2. 根据PID号找到对应的程序：tasklist|findstr "PID号"    ，找到对应的程序名  
        3. 结束该进程：taskkill /f /t /im 程序名

* 在dos下删除文件夹或文件，先要确定文件夹或文件是否有特殊的属性，比如“系统”、“只读”、“隐藏”，如果有，去掉这些属性，命令如下  

文件夹： attrib c:\windows -s -r -h  
文件：attrib -s -h -r c:\windows\autorun.inf

删除命令如下，  

删除文件夹（空）：rd c:\windows

删除文件：del c:\windows\autorun.inf

注：如果是当前路径下操作，可以省略路径。如：rd 新建文件夹 或 del 新建文件.txt
* 新建文件   type nul > log.txt
## 系统信息
* systeminfo
## 测试ip和端口是否通
* telnet ip port
## 重定向 管道

这是我学习之中知道的一些关于重定向和管道的知识，并积累的资料，在这里和大家分享。如果说的有不足和错误的地方，请指出。毕竟是交流信息。我这里是从DOS和C语言方面看它，没有太多涉及LINUX中所说的。我想从以下几个方面叙述：  
* 重定向：  
所谓重定向，就是不使用系统的标准输入端口、标准输出端口或标准错误端口，而进行重新的指定，所以重定向分为输出重定向、输入重定向和错误重定向（注：  
STDIN   0   标准输入   键盘     命令在执行时所要的输入数据通过它来取得  
STDOUT   1   标准输出   显示器   命令执行后的输出结果从该端口送出  
STDERR   2   标准错误   显示器   命令执行时的错误信息通过该端口送出   ）。  
通常情况下重定向到一个文件。重定向命令又称转向命令。其中错误重定向和输出重定向有些类似，就不多说，学过C++可能会明白的多些。  
* 所谓输出重定向指把执行相应DOS命令时本应在屏幕上显示的内容输出到重定向命令所指向的文件或设备中去。输出重定向命令 > 、>>。    
它们的区别是：如果你使用的是 > ，原文件会被删除，重新生成新的文件，其内容如上所述；如果你使用的是 >> ，它以追加的方式，将命令的输出写入文件的末尾，原文件内容会被保留，新的内容会添加到原文件件的内容的后面。主要用在某个命令的输出很多，在屏幕上不能 完全显示，就可把它重定向到一个文件中，稍后再用文本编辑器来打开这个文件。  
* 输入重定向使输入信息来自文件。如果一个名为file.com的文件 C:>file 之后，执行file时所需的处理信息就改为由文件file读入，这就是输入重定向。小于号<是输入重定向操作符，在<之后的文件名或设备名是 重定向的输入源。如果一个程序时需要输入较多数据，使用输入重定向可以提高效率。在这里要说一些过滤命令 more 、sort 和 find 。其中more进行分屏显示；find 查找符合条件的内容；sort（按行）排序。  
例如：（我是在windows命令提示符中用的）  
例1：　  　
     more < f:\turboc2\readme  
more的输入来自　c:\tc\readme 文件内容多。这个命令与
type f:\turboc2\readme | more
作用相同，但更简洁，效率也更高。
例2：(注cmd重定向进入后用exit返回原目录)
   cmd > file 把 stdout 重定向到 file 文件中
   cmd >> file 把 stdout 重定向到 file 文件中(追加)
   cmd 1> file 把 stdout 重定向到 file 文件中
   cmd > file 2>&1 把 stdout 和 stderr 一起重定向到 file 文件中
   cmd 2> file 把 stderr 重定向到 file 文件中
   cmd 2>> file 把 stderr 重定向到 file 文件中(追加)
   cmd >> file 2>&1 把 stderr 和 stderr 一起重定向到 file 文件中
   cmd < file >file2 cmd 命令以 file 文件作为 stdin，以 file2 文件作为 stdout
       注：>&n 使用系统复制文件描述符 n 并把结果用作标准输出
           <&n 标准输入复制自文件描述符 n
           <&- 关闭标准输入（键盘）
           >&- 关闭标准输出
           n<&- 表示将 n 号输入关闭
           n>&- 表示将 n 号输出关闭
           &> 同时实现输出重定向和错误重定向
用 途：DOS的标准输入输出通常是在标准设备键盘和显示器上进行的, 利用重定向,可以方便地将输入输出改向磁盘文件或其它设备。如在批处理命令执行期间为了禁止命令或程序执行后输出信息而扰乱屏幕, 可用DOS重定向功能把输出改向NUL设备(NUL不指向任何实际设备): C:\>copy a.txt b.txt > NUL。命令执行结束不显示"1 file(s) copied"的信息。有的交互程序在执行时要求很多键盘输入, 但有时输入是固定不变的, 为加快运行速度, 可预先建立一个输入文件,此文件的内容为程序的键盘输入项, 每个输入项占一行。假如有一个程序cx 其输入项全部包括在文件in.dat中, 执行 C:\>cx <in.dat>NUL 程序就自动执行。
*  管道：
进 程从“管道”的一端发送另一端接收，也就是说将若干命令用输入输出“管道”串接在一起，这就是管道；管道在某种程度上是输入和输出重定向的结合，前一个命令的输出，作为下一个命令的输入，而不需要经过任何中间文件。竖线字符“|”是管道操作符，管道命令经常与上面讲的过滤命令联合使用。DOS的管道功能是使一个程序或命令的标准输出用做另一个程序或命令的标准输入。如把DEBUG的输入命令写入文件aaa, 用type命令通过管道功能将aaa的内容传输给DEBUG, 在DEBUG执行期间不再从控制台索取命令参数, 从而提高了机器效率。命令为: C:\>type aaa|DEBUG >bbb。

例如，这是我以前看到的例子。命令dir|more使得当前目录列表在屏幕上逐屏显示。dir的输出是整个目录列表，它不出现在屏幕上而是由于符号“|”的规定，成为下一个命令more的输入，more命令则 将其输入一屏一屏地显示，成为命令行的输出。再如命令dir|find”hello”>file，其中 dir的输出是当前目录列表，不出现在屏幕上而是成为find命令的输入。find命令在输入文件中寻找指定字符串"hello"并输出包含这个字符串的 行，由于输出重定向符号>的规定，最后的输出已存入文件file，不出现在屏幕上。命令dir|find"< dir >file则是将当前目录项中的子目录项寻找出来并存入文件file中。








MKLINK [[/D] | [/H] | [/J]] Link Target

        /D      创建目录符号链接。默认为文件
                符号链接。
        /H      创建硬链接，而不是符号链接。
        /J      创建目录联接。
        Link    指定新的符号链接名称。
        Target  指定新链接引用的路径
                (相对或绝对)。





## msi安装 
* msiexec /package path


## tasklist taskkill
在Windows XP中新增了两个命令行工具“tasklist、taskkill”。通过“Ctrl+Alt+Del”组合键，打开“任务管理器”就可以查看到本机完整的进程列表，而且可以通过手工定制进程列表的方式获的更多的进程信息，如会话ID、用户名等，遗憾的是，我们查看不到这些进程到底提供了哪些系统服务。而tasklist、taskkill两个工具就能实现上面所说的功能。

　　“Tasklist”命令用来显示运行在本地或远程计算机上的所有进程的命令行工具，带有多个执行参数。它的格式为：Tasklist [/S system [/U username [/P [password]]]] [/M [module] | /SVC | /V] [/FI filter] [/FO format] [/NH]

　　其中的参数含义如下:

　　/S     system           指定连接到的远程系统。
　　/U     [domain\]user    指定使用哪个用户执行这个命令。
　　/P     [password]       为指定的用户指定密码。
　　/M     [module]         列出调用指定的 DLL 模块的所有进程。如果没有指定模块名，显示每个进程加载的所有模块。
　　/SVC                    显示每个进程中的服务。
　　/V                      指定要显示详述信息。
　　/FI    filter           显示一系列符合筛选器指定的进程。
　　/FO    format           指定输出格式，有效值: "TABLE"、"LIST"、"CSV"。
　　/NH                     指定栏标头不应该在输出中显示。只对 "TABLE" 和 "CSV" 格式有效。

　　“Tasklist”命令相关实例

　　1、使用“Tasklist”命令查看本机进程
　　 在DOS命令提示符下输入：“tasklist”命令，就可显示本机的所有进程。本机的显示结果由五部分组成：图像名（进程名）、PID、会话名、会话＃、内存使用。

　　2、查看远程系统的进程
　　 在命令提示符下输入：“tasklist  /s  218.22.123.26  /u  jtdd  /p  12345678”（不包括引号）。其中/s参数后的“218.22.123.26”指要查看的远程系统的IP地址，/u后的“jtdd”指tasklist命令使用的用户帐号，它是远程系统上的一个合法帐号，/p后的“12345678”指jtdd帐号的密码。这样，通过上面的命令，我们就可以查看到远程系统的进程了。
　　小提示：使用tasklist命令查看远程系统的进程时，需要远程机器的RPC 服务器的支持，否则，该命令就不能正常使用。

　　3、查看系统进程提供的服务
　　tasklist命令不但可以查看系统进程，而且还可以查看每个进程提供的服务。如查看本机的进程“SVCHOST.EXE”提供的服务，在命令提示符下输入：“tasklist  /svc”命令即可，你会惊奇的发现，有四个“SVCHOST.EXE”进程，原来有二十几项服务使用这个进程，对于远程系统来说，查看系统服务也很简单，使用“tasklist  /s  218.22.123.26  /u  jtdd  /p  12345678  /svc”命令，就可以查看IP地址为“218.22.123.26”的远程系统进程所提供的服务。

　　4、查看调用DLL模块文件的进程列表
　　例如，我们要查看本地系统中哪些进程调用了“shell32.dll” DLL模块文件。在命令提示符下输入： tasklist  /m  shell32.dll　这时系统将显示调用进程列表。 

　　5、使用筛选器查找指定的进程 
　　在命令提示符下输入：“TASKLIST   /FI    "USERNAME ne NT AUTHORITY\SYSTEM"     /FI "STATUS eq running“
　　这样就列出了系统中正在运行的非“SYSTEM“状态的所有进程。其中“/FI“为筛选器参数，” ne“和”eq“为关系运算符”不相等“和”相等。

　　谈到“Tasklist”命令，就不得不提及它的孪生兄弟“taskkill”命令，顾名思义，它是用来杀死进程的。
　　如要杀死本机的“notepad.exe”进程。首先，使用Tasklist查找它的PID,系统显示本机“notepad.exe”进程的PID值为“1132“，然后运行“taskkill  /pid 1132”即可,或者运行 “taskkill  /IM  notepad.exe”也可，其中” /pid “参数后面跟要终止进程的PID值，“/IM“参数后面为进程的图像名。

　　“Tasklist”命令的用法还有很多，由于篇幅关系，就不详细介绍了，有兴趣的朋友可以参考有关技术资料，进行深入研究。这两个命令在日常的网络维护中，是非常有帮助的，可以方便我们有效的进行网络维护。

 

　　tasklist是显示当前system正在运行的进程，通过不同的参数可以达到不同的效果，最基本的用处就是当机子中毒后，任务管理器可能打不开，这时就可以通过tasklist查看到底是那个进程在捣鬼，但是你要想删除，终止该进程，必须用到和tasklist密切相关的另外一个命令----taskkill。

具体情况如下：
==================================================================
　　taskkill是用来终止进程的。具体的命令规则如下：
TASKKILL [/S system [/U username [/P [password]]]]
         { [/FI filter] [/PID processid | /IM imagename] } [/F] [/T]
描述:
    这个命令行工具可用来结束至少一个进程。
    可以根据进程 id 或图像名来结束进程。
参数列表:
    /S    system           指定要连接到的远程系统。
    /U    [domain\]user    指定应该在哪个用户上下文
                           执行这个命令。
    /P    [password]       为提供的用户上下文指定
                           密码。如果忽略，提示输入。
    /F                     指定要强行终止
                           进程。
    /FI   filter           指定筛选进或筛选出查询的
                           的任务。
    /PID  process id       指定要终止的进程的
                           PID。
    /IM   image name       指定要终止的进程的
                           图像名。通配符 '*'
                           可用来指定所有图像名。
    /T                     Tree kill: 终止指定的进程
                           和任何由此启动的子进程。
    /?                     显示帮助/用法。
筛选器:
    筛选器名      有效运算符                有效值
    -----------   ---------------           --------------
    STATUS        eq, ne                    运行 | 没有响应
    IMAGENAME     eq, ne                    图像名
    PID           eq, ne, gt, lt, ge, le    PID 值
    SESSION       eq, ne, gt, lt, ge, le    会话编号
    CPUTIME       eq, ne, gt, lt, ge, le    CPU 时间，格式为
                                            hh:mm:ss。
                                            hh - 时，
                                            mm - 钟，ss - 秒
    MEMUSAGE      eq, ne, gt, lt, ge, le    内存使用，单位为 KB
    USERNAME      eq, ne                    用户名，格式为
                                            [domain\]user
    MODULES       eq, ne                    DLL 名
    SERVICES        eq, ne                    服务名
    WINDOWTITLE     eq, ne                    窗口标题
注意: 只有带有筛选器的情况下，才能跟 /IM 切换使用通配符 '*'。
注意: 远程进程总是要强行终止，
      不管是否指定了 /F 选项。
例如:
    TASKKILL /S system /F /IM notepad.exe /T
    TASKKILL /PID 1230 /PID 1241 /PID 1253 /T
    TASKKILL /F /IM notepad.exe /IM mspaint.exe
    TASKKILL /F /FI "PID ge 1000" /FI "WINDOWTITLE ne untitle*"
    TASKKILL /F /FI "USERNAME eq NT AUTHORITY\SYSTEM" /IM notepad.exe
    TASKKILL /S system /U domain\username /FI "USERNAME ne NT*" /IM *
    TASKKILL /S system /U username /P password /FI "IMAGENAME eq note*"
基本的用法就是：Taskkill  /pid ****(pid号)
至于eq，ne，ge，le，gt，lt，是等于，不等于，不小于，不大于，大于，小于意思，主要是用来终止一组进程的，不过这个参数可以通过多组taskkill 来实现。
/F是强制命令。



systeminfo  物理CPU个数

wmic

cpu get NumberOfCores,NumberOfLogicalProcessors