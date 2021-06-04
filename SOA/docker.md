## [参考：Docker — 从入门到实践](https://docker_practice.gitee.io/)
# [Docker 的版本演进](https://docs.lvrui.io/2017/03/06/Docker-%E7%9A%84%E7%89%88%E6%9C%AC%E6%BC%94%E8%BF%9B/)
# [debain安装](https://yeasy.gitbooks.io/docker_practice/install/debian.html)

* [deepin 安装docker](https://wiki.deepin.org/index.php?title=Docker)
* [免sudo使用docker命令](https://www.jianshu.com/p/95e397570896)

## [debain(deepin)](https://docs.docker.com/engine/install/debian/)
```sh
sudo aptitude update
sudo aptitude install apt-transport-https ca-certificates curl gnupg2 lsb-release software-properties-common
curl -fsSL https://mirrors.ustc.edu.cn/docker-ce/linux/debian/gpg | sudo apt-key add - 
sudo apt-key finger 0ebfcd88
sudo add-apt-repository \                                                             
   "deb [arch=amd64] https://mirrors.ustc.edu.cn/docker-ce/linux/debian \
   $(lsb_release -cs) \
   stable"

sudo add-apt-repository "deb [arch=amd64] https://mirrors.aliyun.com/docker-ce/linux/debian buster stable"
# deepin 把 $(lsb_release -cs) jessie
sudo aptitude update
sudo aptitude install docker-ce docker-ce-cli containerd.io
# 开机启动文件  /etc/systemd/system/multi-user.target.wants/docker.service → /lib/systemd/system/docker.service
sudo systemctl enable docker
sudo systemctl start docker

## 国内镜像加速器，私有镜像仓库，或者修改docker存储目录
sudo vim /etc/docker/daemon.json 文件
{
  "registry-mirrors": [
    "https://qdtqd0ze.mirror.aliyuncs.com",
    "http://hub-mirror.c.163.com",
    "https://mirror.ccs.tencentyun.com"
  ],
  "hosts": ["tcp://0.0.0.0:2379"],
  "insecure-registries" : ["registry.pmz.com:5000"]
}

{
"insecure-registries" : ["registry.pmz.com:5000","192.168.200.78","192.168.205.234:5000"],
"registry-mirrors": ["https://qdtqd0ze.mirror.aliyuncs.com"],
"graph": "/home/docker_pmz"
}

## 镜像测速

docker rmi node:latest
time docker pull wurstmeister/kafka:latest
# docker 提供了远程控制API，采用的是restful风格 
centos7开启方式： 
vim /lib/systemd/system/docker.service 
找到 ExecStart行 修改为 

ExecStart=/usr/bin/dockerd -H tcp://0.0.0.0:2375 -H unix:///var/run/docker.sock  

重载所有修改过的配置文件
$ sudo systemctl daemon-reload
sudo systemctl restart docker
docker info
vim /etc/default/grub
GRUB_CMDLINE_LINUX="cgroup_enable=memory swapaccount=1"
## 建立 docker 用户组
sudo groupadd docker
sudo usermod -aG docker $USER

```
## centos7 
curl -LO https://download.docker.com/linux/centos/7/x86_64/stable/Packages/docker-ce-19.03.12-3.el7.x86_64.rpm

## 镜像，容器，仓库
```sh

https://yeasy.gitbooks.io/docker_practice/image/manifest.html

# Linux、macOS

$ export DOCKER_CLI_EXPERIMENTAL=enabled

# Windows

$ set $env:DOCKER_CLI_EXPERIMENTAL=enabled

docker manifest inspect golang:alpine

sudo docker pull user/ubuntu:latest
docker run -it --rm \
    ubuntu:16.04 \
    bash
    一个镜像可以对应多个标签
sudo docker image ls
docker system df
docker image ls -f dangling=true
docker image prune

中间层镜像
docker image ls -a
列出部分镜像
docker image ls [OPTIONS] [REPOSITORY[:TAG]]

docker image ls -f since=mongo:3.2  #before
以特定格式显示
docker image ls --format "{{.ID}}: {{.Repository}}"
docker image ls --format "table {{.ID}}\t{{.Repository}}\t{{.Tag}}"

docker image rm [选项] <镜像1> [<镜像2> ...]

镜像短 ID、镜像长 ID、镜像名 或者 镜像摘要。

docker image ls --digests
docker image rm node@sha256:b4f0e0bdeb578043c1ea6862f0d40cc4afe32a4a582f3be235a3b164422be228

一类是 Untagged，另一类是 Deleted
实际上是在要求删除某个标签的镜像
当该镜像所有的标签都被取消了，该镜像很可能会失去了存在的意义，因此会触发删除行为。镜像是多层存储结构，因此在删除的时候也是从上层向基础层方向依次进行判断删除。镜像的多层结构让镜像复用变动非常容易，因此很有可能某个其它镜像正依赖于当前镜像的某一层。这种情况，依旧不会触发删除该层的行为。直到没有任何层依赖当前层时，才会真实的删除当前层。
除了镜像依赖以外，还需要注意的是容器对镜像的依赖。如果有用这个镜像启动的容器存在（即使容器没有运行），那么同样不可以删除这个镜像。之前讲过，容器是以镜像为基础，再加一层容器存储层，组成这样的多层存储结构去运行的。因此该镜像如果被这个容器所依赖的，那么删除必然会导致故障。如果这些容器是不需要的，应该先将它们删除，然后再来删除镜像。
docker image rm $(docker image ls -q redis)
docker image rm $(docker image ls -q -f before=mongo:3.2)
## 定制
docker commit \
    --author "Tao Wang <twang2218@gmail.com>" \
    --message "修改了默认网页" \
    webserver \
    nginx:v2

docker history nginx:v2

docker run --name web2 -d -p 81:80 --env "download_server=192.168" --env download_port=8000 nginx:v2

RUN 指令是用来执行命令行命令的。由于命令行的强大能力，RUN 指令在定制镜像时是最常用的指令之一。其格式有两种：

shell 格式：RUN <命令>，就像直接在命令行中输入的命令一样。刚才写的 Dockerfile 中的 RUN 指令就是这种格式。
RUN echo '<h1>Hello, Docker!</h1>' > /usr/share/nginx/html/index.html
exec 格式：RUN ["可执行文件", "参数1", "参数2"]，这更像是函数调用中的格式。

docker build [选项] <上下文路径/URL/->

Dockerfile 中的 ARG 指令是定义参数名称，以及定义其默认值。该默认值可以在构建命令 docker build 中用 --build-arg <参数名>=<值> 来覆盖。

docker build --no-cache -t nginx:v3 .

一般来说，应该会将 Dockerfile 置于一个空目录下，或者项目根目录下。如果该目录下没有所需文件，那么应该把所需文件复制一份过来。如果目录下有些东西确实不希望构建时传给 Docker 引擎，那么可以用 .gitignore 一样的语法写一个 .dockerignore，该文件是用于剔除不需要作为上下文传递给 Docker 引擎的。
COPY 
<源路径> 可以是多个，甚至可以是通配符，其通配符规则要满足 Go 的 filepath.Match 规则，如：
pattern:
	{ term }
term:
	'*'         matches any sequence of non-Separator characters
	'?'         matches any single non-Separator character
	'[' [ '^' ] { character-range } ']'
	            character class (must be non-empty)
	c           matches character c (c != '*', '?', '\\', '[')
	'\\' c      matches character c

character-range:
	c           matches character c (c != '\\', '-', ']')
	'\\' c      matches character c
	lo '-' hi   matches character c for lo <= c <= hi

<目标路径> 可以是容器内的绝对路径，也可以是相对于工作目录的相对路径（工作目录可以用 WORKDIR 指令来指定）。目标路径不需要事先创建，如果目录不存在会在复制文件前先行创建缺失目录。

所有的文件复制均使用 COPY 指令，仅在需要自动解压缩的场合使用 ADD。

在使用ADD指令的时候还可以加上 --chown=<user>:<group> 选项来改变文件的所属用户及所属组。

如 <源路径> 可以是一个 URL，这种情况下，Docker 引擎会试图去下载这个链接的文件放到 <目标路径> 去。下载后的文件权限自动设置为 600，如果这并不是想要的权限，那么还需要增加额外的一层 RUN 进行权限调整，另外，如果下载的是个压缩包，需要解压缩，也一样还需要额外的一层 RUN 指令进行解压缩。所以不如直接使用 RUN 指令，然后使用 wget 或者 curl 工具下载，处理权限、解压缩、然后清理无用文件更合理。因此，这个功能其实并不实用，而且不推荐使用。

容器内没有后台服务的概念

如果 <源路径> 为一个 tar 压缩文件的话，压缩格式为 gzip, bzip2 以及 xz 的情况下，ADD 指令将会自动解压缩这个压缩文件到 <目标路径> 去。

CMD 指定容器启动程序及参数 ,CMD指令就是用于指定默认的容器主进程的启动命令的
对于容器而言，其启动程序就是容器应用进程，容器就是为了主进程而存在的，主进程退出，容器就失去了存在的意义，从而退出，其它辅助进程不是它需要关心的东西。

而使用 service nginx start 命令，则是希望 upstart 来以后台守护进程形式启动 nginx 服务。而刚才说了 CMD service nginx start 会被理解为 CMD [ "sh", "-c", "service nginx start"]，因此主进程实际上是 sh。那么当 service nginx start 命令结束后，sh 也就结束了，sh 作为主进程退出了，自然就会令容器退出。

CMD ["nginx", "-g", "daemon off;"]

docker run image cmd arg
run 命令，跟在镜像名后面的是 command，运行时会替换 CMD 的默认值。

当存在 ENTRYPOINT 后，CMD（command 就是新的cmd） 的内容将会作为参数传给 ENTRYPOINT
(隐含的值：/bin/sh -c)
可以使用环境变量的原因，因为这些环境变量会被 shell 进行解析处理

这些准备工作是和容器 CMD 无关的，无论 CMD 为什么，都需要事先进行一个预处理的工作。这种情况下，可以写一个脚本，然后放入 ENTRYPOINT 中去执行，而这个脚本会将接到的参数（也就是 <CMD>）作为命令，在脚本最后执行。

ENV 设置环境变量
格式有两种：

ENV <key> <value>
ENV <key1>=<value1> <key2>=<value2>...
这个指令很简单，就是设置环境变量而已，无论是后面的其它指令，如 RUN，还是运行时的应用，都可以直接使用这里定义的环境变量。

ENV VERSION=1.0 DEBUG=on \
    NAME="Happy Feet"

ARG <参数名>[=<默认值>]
构建参数和 ENV 的效果一样，都是设置环境变量。所不同的是，ARG 所设置的构建环境的环境变量，在将来容器运行时是不会存在这些环境变量的。但是不要因此就使用 ARG 保存密码之类的信息，因为 docker history 还是可以看到所有值的。

Dockerfile 中的 ARG 指令是定义参数名称，以及定义其默认值。该默认值可以在构建命令 docker build 中用 --build-arg <参数名>=<值> 来覆盖。

EXPOSE 指令是声明运行时容器提供服务端口，这只是一个声明，在运行时并不会因为这个声明应用就会开启这个端口的服务。在 Dockerfile 中写入这样的声明有两个好处，一个是帮助镜像使用者理解这个镜像服务的守护端口，以方便配置映射；另一个用处则是在运行时使用随机端口映射时，也就是 docker run -P 时，会自动随机映射 EXPOSE 的端口。

之前说过每一个 RUN 都是启动一个容器、执行命令、然后提交存储层文件变更。第一层 RUN cd /app 的执行仅仅是当前进程的工作目录变更，一个内存上的变化而已，其结果不会造成任何文件变更。而到第二层的时候，启动的是一个全新的容器，跟第一层的容器更完全没关系，自然不可能继承前一层构建过程中的内存变化。

因此如果需要改变以后各层的工作目录的位置，那么应该使用 WORKDIR 指令。

格式：USER <用户名>[:<用户组>]

USER 指令和 WORKDIR 相似，都是改变环境状态并影响以后的层。WORKDIR 是改变工作目录，USER 则是改变之后层的执行 RUN, CMD 以及 ENTRYPOINT 这类命令的身份。

当然，和 WORKDIR 一样，USER 只是帮助你切换到指定用户而已，这个用户必须是事先建立好的，否则无法切换。

HEALTHCHECK [选项] CMD <命令>：设置检查容器健康状况的命令
HEALTHCHECK NONE：如果基础镜像有健康检查指令，使用这行可以屏蔽掉其健康检查指令

HEALTHCHECK 支持下列选项：

--interval=<间隔>：两次健康检查的间隔，默认为 30 秒；
--timeout=<时长>：健康检查命令运行超时时间，如果超过这个时间，本次健康检查就被视为失败，默认 30 秒；
--retries=<次数>：当连续失败指定次数后，则将容器状态视为 unhealthy，默认 3 次。
和 CMD, ENTRYPOINT 一样，HEALTHCHECK 只可以出现一次，如果写了多个，只有最后一个生效。

格式：ONBUILD <其它指令>。

ONBUILD 是一个特殊的指令，它后面跟的是其它指令，比如 RUN, COPY 等，而这些指令，在当前镜像构建时并不会被执行。只有当以当前镜像为基础镜像，去构建下一级镜像的时候才会被执行。

只构建某一阶段的镜像
我们可以使用 as 来为某一阶段命名，例如

FROM golang:1.9-alpine as builder
例如当我们只想构建 builder 阶段的镜像时，我们可以在使用 docker build 命令时加上 --target 参数即可

$ docker build --target builder -t username/imagename:tag .

构建时从其他镜像复制文件
上面例子中我们使用 COPY --from=0 /go/src/github.com/go/helloworld/app . 从上一阶段的镜像中复制文件，我们也可以复制任意镜像中的文件。

$ COPY --from=nginx:latest /etc/nginx/nginx.conf /nginx.conf

docker save [OPTIONS] IMAGE [IMAGE...]

docker save alpine | gzip > alpine-latest.tar.gz

docker load -i alpine-latest.tar.gz
# 容器

简单的说，容器是独立运行的一个或一组应用，以及它们的运行态环境

docker run [OPTIONS] IMAGE [COMMAND] [ARG...]
当利用 docker run 来创建容器时，Docker 在后台运行的标准操作包括：

-t 选项让Docker分配一个伪终端（pseudo-tty）并绑定到容器的标准输入上， -i 则让容器的标准输入保持打开。

检查本地是否存在指定的镜像，不存在就从公有仓库下载
利用镜像创建并启动一个容器
分配一个文件系统，并在只读的镜像层外面挂载一层可读写层
从宿主主机配置的网桥接口中桥接一个虚拟接口到容器中去
从地址池配置一个 ip 地址给容器
执行用户指定的应用程序
执行完毕后容器被终止

docker container COMMAND

容器的核心为所执行的应用程序，所需要的资源都是应用程序运行所必需的。除此之外，并没有其它的资源。可以在伪终端中利用 ps 或 top 来查看进程信息。

容器是否会长久运行，是和 docker run 指定的命令有关，和 -d 参数无关

-d 参数启动后会返回一个唯一的 id，也可以通过 docker container ls 命令来查看容器信息。
docker container logs
docker logs -f 容器名 // 所有日志

查看容器内的进程
docker top命令
终止状态的容器可以用 docker container ls -a 命令看到

在使用 -d 参数时，容器启动后会进入后台。如果想让容器一直运行，而不是停止，可以使用快捷键 ctrl+p ctrl+q 退出，此时容器的状态为Up。

* 某些时候需要进入容器进行操作，包括使用 docker attach 命令或 docker exec 命令
attach 与 exec 主要区别如下:

attach 直接进入容器 启动命令 的终端，不会启动新的进程, Ctrl+p 然后 Ctrl+q 组合键退出 attach 终端。
exec 则是在容器中打开新的终端，并且可以启动新的进程。
docker exec [OPTIONS] CONTAINER COMMAND [ARG...]

docker exec -it 69d1 bash

docker exec -it 8db8580e774b env LANG=C.UTF-8 /bin/bash

如果从这个 stdin 中 exit，不会导致容器的停止

如果想直接在终端中查看启动命令的输出，用 attach；其他情况使用 exec。

当然，如果只是为了查看启动命令的输出，可以使用 docker logs 命令

* 可以使用rm命令，注意：删除镜像前必须先删除以此镜像为基础的容器。

docker rm container_name/container_id
docker rmi image_name/image_id

docker export 7691a814370e > ubuntu.tar
docker import [OPTIONS] file|URL|- [REPOSITORY[:TAG]]

用户既可以使用 docker load 来导入镜像存储文件到本地镜像库，也可以使用 docker import 来导入一个容器快照到本地镜像库。这两者的区别在于容器快照文件将丢弃所有的历史记录和元数据信息（即仅保存容器当时的快照状态），而镜像存储文件将保存完整记录，体积也要大。此外，从容器快照文件导入时可以重新指定标签等元数据信息。

可以使用 docker container rm 来删除一个处于终止状态的容器

如果要删除一个运行中的容器，可以添加 -f 参数。Docker 会发送 SIGKILL 信号给容器。
用 docker container ls -a 命令可以查看所有已经创建的包括终止状态的容器，如果数量太多要一个个删除可能会很麻烦，用下面的命令可以清理掉所有处于终止状态的容器。

$ docker container prune

# 拷贝容器内容文件到宿主机
docker cp <CONTAINER_ID|CONTAINER_NAME>:容器的目录 宿主机的目录

# 仓库
开发和测试的仓库要隔离

#下载registry镜像
docker pull registry
# 创建仓库存放镜像的文件夹
mkdir /opt/software/docker-registry
# 镜像启动一个容器
docker run -d \
    -p 5000:5000 \
    --name registry \
    --restart=always \
    -v /opt/software/docker-registry:/var/lib/registry \
registry



# 从docker hub安装测试镜像
docker pull hello-world

# 给本地的hello-world镜像新打标签，形成新镜像
# 域名为仓库地址
docker tag IMAGE[:TAG] [REGISTRY_HOST[:REGISTRY_PORT]/]REPOSITORY[:TAG]

docker tag elasticsearch:7.1.1 192.168.205.234:5000/elasticsearch:7.1.1


# 将新镜像上传到本地私服
docker push registry.pmz.com:5000/hello-world

curl 127.0.0.1:5000/v2/_catalog

docker image rm 127.0.0.1:5000/ubuntu:latest

docker pull 127.0.0.1:5000/ubuntu:latest


{
  "registry-mirror": [
    "https://registry.docker-cn.com"
  ],
  "insecure-registries": [
    "192.168.199.100:5000"
  ]
}

```


Docker 运行在 CentOS-6.5 或更高的版本的 CentOS 上，需要内核版本是 2.6.32-431 或者更高版本 ，因为这是允许它运行的指定内核补丁版本。

# [centos7 安装](https://docs.docker.com/install/linux/docker-ce/centos/#install-from-a-package) 
* https://download.docker.com/linux/centos/7/x86_64/stable/Packages/
```sh
yum install docker-ce-selinux-17.03.3.ce-1.el7.noarch.rpm 
yum install docker-ce-17.03.3.ce-1.el7.x86_64.rpm
```

# [CentOS-6.8安装Docker1.7.1](https://www.jianshu.com/p/4e74f11ee309)
安装完成后，运行下面的命令，验证是否安装成功。


$ docker version  
$ docker info  
* man  
docker   
docker COMMAND --help
 
* [国内镜像](http://icyleaf.com/2016/12/docker-with-centos/)
```sh
# /etc/sysconfig/docker
 #
 # Other arguments to pass to the docker daemon process
 # These will be parsed by the sysv initscript and appended
 # to the arguments list passed to docker -d
 
 #other_args="--registry-mirror=http://hub-mirror.c.163.com"
 other_args="--registry-mirror=https://docker.mirrors.ustc.edu.cn"
 
 DOCKER_CERT_PATH=/etc/docker
 
 # Resolves: rhbz#1176302 (docker issue #407)
 DOCKER_NOWARN_KERNEL_VERSION=1
 
 # Location used for temporary files, such as those created by
 # # docker load and build operations. Default is /var/lib/docker/tmp
 # # Can be overriden by setting the following environment variable.
 # # DOCKER_TMPDIR=/var/tmp

```

Docker 是服务器----客户端架构。命令行运行docker命令的时候，需要本机有 Docker 服务。如果这项服务没有启动，可以用下面的命令启动（官方文档）。


*  service 命令的用法
$ sudo service docker start

*  systemctl 命令的用法
$ sudo systemctl start docker

或者  
`/usr/bin/docker -d --registry-mirror=https://docker.mirrors.ustc.edu.cn`

## [容器和镜像](http://dockone.io/article/783)



# 命令
```sh
# 批量清理已停止的容器
docker rm -f $(docker ps -qa)

# 删除没有标签的镜像
docker rmi $(docker images | grep "^<none>" | awk "{print $3}")


# 批量删除孤单的 volumes
docker volume ls -qf dangling=true
docker volume rm $(docker volume ls -qf dangling=true)

容器生命周期管理
run
start/stop/restart
kill
rm
pause/unpause
create
exec
容器操作
ps
inspect
top
attach
events
logs
wait
export
port
容器rootfs命令
commit
cp
diff
镜像仓库
login
pull
push
search
本地镜像管理
images
rmi
tag
build
history
save
import
info|version
info
version
```
* [Docker（镜像层缓存，Dockerfile调试）](https://blog.csdn.net/sfb749277979/article/details/78837646)

# Docker Machine
## 前提
* 需要配置root到服务端的无密码ssh登录。可以通过ssh-keygen、ssh-copy-id等命令实现
* 如果配置无密码登录的用户不是root用户的话，还需要在服务端上实现普通用户的无密码sudo权限。参考下面
```sh

sudo adduser nick  
passwd nick
sudo usermod -a -G sudo nick   
sudo visudo  

把下面一行内容添加到文档的最后并保存文件：

nick   ALL=(ALL:ALL) NOPASSWD: ALL

# %pmz ALL=(ALL) NOPASSWD: ALL
ssh-copy-id -i ~/.ssh/id_rsa.pub -p 10022  root@192.168.200.67

sudo curl -L https://github.com/docker/machine/releases/download/v0.16.1/docker-machine-`uname -s`-`uname -m` > /usr/local/bin/docker-machine
sudo chmod +x /usr/local/bin/docker-machine

docker-machine -v

```
* [generic](https://docs.docker.com/machine/drivers/generic/)
```sh
docker-machine create \
  --driver generic \
  --generic-ip-address=203.0.113.81 \
  --generic-ssh-key ~/.ssh/id_rsa \
  hostname
```

* [ssh登录很慢解决方法](https://www.linuxprobe.com/ssh-login-slowly.html)

# docker-compose
* INSTALL AS A CONTAINER
```sh
## https://github.com/docker/compose/releases
sudo curl -L --fail https://github.com/docker/compose/releases/download/1.23.2/run.sh -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
```
### 命令
对于 Compose 来说，大部分命令的对象既可以是项目本身，也可以指定为项目中的服务或者容器。如果没有特别的说明，命令对象将是项目，这意味着项目中所有的服务都会受到命令影响。

执行 docker-compose [COMMAND] --help 或者 docker-compose help [COMMAND] 可以查看具体某个命令的使用格式。

docker-compose 命令的基本的使用格式是

docker-compose [-f=<arg>...] [options] [COMMAND] [ARGS...]

docker-compose version

通过上述测试发现可以使用同一个配置文件启动多个redis，并且分别映射到宿主机器的不同端口上
配置文件，数据目录，日志目录，用命令指定，path 跟配置文件和应用镜像有关
### 模板
模板文件是使用 Compose 的核心，涉及到的指令关键字也比较多。但大家不用担心，这里面大部分指令跟 docker run 相关参数的含义都是类似的。模板文件名称为 docker-compose.yml，格式为 YAML 格式。


## 如何更改 Docker 的默认存储位置？

mv /var/lib/docker /storage/
ln -s /storage/docker/ /var/lib/docker


# [网络](https://docker_practice.gitee.io/underly/network.html)

```sh
# 网络
格式为 EXPOSE <端口1> [<端口2>...]。

EXPOSE 指令是声明运行时容器提供服务端口，这只是一个声明，在运行时并不会因为这个声明应用就会开启这个端口的服务。在 Dockerfile 中写入这样的声明有两个好处，一个是帮助镜像使用者理解这个镜像服务的守护端口，以方便配置映射；另一个用处则是在运行时使用随机端口映射时，也就是 docker run -P 时，会自动随机映射 EXPOSE 的端口。

此外，在早期 Docker 版本中还有一个特殊的用处。以前所有容器都运行于默认桥接网络中，因此所有容器互相之间都可以直接访问，这样存在一定的安全性问题。于是有了一个 Docker 引擎参数 --icc=false，当指定该参数后，容器间将默认无法互访，除非互相间使用了 --links 参数的容器才可以互通，并且只有镜像中 EXPOSE 所声明的端口才可以被访问。这个 --icc=false 的用法，在引入了 docker network 后已经基本不用了，通过自定义网络可以很轻松的实现容器间的互联与隔离。

要将 EXPOSE 和在运行时使用 -p <宿主端口>:<容器端口> 区分开来。-p，是映射宿主端口和容器端口，换句话说，就是将容器的对应端口服务公开给外界访问，而 EXPOSE 仅仅是声明容器打算使用什么端口而已，并不会自动在宿主进行端口映射。

-p 则可以指定要映射的端口，并且，在一个指定端口上只可以绑定一个容器。支持的格式有 ip:hostPort:containerPort/udp | ip::containerPort | hostPort:containerPort。

docker port CONTAINER [PRIVATE_PORT[/PROTO]]

docker port cid 5000

docker run -d \
    -p 5000:5000 \
    -p 3000:80 \
    training/webapp \
    python app.py

docker network create -d bridge my-net
-d 参数指定 Docker 网络类型，有 bridge overlay。其中 overlay 网络类型用于 Swarm mode，在本小节中你可以忽略它。

docker run -it --rm --name busybox1 --network my-net busybox sh

 docker network connect nw-es container_name
 docker network disconnect my_bridge alpine1

--link <name or id>:alias

name和id是源容器的name和id，alias是源容器在link下的别名。

配置全部容器的 DNS ，也可以在 /etc/docker/daemon.json 文件中增加以下内容来设置。

{
  "dns" : [
    "114.114.114.114",
    "8.8.8.8"
  ]
}

-h HOSTNAME 或者 --hostname=HOSTNAME 设定容器的主机名，它会被写到容器内的 /etc/hostname 和 /etc/hosts。但它在容器外部看不到，既不会在 docker container ls 中显示，也不会在其他的容器的 /etc/hosts 看到。

--dns=IP_ADDRESS 添加 DNS 服务器到容器的 /etc/resolv.conf 中，让容器用这个服务器来解析所有不在 /etc/hosts 中的主机名。

--dns-search=DOMAIN 设定容器的搜索域，当设定搜索域为 .example.com 时，在搜索一个名为 host 的主机时，DNS 不仅搜索 host，还会搜索 host.example.com。

注意：如果在容器启动时没有指定最后两个参数，Docker 会默认用主机上的 /etc/resolv.conf 来配置容器。
```
iptables -t nat -nL


Docker 服务默认会创建一个 docker0 网桥（其上有一个 docker0 内部接口），它在内核层连通了其他的物理或虚拟网卡，这就将所有容器和本地主机都放到同一个物理网络。

Docker 默认指定了 docker0 接口 的 IP 地址和子网掩码，让主机和容器之间可以通过网桥相互通信，它还给出了 MTU（接口允许接收的最大传输单元），通常是 1500 Bytes，或宿主主机网络路由上支持的默认值。这些值都可以在服务启动的时候进行配置。

Docker 创建一个容器的时候，会执行如下操作：

创建一对虚拟接口，分别放到本地主机和新容器中；
本地主机一端桥接到默认的 docker0 或指定网桥上，并具有一个唯一的名字，如 veth65f9；
容器一端放到新容器中，并修改名字作为 eth0，这个接口只在容器的命名空间可见；
从网桥可用地址段中获取一个空闲地址分配给容器的 eth0，并配置默认路由到桥接网卡 veth65f9。
完成这些之后，容器就可以使用 eth0 虚拟网卡来连接其他容器和其他网络。


Docker 1.2.0 开始支持在运行中的容器里编辑 /etc/hosts, /etc/hostname 和 /etc/resolv.conf 文件。

但是这些修改是临时的，只在运行的容器中保留，容器终止或重启后并不会被保存下来，也不会被 docker commit 提交。

docker network inspect nw-es
```sh
firewall-cmd --add-rich-rule='rule family name=ftp limit value=2/m accept'


firewall-cmd --permanent --add-rich-rule='rule family=ipv4 source address=10.0.0.1/24 destination address=10.0.0.1/24 accept'
firewall-cmd --permanent --add-rich-rule='rule family=ipv4 source address=172.17.0.1/24 destination address=172.17.0.1/24 accept'
firewall-cmd --permanent --add-rich-rule='rule family=ipv4 source address=172.18.0.1/24 destination address=172.17.0.1/24 accept'
firewall-cmd --permanent --add-rich-rule='rule family=ipv4 source address=192.168.108.64/24 destination address=192.168.108.64/24 accept'
firewall-cmd --reload

10.0.0.1/24 表示应用层的网络，主机间docker之间的通信
172.17.0.1/24 表示本身网，单台宿主机内的docker之间的通信
172.18.0.1/24 表示集群网 manage与worker之间通信
192.168.28.0/24 表示宿主机之间的网络
方式二
firewall-cmd --get-active-zones
firewall-cmd --zone=trusted --add-interface=docker0
firewall-cmd --get-active-zones
firewall-cmd --reload
```

* docker容器内的一个进程对应于宿主机器上的一个进程。
* 容器内的进程，与相对应的宿主进程，由相同的uid、gid拥有。也就是说，如果在容器内主进程属于用户uid=1000，那么这个容器进程在宿主机器上也属于用户uid=1000。容器内的用户uid=1000就是容器外的用户uid=1000，也是其他容器内的用户uid=1000

docker inspect -f "{{.Id}} {{.State.Pid}} {{.Config.Hostname}}"  $(docker ps -q)  
docker inspect containerId -f {{.State.Pid}}
### 参考
* http://wudaijun.com/2017/11/docker-network/
# [存储](https://suzedong.github.io/breakday-site/study/linux/DockerOverlay.html#_1-overlay%E4%BB%8B%E7%BB%8D)

* Dockerfile 构建指令：VOLUME /data

VOLUME 定义匿名卷  
格式为：

VOLUME ["<路径1>", "<路径2>"...]  
VOLUME <路径>

这里的 /data 目录就会在运行时自动挂载为匿名卷，任何向 /data 中写入的信息都不会记录进容器存储层，从而保证了容器存储层的无状态化。当然，运行时可以覆盖这个挂载设置。比如：
你可以把VOLUME理解为，从镜像中复制指定卷的文件夹到本地/var/lib/docker/volumes/xxxxxxxxx/文件夹，然后把本地的该文件夹挂载到容器里面去

docker run -d -v mydata:/data xxxx

在这行命令中，就使用了 mydata 这个命名卷挂载到了 /data 这个位置，替代了 Dockerfile 中定义的匿名卷的挂载配置。

在 Docker 内部以及容器之间管理数据，在容器中管理数据主要有两种方式：

数据卷（Volumes）

挂载主机目录 (Bind mounts)
```sh
# 数据管理
docker volume create my-vol
docker volume ls
docker volume inspect my-vol
docker volume rm my-vol

可以在删除容器的时候使用 docker rm -v ctainer_ids 这个命令。

无主的数据卷可能会占据很多空间，要清理请使用以下命令

docker volume prune

Mounts下的每条信息记录了容器上一个挂载点的信息，"Destination" 值是容器的挂载点，"Source"值是对应的主机目录。

容器共享卷（挂载点）
--volumes-from
最佳实践：数据容器

docker run -d -P \
    --name web \
    # -v my-vol:/wepapp \
    --mount type=volume,source=my-vol,target=/webapp \
    training/webapp \
    python app.py

docker run -d -P \
    --name web \
    # -v /src/webapp:/opt/webapp \
    --mount type=bind,source=/src/webapp,target=/opt/webapp \
    training/webapp \
    python app.py

docker run -d -P \
    --name web \
    # -v /src/webapp:/opt/webapp:ro \
    --mount type=bind,source=/src/webapp,target=/opt/webapp,readonly \
    training/webapp \
    python app.py



docker run -d -v mydata:/data xxxx

```

# docker swarm mode
* 并非所有服务都应该部署在Swarm集群内。数据库以及其它有状态服务就不适合部署在Swarm集群内。
* 管理节点用于 Swarm 集群的管理，docker swarm 命令基本只能在管理节点执行（节点退出集群命令 docker swarm leave 可以在工作节点执行）。一个 Swarm 集群可以有多个管理节点，但只有一个管理节点可以成为 leader，leader 通过 raft 协议实现。
* 工作节点是任务执行节点，管理节点将服务 (service) 下发至工作节点执行。管理节点默认也作为工作节点。你也可以通过配置让服务只运行在管理节点。下图展示了集群中管理节点与工作节点的关系。

再来回顾一下Docker Swarm，在我们初始化或加入Swarm集群时，通过docker network ls可以看到，Docker做了如下事情:

创建了一个叫ingress的overlay网络，用于Swarm集群容器跨主机通信，在创建服务时，如果没有为其指定网络，将默认接入到ingress网络中
创建一个docker_gwbridge虚拟网桥，用于连接集群各节点(Docker Deamon)的物理网络到到ingress网络
网络细节暂时不谈(也没怎么搞清楚)，总之，Swarm集群构建了一个跨主机的网络，可以允许集群中多个容器自由访问。Swarm集群有如下几个比较重要的特性:

服务的多个任务可以监听同一端口(通过iptables透明转发)。
屏蔽掉服务的具体物理位置，通过任意集群节点IP:Port均能访问服务(无论这个服务是否跑在这个节点上)，Docker会将请求正确路由到运行服务的节点(称为routing mesh)。在routine mesh下，服务运行在虚拟IP环境(virtual IP mode, vip)，即使服务运行在global模式(每个节点都运行有任务)，用户仍然不能假设指定IP:Port节点上的服务会处理请求。
如果不想用Docker Swarm自带的routing mesh负载均衡器，可以在服务创建或更新时使用--endpoint-mode = dnsrr，dnsrr为dns round robin简写，另一种模式即为vip，dnsrr允许应用向Docker通过服务名得到服务IP:Port列表，然后应用负责从其中选择一个地址进行服务访问。
综上，Swarm通过虚拟网桥和NATP等技术，搭建了一个跨主机的虚拟网络，通过Swarm Manager让这个跨主机网络用起来像单主机一样方便，并且集成了服务发现(服务名->服务地址)，负载均衡(routing mesh)，这些都是Swarm能够透明协调转移任务的根本保障，应用不再关心服务有几个任务，部署在何处，只需要知道服务在这个集群中，端口是多少，然后这个服务就可以动态的扩展，收缩和容灾。当然，Swarm中的服务是理想状态的微服务，亦即是无状态的。

docker-compose不支持swarm model,前面介绍的docker swarm只能以服务为方式构建，而docker-compose虽然能以应用为单位构建，但本身是单机版的，Docker本身并没有基于docker-compose进行改造，而是另起炉灶，创建了docker stack命令，同时又复用了docker-compose.yml配置方案(同时也支持另一种bundle file配置方案)，因此就造成了docker-compose能使用compose配置的version 1, version 2,和部分version 3(不支持swarm model和deploy选项)，而docker stack仅支持version 3的compose配置。
```sh
docker swarm init --advertise-addr 192.168.56.104

docker swarm join --token SWMTKN-1-5bry2ka13rbnilos3rh3iczf0c9396e7h71h7ytd12lr5c6ay0-dlhezb7ttc2vnm77w6pmcuuj8 192.168.56.101:2377

docker swarm join-token manager
docker swarm join-token worker

docker swarm leave

通过 docker node ls 可以查看当前swarm集群中的所有节点(只能在manager节点上运行)

# swarm的service和node管理命令的规范和container管理类似:

docker node|service ls: 查看集群中所有的节点(服务)
docker node|service ps: 查看指定节点(服务)的容器信息
docker node|service inspect: 查看指定节点(服务)的内部配置和状态信息
docker service logs 来查看某个服务的日志。
docker node|service update: 更新节点(服务)配置信息
docker node update --label-add func=web hostname
docker node update --label-add node_type=log_server h187
docker node update --label-rm role node1

docker service create \
  --name nginx_2 \
  --constraint 'node.labels.role == web' \
  nginx

constraints 为数组，填写多个约束时，它们之间的关系是 AND。

node attribute	matches	example
node.id	Node ID	node.id==2ivku8v2gvtg4
node.hostname	Node hostname	node.hostname!=node-2
node.role	Node role	node.role==manager
node.labels	user defined node labels	node.labels.security==high
engine.labels	Docker Engine's labels	engine.labels.operatingsystem==ubuntu 14.04

docker node|service rm: 从集群中移除节点(服务)
docker service rollback nginx 强制将任务回滚到上一个版本
docker service scale redis=3

# https://docs.docker.com/compose/compose-file/
Usage:  docker stack [OPTIONS] COMMAND

Manage Docker stacks

Options:
      --orchestrator string   Orchestrator to use (swarm|kubernetes|all)

Commands:
  deploy      Deploy a new stack or update an existing stack
  ls          List stacks
  ps          List the tasks in the stack
  rm          Remove one or more stacks
  services    List the services in the stack


docker stack deploy -c docker-compose-cti-scs.yml.bak.2020-10-30 cti-scs

--bundle-file

【实验阶段】分布式应用程序包文件的路径


-c
--compose-file

Stack File 路径



--prune

删除不再被引用的服务



--resolve-image
always
查询 Registry 以解决​​镜像摘要和支持的平台(“always”、”changed”、”never”)



--with-registry-auth

向 Swarm 代理发送 Registry 认证详细信息


  docker stack deploy -c stack anoyi_mongo
  docker stack ls
  docker stack services [OPTIONS] STACK
  docker stack ps [OPTIONS] STACK
  docker stack rm STACK [STACK...]

```


```yml
version: '3'
services:       
  parent-job-admin:
    image: registry.pmz.com:5000/pmz-job-admin:2.0.1
    ports:
    - 8090:8080
    volumes:
    - logs:/data/applogs
    networks:
    - db_net
    environment:
    - PARAMS=--spring.datasource.url=jdbc:mysql://mysql:3306/xxl-job?Unicode=true&characterEncoding=UTF-8 --spring.datasource.username=root --spring.datasource.password=pmz123098  --server.context-path=/parent-job-admin
    deploy:
      replicas: 1
      restart_policy:
        condition: on-failure
        delay: 10s
        max_attempts: 3

volumes:
  tmp:
  logs:

networks:
  db_net:
    external: true
```

### [cgroups](https://tech.meituan.com/2015/03/31/cgroups.html)

Docker资源限制主要靠Linux cgroups技术实现，简单说，cgroups是一个个的进程组(实际上是进程树)，这些进程树通过挂接 subsystem(事实上是挂接到 cgroup 上层的hierarchy)来实现对各种资源的限制和追踪，subsystem是内核附加在程序上的一系列钩子（hooks），通过程序运行时对资源的调度触发相应的钩子以达到资源追踪和限制的目的


Docker容器对 CPU 资源的访问是无限制的，可使用如下参数控制容器的 CPU 访问
```sh
docker run --rm -it --cpus 1.5 progrium/stress --cpu 3

```
* Docker没有对容器内存进行限制
* progrium/stress

* docker inspect用于查看容器的静态配置
* 可实时地显示容器的资源使用(内存, CPU, 网络等):  
docker stats $(docker ps --format={{.Names}})

* docker stop/kill仅向容器主进程(Pid==1)发送信号，因此对于ENTRYPOINT/CMD的Shell格式来说，可能导致应用无法接收的信号，Docker命令文档也提到了这一点:

Note: ENTRYPOINT and CMD in the shell form run as a subcommand of /bin/sh -c, which does not pass signals. This means that the executable is not the container’s PID 1 and does not receive Unix signals.



## potainer
```sh
docker volume create portainer_data
docker run -d -p 9001:9000 --name portainer --privileged --restart always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer

ip:port
12345678

通过命令修改docker下stack文件步骤：
1，进入安装portainer的目录， /home/portainer （安装portainer指定的目录）
2，找到compose文件夹，该文件夹下有以数字命名的文件夹，各文件夹下是每个stack的yml文件；
3，找到要修改的stack 文件，并进行修改
4，文件修改完成，执行命令部署stack：docker stack deploy -c docker-compose.yml db

```

## label

docker run \
   -d \
   --label com.example.group="webservers" \
   --label com.example.environment="production" \
   busybox \
   top

   LABEL [<namespace>.]<key>=<value> ...

## docker log driver
docker run -d \
–log-driver=fluentd \
–log-opt fluentd-address=127.0.0.1:24224 \
–log-opt tag=”docker.{{.Name}}” \
nginx

dockerd支持的日志级别debug, info, warn, error, fatal，默认的日志级别为info。必要的情况下，还需要设置日志级别，这也可以通过配置文件，或者通过启动参数-l或–log-level。 
方法一：配置文件/etc/docker/daemon.json

{  
  "log-level": "debug"  
} 

# 生产配置swarm集群

## 各节点安装docker daemon
curl http://192.168.200.185:10010/docker/docker_in.sh |sh

## docker 开启远程控制API、配置镜像加速器，私有镜像仓库
```sh
#开启远程控制API（centos7开启方式）   
vim /lib/systemd/system/docker.service   
找到 ExecStart行 修改为   
ExecStart=/usr/bin/dockerd -H tcp://0.0.0.0:2375 -H unix:///var/run/docker.sock

# 国内镜像加速器，私有镜像仓库，或者修改docker存储目录
sudo vim /etc/docker/daemon.json 文件
{
"insecure-registries" : ["registry.pmz.com:5000","192.168.200.78","192.168.205.234:5000"],
"registry-mirrors": ["https://qdtqd0ze.mirror.aliyuncs.com"],
"graph": "/home/docker_pmz"
}
# 重载所有修改过的配置文件

sudo systemctl daemon-reload  
sudo systemctl restart docker  
docker info
```

## 配置swarm集群

管理节点上执行docker swarm init --advertise-addr 192.168.205.235,并依提示，在worker节点join到swarm集群中

Swarm initialized: current node (p940lhvq6pqki0no9hbxzburl) is now a manager.

To add a worker to this swarm, run the following command:

    docker swarm join --token SWMTKN-1-426z082eyszkx5sdbg9em3nps08w5uv3yp317wkav2hdxw3uha-4osm16h2y0ehpwhl4ay16wa4n 192.168.205.235:2377

To add a manager to this swarm, run 'docker swarm join-token manager' and follow the instructions.

## 在管理节点启动并配置portainer，连接swarm集群各节点，启动服务
```sh

docker volume create portainer_data

docker run -d -p 9000:9000 --name portainer --privileged --restart always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer

docker run -d -p 8000:8000 -p 9000:9000 --name=portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer
# 访问 ip:port
配置用户名admin 密码12345678
# 远程连接各node
名字为hostname ，地址 ip:2375

# 添加stack脚本 并部署

xxl-job
http://192.168.205.235:8090/eversms-job-admin/

## 私有仓库
curl 192.168.205.234:5000/v2/_catalog

curl 192.168.205.234:5000/v2/eversms/tags/list

mvn clean packge -Pdev -Ddockerfile.skip
mvn dockerfile:push
```


## swarm node 管理
* [](https://www.jianshu.com/p/48dd5fff7150)
* [](http://zhoujinl.github.io/2018/10/19/docker-swarm-manager-ha/)

## stack
```yml
# mysql
# docker run -it --rm mysql:5.7.30 --verbose --help
docker network create -d overlay db_net
version: '3.6'
services:

  mysql:
    image: mysql:5.7.30
    environment:
      # 设置时区为Asia/Shanghai
      - TZ=Asia/Shanghai
      - MYSQL_ROOT_PASSWORD=pmz123098
    #commond: ['--character-set-server=utf8mb4','--collation-server=utf8mb4_unicode_ci']  
    volumes:
      - mysql_data:/var/lib/mysql
      - mysql_logs:/var/log/mysql
    deploy:
      replicas: 1
      placement:
        constraints: [node.role == manager]
      restart_policy:
        condition: on-failure
        delay: 10s
        max_attempts: 3
      resources:
        limits:
          cpus: "0.2"
          memory: 512M
      update_config:
        parallelism: 1 # 每次更新1个副本
        delay: 5s # 每次更新间隔 
        monitor: 10s # 单次更新多长时间后没有结束则判定更新失败
        max_failure_ratio: 0.1 # 更新时能容忍的最大失败率
        order: start-first # 更新顺序为新任务启动优先
    ports:
      - 3307:3306
    networks:
      - db_net
  
  redis:
    image: 5.0.9-buster
    environment:
      - TZ=Asia/Shanghai
    volumes:
      # redis持久化的数据文件所在目录
      - redis:/data
    command: 
      # 通过配置文件启动
      redis-server --appendonly yes --requirepass pmz123!@#
    deploy:
      restart_policy:
        condition: on-failure
        delay: 10s
        max_attempts: 3
      placement:
        constraints: [node.role == manager]
    ports:
      - 6389:6379
    networks:
      - db_net

networks:
  db_net:
    external: true

volumes:
  mysql_data:
  mysql_logs:
  redis:

# antifraud
version: '3.7'

services:
  file-download-server:
    image: registry.pmz.com:5000/file-download-server:1.0
    ports:
      - 8000:8000
    #environment:

    volumes:
      - antifraud_share_data:/antifraud_share
    networks:
      - db_net
    #logging:
     # driver: fluentd
      #options: 
       # fluentd-address: localhost:24224
    deploy:
      replicas: 1
      restart_policy:
        condition: on-failure
        delay: 10s
        max_attempts: 3
      placement:
        constraints: [node.role == manager]
        
        
  antifraud:
    image: registry.pmz.com:5000/antifraud:1.0.0-SNAPSHOT
    ports:
      - 18082:18082
    environment:
      download_server: 192.168.205.235
      download_port: 8000
      antifraud_share_upload: /antifraud_share/upload/images
    volumes:
      - antifraud_share_data:/antifraud_share
    networks:
      - db_net
    #logging:
     # driver: fluentd
      #options: 
       # fluentd-address: localhost:24224
    deploy:
      replicas: 1
      restart_policy:
        condition: on-failure
        delay: 10s
        max_attempts: 3
      placement:
        constraints: [node.role == manager]   
     
volumes:
  antifraud_share_data:
  
networks:
  db_net:


# sms
version: '3'

services:
  eversms:
    image: registry.pmz.com:5000/eversms:2.2
    ports:
      - 18081:18081
    environment:
     - SPRING_PROFILES_ACTIVE=docker
     - DATABASE_HOST=192.168.205.233
     - DATABASE_PORT=3307
     - DATABASE_NAME=eversms3
     - DATABASE_USER=root
     - DATABASE_PASSWORD=pmz123098
     - JOB_HOST=eversms-job-admin
     - JOB_PORT=8080
    volumes:
      - logs:/app/logs
    networks:
      - db_net
    logging:
      driver: fluentd
      options: 
        fluentd-address: localhost:24224
    deploy:
      replicas: 1
      restart_policy:
        condition: on-failure
        delay: 10s
        max_attempts: 3

volumes:
  logs:
  
networks:
  db_net:


# efk
version: '3.7'

services:
  es01:
    image: elasticsearch:7.1.1
    ports:
      - "9222:9200"
      - "9333:9300"
    environment:
      - node.name=es01
      - discovery.seed_hosts=es01,es02
      - cluster.initial_master_nodes=es01,es02
      - cluster.name=docker-cluster
      - bootstrap.memory_lock=true
      - xpack.security.enabled=true
      - "ES_JAVA_OPTS=-Xms512m -Xmx512m"
    ulimits:
      memlock:
        soft: -1
        hard: -1  
    volumes:
      - es7_data2:/usr/share/elasticsearch/data
    networks:
      - efk_net
    deploy:
      replicas: 1
      placement:
        constraints: ["node.role == manager"]
        
  es02:
    image: elasticsearch:7.1.1
    ports:
      - "9225:9200"
      - "9335:9300"
    environment:
      - node.name=es02
      - discovery.seed_hosts=es01,es02
      - cluster.initial_master_nodes=es01,es02
      - cluster.name=docker-cluster
      - bootstrap.memory_lock=true
      - xpack.security.enabled=true
      - "ES_JAVA_OPTS=-Xms512m -Xmx512m"
    ulimits:
      memlock:
        soft: -1
        hard: -1  
    volumes:
      - es7_data3:/usr/share/elasticsearch/data
    networks:
      - efk_net
    deploy:
      replicas: 1
      placement:
        constraints: ["node.role == manager"] 
   
  fluent-bit:
    image: fluent/fluent-bit:1.2.2-debug
    volumes:
      - /home/docker_pmz/docker_to_es.conf:/fluent-bit/etc/fluent-bit.conf
    networks:
      - efk_net
    ports:
      - "24224:24224"
    depends_on:
      - es7
    deploy:
      mode: global
      #placement:
        #constraints:                      
          #- node.labels.service_type==log_daemon
      
  kibana:
    image: kibana:7.1.1
    
    #volumes:
    #- kibana_data:/usr/share/kibana/config/kibana.yml
    ports:
      - 5601:5601
    environment:
      ELASTICSEARCH_HOSTS: 'http://es01:9200'
      ELASTICSEARCH_USERNAME: elastic 
      ELASTICSEARCH_PASSWORD: elastic
    networks:
      - efk_net
    depends_on:
      - es7
    deploy:
      replicas: 1
      placement:
        constraints: ['node.role == manager'] 
  cerebro:
    image: lmenezes/cerebro:latest
    
    ports:
      - "9002:9000"
    networks:
      - efk_net      
        
volumes:
  es7_data2:
  es7_data3:
  
networks:
  efk_net:


# everDevOps
version: '3'

services:
  registry2:
    image: registry
    ports:
      - 5000:5000      
    volumes:
      - registry_image:/var/lib/registry
    deploy:
      replicas: 1
      placement:
        constraints: ["node.role == manager"]
      restart_policy:
        condition: on-failure
        delay: 5s
        max_attempts: 3
        window: 120s
        
volumes:
  registry_image:

# zk 
version: '3.1'

services:
  zoo1:
    image: zookeeper
    restart: always
    hostname: zoo1
    ports:
      - 2181:2181
    volumes:
      - zk_data_1:/data
      - zk_dataLog_1:/datalog
    environment:
      ZOO_MY_ID: 1
      ZOO_SERVERS: server.1=0.0.0.0:2888:3888;2181 server.2=zoo2:2888:3888;2181 server.3=zoo3:2888:3888;2181

  zoo2:
    image: zookeeper
    restart: always
    hostname: zoo2
    ports:
      - 2182:2181
    volumes:
      - zk_data_2:/data
      - zk_dataLog_2:/datalog
    environment:
      ZOO_MY_ID: 2
      ZOO_SERVERS: server.1=zoo1:2888:3888;2181 server.2=0.0.0.0:2888:3888;2181 server.3=zoo3:2888:3888;2181

  zoo3:
    image: zookeeper
    restart: always
    hostname: zoo3
    ports:
      - 2183:2181
    volumes:
      - zk_data_3:/data
      - zk_dataLog_3:/datalog
    environment:
      ZOO_MY_ID: 3
      ZOO_SERVERS: server.1=zoo1:2888:3888;2181 server.2=zoo2:2888:3888;2181 server.3=0.0.0.0:2888:3888;2181
      
 
volumes:
  zk_data_1:
  zk_data_2:
  zk_data_3:
  zk_dataLog_1:
  zk_dataLog_2:
  zk_dataLog_3:

# job-admin
version: '3'
services:       
  eversms-job-admin:
    image: xuxueli/xxl-job-admin:2.0.2
    ports:
    - 8090:8080
    volumes:
    - logs:/data/applogs
    networks:
    - db_net
    environment:
    - PARAMS=--spring.datasource.url=jdbc:mysql://192.168.205.233:3307/xxl-job-eversms?Unicode=true&characterEncoding=UTF-8 --spring.datasource.username=root --spring.datasource.password=pmz123098  --server.context-path=/eversms-job-admin
    deploy:
      replicas: 1
      restart_policy:
        condition: on-failure
        delay: 10s
        max_attempts: 3
      placement:
        constraints: [node.role == worker]

volumes:
  logs:

networks:
  db_net:




version: '3.2'
services:
  zookeeper:
    image: freakchicken/kafka-ui-lite
    ports:
      - "8889:8889"
    deploy:
      replicas: 1
      placement:
        constraints: ["node.hostname == manager"]  
    volumes:
      - zk_data_1:/data
      - zk_dataLog_1:/datalog
    networks:
      - kafka-net

volumes:
  kafka_logs_1:
  zk_data_1:
  zk_dataLog_1:

networks:
    kafka-net:      
```

## docker system df -v

docker system prune

多看了一下资料，发现可以使用 docker system prune来自动清理空间，参考下面：

该指令默认会清除所有如下资源：
已停止的容器（container）
未被任何容器所使用的卷（volume）
未被任何容器所关联的网络（network）
所有悬空镜像（image）。
该指令默认只会清除悬空镜像，未被使用的镜像不会被删除。
添加 -a 或 --all 参数后，可以一并清除所有未使用的镜像和悬空镜像。
可以添加 -f 或 --force 参数用以忽略相关告警确认信息。