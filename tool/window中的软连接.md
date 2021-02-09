# mklink 命令 (win7 后支持)
* cmd 下执行 `mklink /?`
```cmd
 mklink /?
创建符号链接。

MKLINK [[/D] | [/H] | [/J]] Link Target

        /D      创建目录符号链接。默认为文件
                符号链接。
        /H      创建硬链接而非符号链接。
        /J      创建目录联接。
        Link    指定新的符号链接名称。
        Target  指定新链接引用的路径
                (相对或绝对)。

```

* 符号链接or目录联接（需要管理员权限）
```sh
mklink /D aa evervue\
为 aa <<===>> evervue\ 创建的符号链接

mklink /J bb evervue\
为 bb <<===>> evervue\ 创建的联接

dir
2018/01/02  15:08    <SYMLINKD>     aa [evervue\]
2018/01/02  15:09    <JUNCTION>     bb [D:\code\evervue\]
```
* 经测试 用/J参数比较好