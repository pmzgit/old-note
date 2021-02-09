# 参考
[jvm入门教程](http://www.yishuifengxiao.com/2019/06/22/jvm%E5%85%A5%E9%97%A8%E6%95%99%E7%A8%8B/#12-jvm-%E5%86%85%E5%AD%98%E6%A8%A1%E5%9E%8B)


## 命令
```sh
-XX:+HeapDumpOnOutOfMemoryError 或 XX:HeapDumpOnCtrlBreak -XX:+PrintGCDetails
jps

-q：只输出进程 ID
-m：输出传入 main 方法的参数
-l：输出完全的包名，应用主类名，jar的完全路径名
-v：输出jvm参数
-V：输出通过flag文件传递到JVM中的参数。

jps -lvm

top -Hp 67136  线程资源排行榜，按T键可对TIME倒序排列， 也就是CPU运行时间

jinfo
输出当前 jvm 进程的全部参数和系统属性

no option   输出全部的参数和系统属性
-flag  name  输出对应名称的参数
-flag [+|-]name  开启或者关闭对应名称的参数
-flag name=value  设定对应名称的参数
-flags  输出全部的参数
-sysprops  输出系统属性

java -XX:+PrintFlagsFinal -version|grep manageable

jinfo -flag +PrintGCDetails 10872

jinfo 中需要打开-XX:+PrintGC 和 -XX:+PrintGCDetails 两个选项才能开启 GC 日志，这与用命令行参数的方式实现有着细微的差别——如果你通过启动脚本（startup script）来设置参数，仅需-XX:+PrintGCDetails 即可，因为-XX:+PrintGC 会被自动打开。


jstat -<option> [-t] [-h<lines>] <vmid> [<interval> [<count>]]

# 显示Java堆详细信息
jmap -heap pid


jstack 7476
printf "%x\n" 67163
jcmd -h
```
https://www.cnblogs.com/boothsun/p/8127552.html
## 调优
https://visualvm.github.io/
```sh
ps --help a

java -Xms30m -Xmx30m -Xmn2m -XX:SurvivorRatio=8 -XX:+PrintGCDetails -XX:+PrintGCTimeStamps -XX:+HeapDumpOnOutOfMemoryError -XX:HeapDumpPath=dump/dump.hprof dump.HeapOOM


jmap -dump:live,format=b,file=dump.hprof 11172

```
### 参考
https://blog.wangqi.love/articles/Java/JVM%E8%B0%83%E4%BC%98%E5%AE%9E%E8%B7%B5.html  
https://tech.meituan.com/2017/12/29/jvm-optimize.html  
https://www.hollischuang.com/archives/2378  
https://juejin.im/post/59f02f406fb9a0451869f01c  
https://blog.csdn.net/jisuanjiguoba/article/details/80176223   
https://www.xncoding.com/2018/06/25/java/jstack.html  
https://juejin.im/post/6844904152850497543