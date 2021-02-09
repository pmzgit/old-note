# 前面
*  [参考1](https://zorro.gitbooks.io/poor-zorro-s-linux-book/content/shellbian-cheng-zhi-yu-fa-ji-chu.html)
* [参考2](https://www.jianshu.com/nb/10628756)
* [shell 脚本库](https://gitee.com/aqztcom/kjyw/blob/master/shell/shell_manual.sh)

# shell 脚本学习

## shell中，简单命令，组合命令
* http://pubs.opengroup.org/onlinepubs/009695399/utilities/xcu_chap02.html#tag_02_09_01

* http://pubs.opengroup.org/onlinepubs/009695399/utilities/xcu_chap02.html#tag_02_09_04


## sh/bash/dash区别

* https://swe.mirsking.com/linux/shbashdash

## 注意shell中变量的作用域和生命周期: 只在当前进程有效

* 临时环境变量

Shell 语法，在`一个` `简单命令`前可以包含任意个赋值语句。这些变量赋值将会在执行命令前展开，等效于临时的环境变量。例如： 

`url=https://harttle.land bash ./spider.sh`

* 简单命令中的变量赋值也不作用于当前进程,下面的代码将会输出空行

url=https://harttle.land echo $url

* export 到子进程

export只会在子进程中创建变量的副本，即spider.sh对它的改动不会体现在当前进程。
## 命令在Linux中的执行分为4个步骤
* 个人猜测首先进行：当参数中有通配符时，shell 首先进行参数的通配符路径扩展，然后再组装新的命令
* 第1步：判断用户是否以绝对路径或相对路径的方式输入命令（如/bin/ls），如果是的话则直接执行。
* 第2步：Linux系统检查用户输入的命令是否为“别名命令”，即用一个自定义的命令名称来替换原本的命令名称。可以用alias命令来创建一个属于自己的命令别名，格式为“alias 别名=命令”。若要取消一个命令别名，则是用unalias命令，格式为“unalias 别名”。
* 第3步：Bash解释器判断用户输入的是内部命令还是外部命令。内部命令是解释器内部的指令，会被直接执行；而用户在绝大部分时间输入的是外部命令，这些命令交由步骤4继续处理。可以使用“type 命令名称”来判断用户输入的命令是内部命令还是外部命令。
* 第4步：系统在多个路径中查找用户输入的命令文件，而定义这些路径的变量叫作PATH，可以简单地把它理解成是“解释器的小助手”，作用是告诉Bash解释器待执行的命令可能存放的位置，然后Bash解释器就会乖乖地在这些位置中逐个查找。PATH是由多个路径值组成的变量，每个路径值之间用冒号间隔，对这些路径的增加和删除操作将影响到Bash解释器对Linux命令的查找。
* env命令来查看到Linux系统中所有的环境变量,type cmd
* 顺序：  
别名：alias  
关键字：keyword  
函数：function  
内建命令：built in  
哈西索引：hash  
外部命令：command  
* alias功能在交互打开的bash中是默认开启的，但是在bash脚本中是默认关闭的  
shopt -s expand_aliases
* 内建命令
```sh
:,  ., [, alias, bg, bind, break, builtin, caller, cd, command, compgen, complete, compopt, continue, declare, dirs, disown, echo, enable, eval, exec, exit, export, false, fc,
   fg, getopts, hash, help, history, jobs, kill, let, local, logout, mapfile, popd, printf, pushd, pwd, read, readonly, return, set, shift, shopt, source, suspend,  test,  times,  trap,
   true, type, typeset, ulimit, umask, unalias, unset, wait

在bash 下， 帮助信息用help　命令：　`help cd`
```
* 在交互式bash操作和bash编程中，hash功能总是打开的，我们可以用set +h关闭hash功能。
* bash在正常调用内部命令的时候并不会像外部命令一样产生一个子进程。
* 如果我们的bash程序没有显示的以一个exit指定返回码退出的话，那么其最后执行命令的返回码将成为整个bash脚本退出的返回码。    
    系统将错误返回码设计成1-255，这其中还分成两类：  
    1. 程序退出的返回码：1-127。这部分返回码一般用来作为给程序员自行设定错误退出用的返回码，比如：如果一个文件不存在，ls将返回2。如果要执行的命令不存在，则bash统一返回127。返回码125和126有特殊用处，一个是程序命令不存在的返回码，另一个是命令的文件在，但是不可执行的返回码。
    2. 程序被信号打断的返回码：128-255。这部分系统习惯上是用来表示进程被信号打断的退出返回码的。一个进程如果被信号打断了，其退出返回码一般是128+信号编号的数字。如果一个进程被2号信号打断的话，其返回码一般是128+2=130

### read
```sh
read -p "Login: username psd " username psd
echo $username $psd

read命令除了可以读取输入并赋值一个变量以外，还可以赋值一个数组
read -a test 
echo ${test[*]}
```

### mapfile
```sh
#!/bin/bash

exec 3< /etc/passwd

mapfile -u 3 passwd 

exec 3<&-

echo ${#passwd[@]}

for ((i=0;i<${#passwd[@]};i++))
do
    echo ${passwd[$i]}
done
```
### printf
`printf "%d\t%s %x %f\n" 123 zorro 223 1.23`

### eval  
eval 命令将会首先扫描命令行进行所有的置换，然后再执行该命令。

##  fd
在内核中，文件描述符的数组所直接映射的实际上是文件表，文件表再索引到相关文件的v_node。具体可以参见《UNIX系统高级编程》。  
shell在产生一个新进程后，新进程的前三个文件描述符都默认指向三个相关文件。这三个文件描述符对应的数组下标分别为0，1，2。0对应的文件叫做标准输入（stdin），1对应的文件叫做标准输出（stdout），2对应的文件叫做标准报错(stderr)。但是实际上，默认跟人交互的输入是键盘、鼠标，输出是显示器屏幕，这些硬件设备对于程序来说都是不认识的，所以操作系统借用了原来“终端”的概念，将键盘鼠标显示器都表现成一个终端文件。于是stdin、stdout和stderr就最重都指向了这所谓的终端文件上。  
进程可以打开多个文件，多个描述符之间都可以进行重定向。当然，输入也可以，比如：3<表示从描述符3读取。
 
## 重定向
```sh
Here strings：
command [args] <<<["]$word["]；

$word会展开并作为command的stdin。
这对于发送变量中的数据到进程是非常方便的。here-strings 更简短;
here-strings 还接收多行字符串作为标准输入;

Here Document：
cmd << delimiter
  Here Document Content
delimiter

usage() {
        cat <<-EOF
        usage: command [-x] [-v] [-z] [file ...]
        A short explanation of the operation goes here.
        It might be a few lines long, but shouldn't be excessive.
        EOF
}

重定向操作符“<<”和定界标志符“END”之间追加减号“-”（即<<-END）将会忽略行首的制表符。
完结标志符（EOF）必须写在行首,后面也不能有任何的字符（包括空格）
默认情况下，Bash 替换会在 here-documents 的内容上执行，即 here-documents 内部的变量和命令会被求值或运行
可以使用单引号或双引号扩起定界符来使 Bash 替换失效

不仅可以在终端上使用，在shell 文件中也可以使用:

cat << EOF > output.sh
echo "hello"
echo "world"
EOF

文件描述符的复制：
复制输入文件描述符：[n]<&word
如果n没有指定数字，则默认复制0号文件描述符。word一般写一个已经打开的并且用来作为输入的描述符数字，表示将指定的n号描述符在指定的描述符上复制一个。如果word写的是“-”符号，则表示关闭这个文件描述符。如果word指定的不是一个用来输入的文件描述符，则会报错。
复制输出文件描述符：[n]>&word
复制一个输出的描述符，字段描述参考上面的输入复制，例子上面已经讲过了。这里还需要知道的就是1>&-表示关闭1号描述符。
文件描述符的移动：
移动输入描述符：[n]<&digit-
移动输出描述符：[n]>&digit-
这两个符号的意思都是将原有描述符在新的描述符编号上打开，并且关闭原有描述符。
描述符新建：
新建一个用来输入的描述符：[n]< file
新建一个用来输出的描述符：[n]> file;如果文件 file 不存在，则它将被创建，如果文件已存在，则它被清空为 0 字节。
新建一个用来输入和输出的描述符：[n]<>file。file都应该写一个文件路径，用来表示这个文件描述符的关联文件是谁。如果不指定 n，则默认表示标准输入。这个语法对更新文件很有用
下面我们来看相关的编程例子：
#!/bin/bash

# example 1
#打开3号fd用来输入，关联文件为/etc/passwd
exec 3< /etc/passwd
#让3号描述符成为标准输入
exec 0<&3
#此时cat的输入将是/etc/passwd，会在屏幕上显示出/etc/passwd的内容。
cat

#关闭3号描述符。
exec 3<&-

# example 2
#打开3号和4号描述符作为输出，并且分别关联文件。
exec 3> /tmp/stdout

exec 4> /tmp/stderr

#将标准输出关联到3号描述符，关闭原来的1号fd。
exec 1>&3-
#将标准报错关联到4号描述符，关闭原来的2号fd。
exec 2>&4-

#这个find命令的所有正常输出都会写到/tmp/stdout文件中，错误输出都会写到/tmp/stderr文件中。
find /etc/ -name "passwd"

#关闭两个描述符。
exec 3>&- 4>&-

重定向默认只适用于一条命令。当 Bash 运行命令时，它告诉 Bash，标准输出（stdout）应当指向一个文件，而不是它之前指向的地方。
这个重定向只对它应用于的单个命令有效。再此之后执行的其他命令将继续把它们的输出发送到脚本的标准输出位置。
所以如果单纯改变脚本的描述符，需要在前面加exec命令。这种用法也叫做描述符魔术。

```
## 管道
* Linux上的管道就是一个操作方式为文件的内存缓冲区。
* Linux上的管道分两种类型： 

1. 匿名管道 `|`（只包含标准输出，从管道输出的标准错误会混合到一起） 或者 `|&` （包含标准输出和标准报错）　　　　　　　
2. 命名管道  

　
这两种管道也叫做有名或无名管道。匿名管道最常见的形态就是我们在shell操作中最常用的"|"。它的特点是只能在父子进程中使用，父进程在产生子进程前必须打开一个管道文件，然后fork产生子进程，这样子进程通过拷贝父进程的进程地址空间获得同一个管道文件的描述符，以达到使用同一个管道通信的目的。此时除了父子进程外，没人知道这个管道文件的描述符，所以通过这个管道中的信息无法传递给其他进程。这保证了传输数据的安全性，当然也降低了管道了通用性，于是系统还提供了命名管道。

我们可以使用mkfifo或mknod命令来创建一个命名管道，这跟创建一个文件没有什么区别：

### () {}
(list)：放在()中执行的命令将在一个subshell环境中执行，这样的命令将打开一个bash子进程执行。即使要执行的是内建命令，也要打开一个subshell的子进程。另外要注意的是，当内建命令前后有管道符号连接的时候，内建命令本身也是要放在subshell中执行的。这个subshell子进程的执行环境基本上是父进程的复制，除了重置了信号的相关设置。bash编程的信号设置使用内建命令trap，将在后续文章中详细说明。

{ list; }：大括号作为函数语法结构中的标记字段和list标记字段，是一个关键字。在大括号中要执行的命令列表（list）会放在当前执行环境中执行。命令列表必须以一个换行或者分号作为标记结束。

## subshell
* 通常，脚本中的外部命令会分支出一个子进程，而 Bash 的内部命令不会。由此，与外部命令相比，Bash 的内部命令执行的更快，并且使用更少的系统资源。
* 当一个命令放在()中的时候，bash会打开一个子进程去执行相关命令，这个子进程实际上是另一个bash环境，叫做subshell。当然包括放在()中执行的命令，bash会在以下情况下打开一个subshell执行命令：  
使用&作为命令结束提交了作业控制任务时。  
使用|连接的命令会在subshell中打开。  
使用()封装的命令。           
使用coproc（bash 4.0版本之后支持）作为前缀执行的命令。  
要执行的文件不存在或者文件存在但不具备可执行权限的时候，这个执行过程会打开一个subshell执行。  
* 在subshell中，有些事情需要注意。subshell中的$$取到的仍然是父进程bash的pid，如果想要取到subshell的pid，可以使用BASHPID变量：  
* 可以使用BASH_SUBSHELL变量的值来检查当前环境是不是在subshell中，这个值在非subshell中是0；每进入一层subshell就加1。
* Bash 还有一个内部变量 SHLVL，此变量的值指示 Bash 的嵌套深度。如果是在命令行下，则 $SHLVL 的值是 1，而在脚本中，其值将增加为 2。
* 子 Shell 中的变量在子 Shell 的代码块之外是不可见的。它们不能被传到启动这个子 Shell 的 Shell（父进程）。这些变量实际上是子 Shell 的本地变量。在subshell中做的任何操作都不会影响父进程的bash执行环境。subshell除了PID和trap相关设置外，其他的环境都跟父进程是一样的。subshell的trap设置跟父进程刚启动的时候还没做trap设置之前一样。子 Shell 中的 exit 命令也只是退出它所运行的子 Shell。
## for,select 
```sh
for ((count=0;count<100;count++))
do
    echo $count
done

select i in a b c d
do
    case $i in
        a)
        echo "Your choice is a"
        ;;
        b)
        echo "Your choice is b"
        ;;
        c)
        echo "Your choice is c"
        ;;
        d)
        echo "Your choice is d"
        ;;
        *)
        echo "Wrong choice! exit!"
        exit
        ;;
    esac
done

在bash中，break和continue可以用来跳出和进行下一次for，while，until和select循环。
until 循环总是至少执行一次.
```

```sh
E_BADARGS=65

if [ ! -n "$1" ]
then
        echo "Usage: `basename $0` argument1 argument2 ..."
        exit $E_BADARGS
fi

index=1

echo "Listing args with \$*:"

for arg in $*
do
        echo "Arg #$index = $arg"
        let index+=1
done

echo

index=1

echo "Listing args with \"\$@\""

for arg in "$@"
do
        echo "Arg #$index = $arg"
        let index+=1
done

在这里，$* 是没有双引号的，因为如果加了双引号，即 “$*”，其值将被扩展为包含所有位置参数的值得单个字符串，将使 for 循环仅迭代一次。
```

```sh

old_IFS=$IFS

# 参数个数不为 1
if [ $# -ne 1 ]
then
    echo "Usage: `basename $0` filename"
    exit
fi

# 如果指定的文件不存在
if [ ! -f $1 ]
    echo "The file $1 doesn't exist!"
    exit 1
fi

# 修改环境变量 IFS 的值，使下面的 for 循环以换行符作为分隔符
IFS=$'\n'

for line in $(cat $1)
do
    echo $line
done

IFS=$old_IFS
for 默认使用环境变量 IFS 的值作为分隔符，由于 $IFS 的默认值是“<space><tab><newline>”，所以它会首先以空格作为分隔符

while read LINE
do
        let count++
        echo "$count $LINE"
done < $filename

尽管使用 while 循环读取文件的内容相对比较方便，但是它也有副作用，它读取的每行内容会去掉重复的空格和制表符，即会消除每行的原有格式。而将 for 循环结合环境变量 $IFS 使用可以保留每行原有的格式。所有，我们可以根据不同的需求来选择使用 while 还是 for 循环来读取文件的内容。

```

## function
```sh
#函数名
function function_name() {
    local var=value
    local varName
    # 函数体，在函数中执行的命令行
    commands ...
    # 可选返回，如无以最后一条命令的结果作为返回值；如有则返回值范围应为 0 ~ 255
    [ return int; ]
}
调用：
name LiLei HanMeimei

默认情况下脚本中所有的变量都是全局的，在函数中修改一个变量将改变这个脚本中此变量的值；
local 命令只能在函数内部使用；
local 命令将变量名的可见范围限制在函数内部，所以local变量和全局变量可以同名


想取消函数的定义，可以通过使用内部命令 unset 并配合 “-f” 


从函数文件中调用函数
1.我们可以把所有的函数存储在一个函数文件中；
2.我们可以把所有的函数加载到当前脚本或是命令行。

. /path/to/functions.sh
```

## 作业控制 [前台任务，后台任务，守护进程](http://www.ruanyifeng.com/blog/2016/02/linux-daemon.html)
* "后台任务"与"前台任务"的本质区别只有一个：是否继承标准输入。所以，执行后台任务的同时，用户还可以输入其他命令。
* &:表明这个命令的执行放到jobs中跑，bash不必wait进程,fg %+ 把当前作业任务（所谓的当前作业，就是最后一个被放到作业控制中的进程，而备用（-　表示备用的当前作业任务）的则是当前进程如果退出，那么备用的就会变成当前的。），回到前台让当前bash去wait。让一个当前bash正在wait的进程回到作业控制，可以使用ctrl+z快捷键，这样会让这个进程处于stop状态；想让它再运行起来可以使用bg命令：　bg %+
* nohup命令对server.js进程做了三件事。

阻止SIGHUP(1)信号发到这个进程。  
关闭标准输入。该进程不再能够接收任何输入，即使运行在前台。  
重定向标准输出和标准错误到文件nohup.out。 

### 信号处理
* 在类 Unix 操作系统中，信号被用于进程间通信。信号是一个发送到某个进程或同一进程中的特定线程的异步通知，用于通知发生的一个事件。
* kill -ｌ  
常用信号有2号（crtl c就是发送2号信号），15号（kill默认发送），9号（著名的kill -9）这几个就可以了。其他我们还需要知道，这些信号绝大多数是可以被进程设置其相应行为的，除了9号和19号信号。这也是为什么我们一般用kill直接无法杀掉的进程都会再用kill -9试试的原因
* 进程可以设置信号

```sh
#!/bin/bash

trap ' ' 1 2  3 15 # 保证脚本不被打断

while :
do
    sleep 1
done


trap 'my_exit $LINENO $BASH_COMMAND; exit' SIGHUP SIGINT SIGQUIT

my_exit()
{
        echo "$(basename $0) caught error on line : $1 command was: $2"
        logger -p notice "script: $(basename $0) was terminated: line: $1, command was $2"
        # 其他的一些清理命令
}

while :
do
        sleep 1
        count=$(( $count + 1 ))
        echo $count
done

trap - INT TERM # 移除捕获
```
* bash还提供了一种让bash执行暂停并等待信号的功能，就是suspend命令。它等待的是18号SIGCONT信号，这个信号本身的含义就是让一个处在T（stop）状态的进程恢复运行。suspend默认不能在非loginshell中使用，如果使用，需要加-f参数。

### 进程控制
* exit logout(区别只是logout是专门用来退出login方式的bash的。如果bash不是login方式执行的，logout会报错)
* wait命令的功能是用来等待jobs作业控制进程退出的。因为一般进程默认行为就是要等待其退出之后才能继续执行。wait可以等待指定的某个jobs进程，也可以等待所有jobs进程都退出之后再返回，实际上wait命令在bash脚本中是可以作为类似“屏障”这样的功能使用的。考虑这样一个场景，我们程序在运行到某一个阶段之后，需要并发的执行几个jobs，并且一定要等到这些jobs都完成工作才能继续执行，但是每个jobs的运行时间又不一定多久，此时，我们就可以用这样一个办法
```sh
#!/bin/bash

echo "Begin:"

(sleep 3; echo 3) &
(sleep 5; echo 5) &
(sleep 7; echo 7) &
(sleep 9; echo 9) &

wait

echo parent continue

sleep 3

echo end!

# 在不加任何参数的情况下，wait会等到所有作业控制进程都退出之后再回返回，否则就会一直等待。当然，wait也可以指定只等待其中一个进程，可以指定pid和jobs方式的作业进程编号，如%3，
```
* exec  
这个命令的执行过程跟exec族的函数功能是一样的：将当前进程的执行镜像替换成指定进程的执行镜像.但对文件操作符进行操作时，就没有这样的功能了，执行完毕后，继续留在当前的shell，比如exec 3<&0 这个意思就是将操作符3也指向标准输入
* flock  
flock的默认行为是，如果文件之前没被加锁，则加锁成功返回，如果已经有人持有锁，则加锁行为会阻塞，直到成功加锁
```sh
#!/bin/bash

exec 3> /tmp/.lock

if ! flock -xn 3
then
    echo "already running!"
    exit 1
fi

echo "running!"
sleep 30
echo "ending"

flock -u 3
exec 3>&-
rm /tmp/.lock

exit 0

-n参数可以让flock命令以非阻塞方式探测一个文件是否已经被加锁，所以可以使用互斥锁的特点保证脚本运行的唯一性。脚本退出的时候锁会被释放，所以这里可以不用显式的使用flock解锁。
```
flock除了-x参数指定文件描述符锁文件以外，还可以作为执行命令的前缀使用。这种方式非常适合直接在crond中方式所要执行的脚本重复执行
`*/1 * * * * /usr/bin/flock -xn /tmp/script.lock -c '/home/bash/script.sh'`

##　参数处理
```sh

有必要区分几个概念（在 Shell 脚本中）。

Argument 
Option: 中文对应「选项」，形如 -a, --save 的都是选项；选项可以接收参数（Parameter），也可以不接受参数。
Flag: 中文对应「标签」，形如 -v(verbose)；标签是布尔值，不接受参数。

getopt <optstring> <parameters>
 getopt [options] [--] <optstring> <parameters>
 getopt [options] -o|--options <optstring> [options] [--] <parameters>

getopt f:vl -vl -f/local/filename.conf param_1
-v -l -f /local/filename.conf -- param_1

“f:vl” 对应 getopt 命令语法中的 optstring（选项字符串），“-vl -f/local/filename.conf param_1” 对应 getopt 命令语法中的 parameters（getopt 命令的参数）。因此，getopt 会按照 optstring 的设置，将 parameters 解析为相应的选项和参数。

然后解析后的命令行选项和参数之间使用双连字符（--）分隔。

#! /bin/bash

# 将 getopt 解析后的内容设置到位置参数

vflag=off
output=""
filename=""

set -- `getopt hvf:o: "$@"`

function usage() {
        echo "USAGE:"
        echo "  myscript [-h] [-v] [-f <filename>] [-o <filename>]"
        exit -1
}

while [ $# -gt 0 ]
do
    case "$1" in
                -v)
                        vflag=on
                        ;;
                -f)
                        filename=$2
                        if [ ! -f $filename ]
                        then
                                echo "The source file $filename doesn't exist!"
                                exit
                        else
                                shift
                        fi
                        ;;
                -o)
                        output=$2
                        if [ ! -d `dirname $output` ]
                        then
                                echo "The output path `dirname $output` doesn't exist!"
                                exit
                        else
                                shift
                        fi
                        ;;
                -h)
                        usage
                        exit
                        ;;
                --)
                        shift
                        break
                        ;;
                -*)
                        echo "Invalid option: $1"
                        usage
                        exit 2
                        ;;
                *)
                        break
                        ;;
        esac
        shift
done

“getopt f:vl "$@"” 表示将传递给脚本的命令行选项和参数作为 getopt 命令的参数，由 getopt 命令解析处理。

“set -- getopt f:vl "$@"” 则表示将 getopt 命令的输出作为值依次（从左至右）赋值给位置参数（“set -- [args]” 命令会把指定的参数 [args] 依次赋值给位置参数）。


通常来说，我们会将 getopts 放在 while 循环的条件判断式中。getopts 在顺利解析到参数的时候，会返回 TRUE；否则返回 FALSE，用以结束循环。
getopts 在两种情况下会停止解析并返回 FALSE：

getopts 读入不以 - 开始的字符串；
getopts 读入连续的两个 - (i.e. --)。
注意：getopts 不支持两个连字符引导的选项，而是将两个连续的连字符作为「选项结束的标志」。

导致的缺陷：
1.选项参数的格式必须是-d val，而不能是中间没有空格的-dval。
2.所有选项参数必须写在其它参数的前面，因为getopts是从命令行前面开始处理，遇到非-开头的参数，或者选项参数结束标记--就中止了，如果中间遇到非选项的命令行参数，后面的选项参数就都取不到了。
3.不支持长选项， 也就是--debug之类的选项

基本语法:
getopts OPTSTRING VARNAME [ARGS...]

OPTSTRING：告诉 getopts 会有哪些选项和在哪会有参数；
VARNAME：告诉 getopts 哪个变量用于选项报告；
ARGS：告诉 getopts 解析这些可选的参数，而不是位置参数。


变量和用法
OPTIND: getopts 存放下一个要处理的参数的索引。这是 getopts 在调用过程中记住自己状态的方式。同样可以用于移位使用 getopts 处理后的位置参数。OPTIND 初始被设置为 1，getopts在处理参数的时候，处理一个开关型选项，OPTIND加1，处理一个带值的选项参数，OPTIND则会加2。并且如果你想再次使用 getopts 解析任何内容，都需要将其重置为 1；
OPTARG: getopts 在解析到选项的参数时，就会将参数保存在 OPTARG 变量当中；如果 getopts 遇到不合法的选项，并且首位有 :（选项字符串中的第一个字符为冒号(:)，表示抑制错误报告模式, 表示「不打印错误信息」）时，会把选项本身保存在 OPTARG 当中, 将 ? 存入 变量VARNAME中。
OPTERR：它的值为 0 或者 1。指示 Bash 是否应该显示由 getopts 产生的错误信息。在每个 Shell 启动时，它的值都被初始化为 1。如果我们不想看到烦人的信息，可以将它的值设置为 0。

#!/bin/bash
while getopts 'd:Dm:f:t' VARNAME; do
    case $VARNAME in
        d)
            DEL_DAYS="$OPTARG";;
        D)
            DEL_ORIGINAL='yes';;
        f)
            DIR_FROM="$OPTARG";;
        m)
            MAILDIR_NAME="$OPTARG";;
        t)
            DIR_TO="$OPTARG";;
        \?)
            echo "Usage: `basename $0` [options] filename"
            echo "Invalid option: -${OPTARG}"
    esac
done
  
shift $(($OPTIND - 1))

1. 无效的选项不会停止处理：如果我们希望脚本在这种情况下停止运行，我们必须自己做一些完善操作（在适当的位置执行 exit 命令）；
2. 多个相同的选项是可能的：如果你想禁止重复的选项，你必须在脚本中做一些检查操作。
```
  [参考](https://liam0205.me/2016/11/11/ways-to-parse-arguments-in-shell-script/)  
  [参考](https://www.cnblogs.com/yxzfscg/p/5338775.html)
## 脚本调试
### #!/usr/bin/env 脚本解释器名称
这就利用了env命令可以得到可执行程序执行路径的功能，让脚本自行找到在当前系统上到底解释器在什么路径。让脚本更具通用性。
```sh
#!/usr/bin/env bash 
set -vxen
set -o nounset      # 没有指定命令行参数时，它将会报一个未绑定变量的错误
export PS4='+{$LINENO:${FUNCNAME[0]}}'
set +x # 关闭
```

-v 参数就是可视模式,它会在执行bash程序的时候将要执行的内容也打印出来，除此之外，并不改变bash执行的过程 ，包括注释行
-x参数是跟踪模式(xtrace)。可以跟踪各种语法的调用，并打印出每个命令的输出结果  
-n参数用来检查bash的语法错误，并且不会真正执行bash脚本  
-e参数，这个参数可以让bash脚本命令执行错误的时候直接退出，而不是继续执行。


## 用户 用户组
* 添加用户 

useradd test  
passwd test    
增加用户test，有一点要注意的，useradd增加一个用户后，不要忘了给他设置密码，不然不能登录的。  

usermod -d /home/test -a -G test2 test  
将test用户的登录目录改成/home/test，并加入test2组，注意这里是大G。 

不创建用户的主目录  
useradd zookeeper -s /sbin/nologin -M
* 删除用户  
userdel -r test

find / -user lee -exec rm {} \;      
find / -nouser  -exec rm {} \; 删除没有用户的文件            
find / -nogroup -exec rm {} \; 删除没有组的文件      

cat /etc/passwd
* 分配用户用户组  
chown -R user:usergroup dir

gpasswd -a test test2 将用户test加入到test2组  
gpasswd -d test test2 将用户test从test2组中移出  

groupadd  test  
groupmod -n test2  test  
将test组的名子改成test2  
groupdel test2  
* 查看当前登录用户所在的组   
groups apacheuser   
所有组 cat /etc/group  

* 查看当前登录用户 w whoami  
id apacheuser  
last 查看登录成功的用户记录  
lastb 查看登录不成功的用户记录  

## systemd
### [Systemd 入门教程：命令篇](http://www.ruanyifeng.com/blog/2016/03/systemd-tutorial-commands.html)
## `systemctl--version`
* 表1-4   systemctl管理服务的启动、重启、停止、重载、查看状态等常用命令
```sh
System V init命令（RHEL 6系统）	systemctl命令（RHEL 7系统）	作用

service foo start	systemctl start foo.service	启动服务  
service foo restart	systemctl restart foo.service	重启服务  
service foo stop	systemctl stop foo.service	停止服务  
service foo reload	systemctl reload foo.service	重新加载配置文件（不终止服务）  
service foo status	systemctl status foo.service	查看服务状态 
``` 
* 表1-5    systemctl设置服务开机启动、不启动、查看各级别下服务启动状态等常用命令
```sh
System V init命令（RHEL 6系统）	systemctl命令（RHEL 7系统）	作用  

chkconfig foo on	systemctl enable foo.service	开机自动启动
chkconfig foo off	systemctl disable foo.service	开机不自动启动
chkconfig foo	systemctl is-enabled foo.service	查看特定服务是否为开机自启动
chkconfig --list	systemctl list-unit-files --type=service	查看各个级别下服务的启动与禁用情况
```
## [Shell 中的变量作用域](http://harttle.land/2017/04/03/shell-variable-scope.html)

## [Shell 变量引用和字符串处理](https://liam0205.me/2016/11/08/Shell-variable-reference-and-string-cut-off/)

## 设置别名 /etc/bashrc
```shell
alias cd1="cd ../"
alias cd2="cd ../../"
alias cd4="cd ../../../../"
alias cd3="cd ../../../"
alias grep="grep --color"
alias egrep="egrep --color"
```
## [shell 基本语法](https://www.linuxprobe.com/chapter-04.html#423)
* shell下的“逻辑值”是什么：是程序结束后的返回值，如果成功返回，则为真 0，如果不成功返回，则为假 1;    
true和false它们本身并非逻辑值，它们是shell内置命令，返回了“逻辑值”

* if后面是一个命令(严格来说是list)  
根据bash的定义，list就是若干个使用管道，；，&，&&，||这些符号串联起来的shell命令序列，结尾可以；，&或换行结束。这个定义可能比较复杂，如果暂时不能理解，大家直接可以认为，if后面跟的就是个shell命令。换个角度说，bash编程仍然贯彻了C程序的设计哲学，即：一切皆表达式。
* 一切皆表达式这个设计原则，确定了shell在执行任何东西（注意是任何东西，不仅是命令）的时候都会有一个返回值，因为根据表达式的定义，任何表达式都必须有一个值。在bash编程中，这个返回值也限定了取值范围：0-255。跟C语言含义相反，bash中0为真（true），非0为假（false）。这就意味着，任何给bash之行的东西，都会反回一个值
* case分支和for循环,跟if 和 while，until 不同，它们所判断的不再是“表达式”是否为真，而是去匹配字符串。
* 在[] 表达式中，常见的>,<需要加转义字符，表示字符串大小比较，以acill码 位置作为比较。 不直接支持<>运算符，还有逻辑运算符|| && 它需要用-a[and] –o[or]表示
* [[]] 运算符只是[]运算符的扩充。能够支持<,>符号运算不需要转义符，它还可以以字符串比较大小。里面支持逻辑运算符：|| &&；可以支持的判断参数 用help test
* 逻辑运算符
1.	关于档案与目录的侦测逻辑卷标！  

-f	常用！侦测『档案』是否存在 eg: if [ -f filename ]  
-d	常用！侦测『目录』是否存在  
-b	侦测是否为一个『 block 档案』  
-c	侦测是否为一个『 character 档案』  
-S	侦测是否为一个『 socket 标签档案』  
-L	侦测是否为一个『 symbolic link 的档案』  
-e	侦测『某个东西』是否存在！  
2.	关于程序的逻辑卷标！

-G	侦测是否由 GID 所执行的程序所拥有  
-O	侦测是否由 UID 所执行的程序所拥有  
-p	侦测是否为程序间传送信息的 name pipe 或是 FIFO （老实说，这个不太懂！）  

3.	关于档案的属性侦测！

-r	侦测是否为可读的属性  
-w	侦测是否为可以写入的属性  
-x	侦测是否为可执行的属性  
-s	侦测是否为『非空白档案』  
-u	侦测是否具有『 SUID 』的属性  
-g	侦测是否具有『 SGID 』的属性  
-k	侦测是否具有『 sticky bit 』的属性  
4.	两个档案之间的判断与比较 ；例如[ test file1 -nt file2 ]

-nt	第一个档案比第二个档案新  
-ot	第一个档案比第二个档案旧  
-ef	第一个档案与第二个档案为同一个档案（ link 之类的档案）  
5.	逻辑 

&&	逻辑的 AND 的意思    
||	逻辑的 OR 的意思   
叹号 ! 代表对命令(表达式)的`返回值`取反   
6. 三元    

`nginx -s reload &&  echo 'nginx 重新载入成功' || echo 'nginx 重新载入失败'`

* 运算符  

=~  子字符串包含关系  
=	等于 应用于：整型或字符串比较 如果在[] 中，只能是字符串  
!=	不等于 应用于：整型或字符串比较 如果在[] 中，只能是字符串  
<	小于 应用于：整型比较 在[] 中，不能使用 表示字符串  
`>`大于 应用于：整型比较 在[] 中，不能使用 表示字符串  
-eq	等于 应用于：整型比较  
-ne	不等于 应用于：整型比较  
-lt	小于 应用于：整型比较  
-gt	大于 应用于：整型比较  
-le	小于或等于 应用于：整型比较  
-ge	大于或等于 应用于：整型比较  
-a	双方都成立（and） 逻辑表达式 –a 逻辑表达式  
-o	单方成立（or） 逻辑表达式 –o 逻辑表达式  
-z	空字符串  
-n	非空字符串  

* 脚本参数

$0：当前运行的命令名。  
$n：n是一个数字，表示第n个参数。  
$#：参数个数。  
$*：所有参数列表。  
$@：同上。  
$?：上一个命令的返回值。  
$$：当前shell的PID。  
$!：最近一个被放到后台任务管理的进程PID。  
$-：列出当前bash的运行参数，比如set -v或者-i这样的参数。  
$_ ： "_"算是所有特殊变量中最诡异的一个了，在bash脚本刚开始的时候，它可以取到脚本的完整文件名。当执行完某个命令之后，它可以取到，这个命令的最后一个参数。当在检查邮件的时候，这个变量帮你保存当前正在查看的邮件名。  
上述所有取值都可以写成${}的方式，因为bash中对变量取值有两种写法，另外一种是${aaa}。  

### dirname
输出已经去除了尾部的”/”字符部分的名称；如果名称中不包含”/”，则显示”.”(表示当前目录)。
```sh
echo "`dirname $0`"
echo "$0"

./test_files/love
./test_files/love/test.sh
```
### 内建命令shift可以用来对参数进行位置处理，它会将所有参数都左移一个位置，可以用来进行参数处理。

### declare

设定变量值和属性。
    
    声明变量并且赋予它们属性。如果没用给定名称，
    则显示所有变量的属性和值。
    
    选项：
      -f	限制动作或显示为只函数名称和定义
      -F	限制仅显示函数名称 (以及行号和源文件名，当调试时)
      -g	当用于 shell 函数内时创建全局变量; 否则忽略
      -p	显示每个 NAME 变量的属性和值
    
    设定属性的选项：
      -a	使 NAME 成为下标数组 (如果支持)
      -A	使 NAME 成为关联数组 (如果支持)
      -i	使 NAME 带有 `integer' (整数)属性
      -l	将 NAME 在赋值时转为小写
      -n	使 NAME 成为指向一个以其值为名称的变量的引用
      -r	将 NAME 变为只读
      -t	使 NAME 带有 `trace' (追踪)属性
      -u	将 NAME 在赋值时转为大写
      -x	将 NAME 导出
    
    用 `+' 代替 `-' 会关闭指定选项。
    
    带有整数属性的变量在赋值时将使用算术估值(见
    `let' 命令)
    
    在函数中使用时，`declare' 使 NAME 成为本地变量，和 `local'
    命令一致。`-g' 选项抑制此行为。
    
    退出状态：
    返回成功除非使用了无效选项或者发生错误。


### [数组](https://blog.csdn.net/SunnyYoona/article/details/51526312)
```sh
#!/bin/bash
#定义一个一般数组
declare -a array

#为数组元素赋值
array[0]=1000
array[1]=2000
array[2]=3000
array[3]=4000

#直接使用数组名得出第一个元素的值
echo $array
#取数组所有元素的值
echo ${array[*]}
echo ${array[@]}
#取第n个元素的值
echo ${array[0]}
echo ${array[1]}
echo ${array[2]}
echo ${array[3]}
#数组元素个数
echo ${#array[*]}
#取数组所有索引列表
echo ${!array[*]}
echo ${!array[@]}

#定义一个关联数组
declare -A assoc_arr

#为关联数组赋值
assoc_arr[zorro]='zorro'
assoc_arr[jerry]='jerry'
assoc_arr[tom]='tom'

#所有操作同上
echo $assoc_arr
echo ${assoc_arr[*]}
echo ${assoc_arr[@]}
echo ${assoc_arr[zorro]}
echo ${assoc_arr[jerry]}
echo ${assoc_arr[tom]}
echo ${#assoc_arr[*]}
echo ${!assoc_arr[*]}
echo ${!assoc_arr[@]}

declare -A assoc_arr=([zorro]="zorro" [tom]="tom" [jerry]="jerry" )

unset 命令可以消除一个数组或数组的成员变量
```

### 特殊符号

#### {}
* 用类似枚举的方式创建一些目录  
```sh
mkdir -p test/zorro/{a,b,c,d}{1,2,3,4}  
ls test/zorro/  
a1  a2  a3  a4  b1  b2  b3  b4  c1  c2  c3  c4  d1  d2  d3  d4  
```
* mv test/{a,c}.conf  
意思是 mv test/a.conf test/c.conf

#### ～
在bash中一般表示用户的主目录。cd ~表示回到主目录。cd ~zorro表示回到zorro用户的主目录。

## 变量扩展

#### 变量：我们都知道取一个变量值可以用$或者${}。在使用${}的时候可以添加很多对变量进行扩展操作的功能，注意字符串与变量拼接正确方式，是用${}取变量值
```sh
${!PARAMETER} 被引用的参数不是 PARAMETER 自身，而是 PARAMETER 的值

${PARAMETER^} 大写
${PARAMETER^^}
${PARAMETER,} 小写
${PARAMETER,,}
${PARAMETER~} 相反
${PARAMETER~~}

${!PREFIX*}
${!PREFIX@}
这种扩展将列出以字符串 PREFIX 开头的所有变量名。默认情况下列出的这些变量名之间将以空格分隔。


variable 变量不被更改:
${variable:-val}
如果变量variable是空值或者没有赋值，则此表达式取值为val，variable变量不被更改，以后还是空。如果variable已经被赋值，则此表达式取值为variable 变量值;如果省略符号 “:“，即第二种形式，只有参数 PARAMETER 是未定义时，才会使用 val
${variable:+val}
与上面相反,有值时使用替代值
---
variable 变量被更改：
${variable:=val}
variable未被赋值，则赋值成＝后面的值
---
${aaa:?unset}
判断变量是否未定义或为空，如果符合条件，就提示？后面的字符串。并输出标准错误，命令返回值为1；如果已被赋值，则表达式值为变量值
${varName? Error: The varName is not defined}
如果 varName 是未定义的，此语句将返回一个错误，并显示“?”定义的错误信息。变量为空，则返回空
---
取字符串偏移量，表示取出aaa变量对应字符串的第10个字符之后的字符串(起始索引为0，闭区间，如果省略 count，将截取到参数值得末尾)，第二个数字表示取多长，变量原值不变。
${aaa:start:count}
从右边第几个字符开始，（起始索引为0-1，闭区间），及字符的个数
echo ${var:0-7:3}
---
字符串匹配截取：常被被用于提取文件名
匹配左删除
${path-var#path-parrtern} ${path-var##path-parrtern}
#：从前到后，匹配第一个 最小限度从前面截取word
##：从前到后，匹配最后一个, 最大限度从前面截取word
变量path-var看做字符串从左往右找到第一个匹配字串，取其后面的字串
匹配右删除
%：从后到前，匹配第一个，% 最小限度从后面截取word
%%：从后到前，匹配最后一个，% 最大限度从后面截取word
${path-var%path-parrtern} ${path-var%%path-parrtern}

---
字符串替换，将pattern匹配到的第一个字符串替换成string，pattern可以使用通配符
${var/pattern/string}
全局替换
${var//pattern/string}
如果没有指定替换字符串 STRING，那么匹配的内容将会被替换为空字符串，即被删除。注意模式中的空格：
---
${!B*}
${!B@}
取出所有以B开头的变量名,请注意他们跟数组中相关符号的差别
---
大写转换
${str-var^} ${str-var^^} 首字母 全局
小写转换
${str-var,} ${str-var,,} 首字母 全局
---
${#aaa}
取变量长度
```
### bash会执行放在``号中的命令。在某些情况下双反引号的表达能力有欠缺，比如嵌套的时候就分不清到底是谁嵌套谁？所以bash还提供另一种写法，跟这个符号一样就是$()。

## [expr](http://man.linuxde.net/expr)
```sh
expr的常用运算符：只支持整数运算，与 let 命令相反，表达式中的运算符左右必须包含空格，如果不包含空格，将会输出表达式本身。

加法运算：+
减法运算：-
乘法运算：\*
除法运算：/
求摸（取余）运算：%

result=`expr 2 \* 3`
result=$(expr $no1 + 5)

$[]或者 $(())可以得到一个算数运算的值
echo $[213*456]
这个运算只支持整数，并且对与小数只娶其整数部分（没有四舍五入，小数全舍,有待确定），算术表达式中的所有符号都会进行参数扩展、字符串扩展、命令替换和引用去除。算术表达式也可以是嵌套的。

let命令按照从左到右的顺序将提供给它的每一个参数进行算术运算。当最后一个参数的求值结果为真时，let命令返回退出码 0，否则返回 1。

let命令的功能与算术扩展基本相同。但是 let 语句要求默认情况下在任何操作符的两边不能含有空格，即所有算术表达式要连接在一起。如要在算术表达式中使用空格，就必须使用双引号将表达式括起来。

i=2
let ++i
let i=i**2
let的另外一种写法是(())
((i+=4))
((i=i**7))
```

### 进程置换
<(list) 和 >(list)
这两个符号可以将list的执行结果当成别的命令需要输入或者输出的文件进行操作，这个符号会将相关命令的输出放到/dev/fd中创建的一个管道文件中，并将管道文件作为参数传递给相关命令进行处理。

### 路径匹配扩展 shopt -s extglob

?(pattern-list)：匹配所给pattern的0次或1次；   
*(pattern-list)：匹配所给pattern的0次以上包括0次；  
+(pattern-list)：匹配所给pattern的1次以上包括1次；   
@(pattern-list)：匹配所给pattern的1次；   
!(pattern-list)：匹配非括号内的所给pattern。  



# linux shell通配符(wildcard) [转载](http://www.cnblogs.com/chengmo/archive/2010/10/17/1853344.html)
通配符是由shell处理的（不是由所涉及到命令语句处理的，其实我们在shell各个命令中也没有发现有这些通配符介绍）, 它只会出现在 命令的“参数”里（它不用在 命令名称里， 也不用在 操作符上）。当shell在“参数”中遇到了通配符时，shell会将其当作路径或文件名去在磁盘上搜寻可能的匹配：若符合要求的匹配存在，则进行代换(路径扩展)；否则就将该通配符作为一个普通字符传递给“命令”，然后再由命令进行处理。总之，通配符 实际上就是一种shell实现的路径扩展功能。在 通配符被处理后, shell会先完成该命令的重组，然后再继续处理重组后的命令，直至执行该命令。

## 字符	含义
* `*`	匹配 0 或多个字符 
* **表示任意一层子目录 
* ?	匹配任意一个字符  
* [list]	匹配 list 中的任意单一字符  
* [!list]	匹配 除list 中的任意单一字符以外的字符  
* [c1-c2]	匹配 c1-c2 中的任意单一字符 如：[0-9] [a-z]  
* {string1,string2,...}	匹配 sring1 或 string2 (或更多)其一字符串
* {c2..c2}	匹配 c1-c2 中全部字符 如{1..10}  
#### 需要说明的是：通配符看起来有点象正则表达式语句，但是它与正则表达式不同的，不能相互混淆。把通配符理解为shell 特殊代号字符就可。而且涉及的只有，*,? [] ,{} 这几种。

## shell元字符（特殊字符 Meta）
* IFS	由 `<space>` 或 `<tab>` 或 `<enter>` 三者之一组成(我们常用 space )。  
* CR	由 `<enter>` 产生。  
* =	设定变量。  
* $	作变量或运算替换(请不要与 shell prompt 搞混了)。  
* `>`	重导向 stdout。 *  
* <	重导向 stdin。 *  
* |	命令管线。 *  
* &	重导向 file descriptor ，或将命令置于背境执行。或并行执行执行命令。例如：`npm run script1.js & npm run script2.js`  
* ( )	将其内的命令置于 nested subshell 执行，或用于运算或命令替换。 *  
* { }	将其内的命令置于 non-named function 中执行，或用在变量替换的界定范围。
```sh
{
    read line1
    read line2
} < $file

```

* ;	在前一个命令结束时，而忽略其返回值，继续执行下一个命令。 *  
* &&	在前一个命令结束时，若返回值为 true，继续执行下一个命令。 *  
* ||	在前一个命令结束时，若返回值为 false，继续执行下一个命令。 *  
* !	执行 history 列表中的命令。*  
#### 加入”*” 都是作用在命令名直接。可以看到shell 元字符，基本是作用在命令上面，用作多命令分割（或者参数分割）。因此看到与通配符有相同的字符，但是实际上作用范围不同。所以不会出现混淆。

#### 以下是man bash 得到的英文解析：
```shell
metacharacter  
              A character that, when unquoted, separates words.  One of the following:  
              |  & ; ( ) < > space tab  
control operator   
              A token that performs a control function.  It is one of the following symbols:
              || & && ; ;; ( ) | <newline>
```

## [shopt](http://man.linuxde.net/shopt)


## [sed](https://qianngchn.github.io/wiki/4.html)
Stream Editor文本流编辑，sed是一个“非交互式的”面向字符流的编辑器。能同时处理多个文件多行的内容，可以不对原文件改动，把整个文件输入到屏幕,可以把只匹配到模式的内容输入到屏幕上。还可以对原文件改动，但是不会再屏幕上返回结果。
### 保持和获取：h命令和G命令  
在sed处理文件的时候，每一行都被保存在一个叫模式空间的临时缓冲区中，除非行被删除或者输出被取消(例如使用 -n 参数后，只有经过 sed 处理的行才会被显示输出)，否则所有被处理的行都将 打印在屏幕上。接着模式空间被清空，并存入新的一行等待处理。

`sed -e '/test/h' -e '$G' file`  
在这个例子里，匹配test的行被找到后，将存入模式空间，h命令将其复制并存入一个称为保持缓存区的特殊缓冲区内。第二条语句的意思是，当到达最后一行后，G命令取出保持缓冲区的行，然后把它放回模式空间中，且追加到现在已经存在于模式空间中的行的末尾。在这个例子中就是追加到最后一行。简单来说，任何包含test的行都被复制并追加到该文件的末尾。


### sed命令的语法格式：

sed的命令格式： sed [option] 'sed command' filename

sed的脚本格式：sed [option] -f 'sed script' filename

### sed命令的选项(option)：

-n ：只打印模式匹配的行

-e ：直接在命令行模式上进行sed动作编辑，此为默认选项，多个选项，每个操作用 -e 参数,按顺序执行

-f ：将sed的动作写在一个文件内，用–f filename 执行filename内的sed动作

-r ：支持扩展表达式

-i ：直接修改文件内容

### 定界符
/ 或其他
## sed在文件中查询文本的方式：

#### 1. 使用行号，可以是一个简单数字，或是一个行号范围

x x为行号，从1开始,$ 表示最后一行，

x,y 表示行号从x到y

* 选定行的范围：,（逗号）

sed '/test/,/west/s/$/aaa bbb/' file 对于模板test和west之间的行，每行的末尾用字符串aaa bbb替换：

/pattern/ 查询包含模式的行

/pattern/pattern/ **按顺序**，查找匹配模式的行

/pattern/,x **按顺序**在给定行号上查询包含模式的行

x,/pattern/  **按顺序**通过行号和模式查询匹配的行

x,y! **取反**查询不包含指定行号x和y的行

* 已匹配字符串标记&  
echo this is a test line | sed 's/\w\+/[&]/g'

* 多表达式  分号 **；** ，逻辑和   
sed '表达式; 表达式'
例子：  
`sed -n '/wf/,/jj/p' ori.txt`

#### 2. 使用正则表达式、扩展正则表达式(必须结合-r选项)

## sed的编辑命令(sed command)
#### 对文件的操作无非就是”增删改查“
* p 打印  
sed -n '2p'   
-n 表示，不处理的行，不打印；p 即 print，2p 表示打印第二行。
* d 删除  
sed '/^$/d' file 删除空白行
* s 替换  
nl err.txt |sed 's/s/A/'  默认只匹配一次 
sed 's/sk/SK/3g' /ng 全行内匹配（n 列索引）

sed -i 's/\r$//' 行尾的\r替换为空白(Windows下每一行结尾是\n\r，而Linux下则是\n,cat -A 全部显示，包括回车换行)
* 从文件读入：r命令  
file里的内容被读进来，显示在与test匹配的行后面，如果匹配多行，则file的内容将显示在所有匹配行的下面：    

sed '/test/r file' filename  
* 写入文件：w命令    
在example中所有包含test的行都被写入file里：

sed -n '/test/w file' example  
* 追加（行下）：a\命令  
将 this is a test line 追加到 以test 开头的行后面：  

sed '/^test/a\this is a test line' file   
在 test.conf 文件第2行之后插入 this is a test line：

sed -i '2a\this is a test line' test.conf  
* 插入（行上）：i\命令   
将 this is a test line 追加到以test开头的行前面：  

sed '/^test/i\this is a test line' file  
在test.conf文件第5行之前插入this is a test line：  

sed -i '5i\this is a test line' test.conf  
* 下一个：n命令  
如果test被匹配，则移动到匹配行的下一行，替换这一行的aa，变为bb，并打印该行，然后继续：  
 
sed '/test/{ n; s/aa/bb/; }' file  

## [awk](http://einverne.github.io/post/2018/01/awk.html)

* [ruanyifeng awk](http://www.ruanyifeng.com/blog/2018/11/awk.html)

## curl
* https://curl.haxx.se/download/
* `wget https://curl.haxx.se/download/curl-7.53.1.tar.gz`
* 使用
```sh
curl
 Transfers data from or to a server.
 Supports most protocols, including HTTP, FTP, and POP3.

curl 127.0.0.1:9999/fd/file/upload -F "file=@/Users/yons/Downloads/test.jpg" -v

 Download the contents of an URL to a file:
 curl http://example.com -o filename

 Download a file, saving the output under the filename indicated by the URL:
 curl -O http://example.com/filename

 Download a file, following [L]ocation redirects, and automatically [C]ontinuing (resuming) a previous file transfer:
 curl -O -L -C - http://example.com/filename

  send params of get request 
  curl "http://ip:port/aa/bb/c?key1=value1&key2=value2"

 Send form-encoded data (POST request of type `application/x-www-form-urlencoded`):
 curl -XPOST  -d 'params=1565432215833 requestId&start=2019-08-09 00:00:00&end=2019-08-12 00:00:00' http://192.168.15.167:18095/es

 Send a request with an extra header, using a custom HTTP method:
 curl -H 'X-My-Header: 123' -X PUT http://example.com

 Send data in JSON format, specifying the appropriate content-type header:
 curl -X PUT -d '{"name":"bob"}' -H 'Content-Type: application/json' http://example.com/users/1234

 Pass a user name and password for server authentication:
 curl -u myusername:mypassword http://example.com

 Pass client certificate and key for a resource, skipping certificate validation:
 curl --cert client.pem --key key.pem --insecure https://example.com

curl -fsSL:
-f fail
-s silently
-S --show-error
-L -L/--location


```
* [curl网站开发 by ruanyf](http://www.ruanyifeng.com/blog/2011/09/curl.html)

## wget
* `wget -P dir url`
## [gpg](https://www.ruanyifeng.com/blog/2013/07/gpg.html)

*  Debian / Ubuntu 环境  
sudo apt-get install gnupg

* Fedora 环境  
yum install gnupg

gpg --help

* GnuPG1 与 GnuPG2 、GnuPG2.1 区别  

GnuPG 1  
gpg 仍然保留用作嵌入式和服务器端使用，这个更少依赖以及更小的二进制文件。 来自 man gpg :

This is the standalone version of gpg. For desktop use you should consider using gpg2.

GnuPG 2  
gpg2 是 gpg 的重新设计版本—— 但是更多的是在内部级别的更改。较新的版本分为多个模块，例如，有可用于 X.509 的模块

来自 man gpg2

In contrast to the standalone version gpg, which is more suited for server and embedded platforms, this version is commonly installed under the name gpg2 and more targeted to the desktop as it requires several other modules to be installed.

GnuPG 2.1  
GnuPG 2.1是一个重要的变化，它将以前分开的公钥和私钥（pubring.gpg vs secring.gpg）组合到公钥匙中。这是以兼容的方式实现的，所以当GnuPG 2.1集成了私有密钥环时，您仍然可以使用GnuPG 1，但私有密钥的更改不会出现在相应的其他实现中。

[…]允许与GnuPG 2.1共同存在较旧的GnuPG版本。 然而，使用新gpg的私钥的任何更改在使用2.1版本的GnuPG之前都不会出现，反之亦然。
## apt-get
* 配置文件  
/etc/apt/sources.list
* 添加第三方源  
`apt-get install software-properties-common`  
```sh
sudo add-apt-repository \
   "deb [arch=amd64] https://mirrors.ustc.edu.cn/docker-ce/linux/debian \
   $(lsb_release -cs) \
   stable"
```

## date
-d<字符串>：显示字符串所指的日期与时间。字符串前后必须加上双引号；  
-s<字符串>：根据字符串来设置日期与时间。字符串前后必须加上双引号；  

自定义你的日期格式, 使用加号 (+)
* date "+%Y-%m-%d %H:%M:%S"

date -d "1 days ago" +%Y-%m-%d
day1=2015-10-10
day2=2015-09-27

time1=`date +%s -d "$day1"`
time2=`date +%s -d "$day2"`
 
days=$((($time1-$time2)/86400))
echo $days
date -d "2012-04-10 -1 day " +%Y-%m-%d
date -d "+1 month " +%Y-%m-%d
date -d "-1 year " +%Y-%m-%d
date -d "-1 week " +%Y-%m-%d
date -d "+1 week " +%Y-%m-%d
* 时间同步  
`ntpdate -u ntp.api.bz`  
ntp.aliyun.com
date -s 01/03/2017  
date -s 17:55:55
hwclock –w 将系统时钟同步到硬件时钟  
hwclock --show   
* 查看时区  
`date "+%Z"`
date -R
## tar 加密
```sh
tar -zcvf - $date.sql|openssl des3 -salt -k password -out $tarBackup/$date.tar.gz
或者
tar -zcvf - pma|openssl des3 -salt -k password | dd of=pma.des3
解压
dd if=pma.des3 |openssl des3 -d -k password|tar zxf -
```

## 生成一个1GB大小的文件

dd if=/dev/zero of=/tmp/test.zero bs=1M count=1024


## 分卷压缩解压
```sh
# 分卷压缩gz
tar zcf - 2017.log |split -d -C 100m - logs.tar.gz.
# 生成文件： 
logs.tar.gz.00 logs.tar.gz.01
# 分卷压缩bz2
tar jcf - 2017.log |split -d -b 100m - logs.tar.bz2.
# 生成文件：
logs.tar.bz2.00 logs.tar.bz2.01
# 解压gz分卷
cat logs.tar.gz* | tar zx
# 解压bz2分卷
cat logs.tar.gz* | tar jx

``` 

## tee
把stdin 重定向到给定文件和stdout上。  
存在缓存机制，每1024个字节将输出一次。若从管道接收输入数据，应该是缓冲区满，才将数据转存到指定的文件中。若文件内容不到1024个字节，则接收完从标准输入设备读入的数据后，将刷新一次缓冲区，并转存数据到指定文件。

* -a：向文件中重定向时使用追加模式；

## [dig](http://roclinux.cn/?p=2449)

## 查看外网 ip
* curl ip.cn
* `curl cip.cc`
* `curl ifconfig.me`  

## sh, source, exec 执行脚本区别
* ## 父子进程
fork是linux的系统调用，用来创建子进程（child process）。子进程是父进程(parent process)的一个副本，从父进程那里获得一定的资源分配以及继承父进程的环境。子进程与父进程唯一不同的地方在于pid（process id）。

    环境变量（传给子进程的变量，遗传性是本地变量和环境变量的根本区别）只能单向从父进程传给子进程。不管子进程的环境变量如何变化，都不会影响父进程的环境变量。
* 使用 sh script.sh执行脚本时，当前shell是父进程，生成一个子shell进程，在子shell中执行脚本。脚本执行完毕，退出子shell，回到当前shell。  
`./script.sh 与 sh script.sh等效`
* source命令也称为“点命令”，也就是一个点符号（.）。在当前上下文中执行脚本，不会生成新的进程。脚本执行完毕，回到当前shell。因此当前上下文的变量对该脚本是可见的。 source命令通常用于重新执行刚修改的初始化文件，使之立即生效，而不必注销并重新登录。 
`source filename 或 . filename`

* 使用exec command方式，会用command进程替换当前shell进程，并且保持PID不变。执行完毕，直接退出，不回到之前的shell环境。

* 在sh和source方式下，脚本执行完毕，都会回到之前的shell中。但是两种方式对上下文的影响不同

## shell内置变量 都需要加双引号
`$*` is a single string, whereas `$@` is an actual array

## xargs

* xargs的默认命令是echo，空格是默认定界符。这意味着通过管道传递给xargs的输入将会包含换行和空白，不过通过xargs的处理，换行和空白将被空格取代。xargs是构建单行命令的重要组件之一。使用-I指定一个替换字符串{}，这个字符串在xargs扩展时会被替换掉，当-I与xargs结合使用，每一个参数命令都会被执行一次：
* 目录下的所有文件中查找字符串  
find .| xargs grep -rn patern   
find . -type f -name "*.log" -print0 | xargs -0 rm -f
* 7天前的日志备份到特定目录
find . -mtime +7 | xargs -t -I '{}' mv {} /tmp/otc-svr-logs/

* 批量解压
ls *.tar.gz | xargs -n1 tar xzvf

## 清空文件
`:> /tmp/out`  
":"是一个内建命令，跟true是同样的功能，所以没有任何输出(返回退出状态码 0)，所以这个命令清空文件的作用。

## sort 
* 不使用任何选项时，sort 命令将简单地将文件按字母的顺序进行排序，注意，sort命令并不会改变源文件的实际内容
* -u 去掉重复的行
* -n 按数字升序
* -r 降序
*  -t 选项指定列的分隔符；使用 -k 选项指定进行排序的列。也可以在 -k1 之后，加上 -n 选项，使得第一列按照数值大小的顺序排列

`sort < file`

## 暂时停止使用某个别名，调用实际的命令
`\rm`

## set shopt 
我们可以通过开启或关闭 Bash 的相关选项控制 Bash 的行为，不同的选项使用不同的开启和关闭的方法。Bash 内置命令 set 控制一组选项，而 shopt 控制另一组选项。

* set 可以设置的 Bash 选项，我们可以通过在命令行输入 set -o 来列出：

* 开启 set -o feature-name
* 关闭 set +o feature-name
* 查看 shopt 控制的 Bash 选项及其状态，可以通过在命令行输入 shopt 来列出：
* shopt -s freature-name # 开启一个 Bash 选项
* shopt -u freature-name # 关闭一个 Bash 选项

## tail

* tail -f var/debug.log --retry  
持续尝试打开一个稍后才会创建或暂时不可用的文件。
* tail -f var/debug.log --pid=9527  
--pid 和 -f 选项一同服用，可以在特定的进程结束时终结 tail 命令。

## file
* -i 选项，可以使用 MIME 类型的格式显示文件类型信息

## who
who 命令，不指定参数，将显示当前登录的所有用户的信息

使用 -b 选项，显示系统的启动时间

使用 -l 选项，显示系统登录进程

使用 -m 选项，将只显示与当前标准输入关联的用户信息

使用 -r 选项，将显示系统的运行级别

使用 -q 选项，将只显示所有登录用户的用户名和登录的用户数

## paste
* paste 命令合并文件，各文件中的各行将以制表符（Tab）作为分隔符进行合并并输出
*  -d 选项，可以指定各个文件中的各行在合并时所使用的分隔符, 可指定多个
*  -s 选项，paste 命令可以顺序地合并文件，即它顺序地将每个文件中的所有行的内容合并为一行，由此每个文件的内容被合并为单一的一行：


## mail
* mail -f 
* h 显示当前的邮件列表
* d 删除当前邮件，指针并下移。 d 1-100 删除第1到100封邮件
* x 退出mail命令平台，并不保存之前的操作，比如删除邮件
* q 退出mail命令平台,保存之前的操作，比如删除已用d删除的邮件，已阅读邮件会转存到当前用户家目

## split
split [-bl] file [prefix]  
-a     generate suffixes of length N (default 2)  
-d     use numeric suffixes starting at 0, not alphabetic  

split -b 10k date.file -d -a 3 split_file

## cut 
cut [选项] 文件  
是一个将文本按列进行划分的文本处理工具。cut命令逐行读入文本，然后按列划分字段并进行提取、输出等操作   
-f 列号     （ --field 提取第几列,从1 开始，多列用，分隔 ）  
-d 分隔符    （ --delimiter 按照指定分隔符分割列,cut的默认分割符是制表符 ）

提取系统的用户名和uid：  
cut -d: -f1-3,7 /etc/passwd

## grep，zgrep

* grep [option] pattern files

* 带 z 的命令都包含在 Zutils 这个工具包中，这个工具包还提供了

zcat  解压文件并将内容输出到标准输出  
zcmp  解压文件并且 byte by byte 比较两个文件  
zdiff 解压文件并且 line by line 比较两个文件  
zgrep 解压文件并且根据正则搜索文件内容  
ztest - Tests integrity of compressed files.  
zupdate - Recompresses files to lzip format.  
这些命令支持 bzip2, gzip, lzip and xz 格式。

## 软连接
* 删除链接

rm -rf symbolic_name 注意不是rm -rf symbolic_name/

* 更新
ln -snf 【新目标目录】 【软链接地址】


* 统计行数
find ./ -name "*.txt*" |xargs cat|grep -v ^$|wc -l

## pwdx
显示进程的当前工作路径

## rsync
yum -y install rsync  
#启动rsync服务
systemctl start rsyncd.service
systemctl enable rsyncd.service

rsync -rvl test hadoop202:~
选项: r: 递归 v: 显示复制过程 l: copy符号链接(软链接)

#检查是否已经成功启动
netstat -lnp|grep 873

## tr
tr 命令用于转换或删除文件中的字符
tr 指令从标准输入设备读取数据，经过字符串转译后，将结果输出到标准输出设备。


## umask
umask值则表明了需要从默认权限中去掉哪些权限来成为最终的默认权限值
umask 查看
umask 027 设置
 