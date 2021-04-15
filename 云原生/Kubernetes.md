# cn
https://jimmysong.io/  

# docker 思想与原理-云计算新方案
将 os（不包括kernel），runtime，application，打包成镜像（打包标准），实现平台(本地和云端)无关性。

x86,arm,os,混合云与多云

PaaS 的最终用户和受益者，一定是为这个 PaaS 编写应用的开发者们，以及如何让开发者把应用部署在我的项目上（swarm）-找准目标用户，深挖用户痛点，付费产品

无开源不生态，无生态不商业

最核心的原理实际上就是为待创建的用户进程：

启用 Linux Namespace 配置；  
设置指定的 Cgroups 参数；  
切换进程的根目录（pivot_root或chroot）(镜像：rootfs 只是一个操作系统所包含的文件、配置和目录，并不包括操作系统内核,这种深入到操作系统级别的运行环境**一致性**，打通了应用在本地开发和远端执行环境之间难以逾越的鸿沟。)。  
实际上，同一台机器上的所有容器，都共享宿主机操作系统的内核。  
Docker init 层的作用：为了避免你执行 docker commit 时，把 Docker 自己对 /etc/hosts 等文件做的修改，也一起提交掉。  

容器技术的核心功能，就是通过约束和修改进程的动态表现，从而为其创造出一个“边界”。容器化对资源隔离的不足，最终它是通过共享宿主机上的操作系统内核来运行的。namespace是对进程可见性的隔离，cgroup是对系统资源的隔离。一个正在运行的 Docker 容器，其实就是一个启用了多个 Linux Namespace 的单个应用进程，而这个进程能够使用的资源量，则受 Cgroups 配置的限制。容器和应用能够同生命周期，这个概念对后续的容器编排非常重要

而 Namespace 的使用方式也非常有意思：它其实只是 Linux 创建新进程的一个可选参数。Docker 容器这个听起来玄而又玄的概念，实际上是在创建容器进程时，指定了这个进程所需要启用的一组 Namespace 参数。这样，容器就只能“看”到当前 Namespace 所限定的资源、文件、设备、状态，或者配置。而对于宿主机以及其他不相关的程序，它就完全看不到了。所以说，容器，其实是一种特殊的进程而已。

uts:主机名和域名隔离
ipc:信号量，消息队列和共享内存隔离
mnt:文件系统挂载点隔离
net:网络隔离，每个namespace都有自己独立的ip,路由和端口
pid:隔离进程id

Linux Cgroups 的全称是 Linux Control Group。它最主要的作用，就是限制一个进程组能够使用的资源上限，包括 CPU、内存、磁盘、网络带宽，还能够对进程进行优先级设置、审计，以及将进程挂起和恢复等操作。

mount -t cgroup 可以看到，在 /sys/fs/cgroup 下面有很多诸如 cpuset、cpu、 memory 这样的子目录，也叫子系统。这些都是我这台机器当前可以被 Cgroups 进行限制的资源种类。而在子系统对应的资源种类下，你就可以看到该类资源具体可以被限制的方法。容器中 top 指令以及 /proc 文件系统中的信息看到的CPU和内存等是宿主机的信息，lxcfs 可解决此问题



 /proc/[进程号]/ns：一个进程，可以选择加入到某个进程已有的 Namespace 当中，从而达到“进入”这个进程所在容器的目的，这正是 docker exec 的实现原理：使用系统调用setns，让新启动的进程与容器共享多种namespace


 -net=host，让容器直接使用宿主机的网络


### volume

/test是容器中的目录，在宿主机的体现就是/var/lib/docker/aufs/mnt/[可读写ID]/test目录。

1. 为了保证隔离性，所以挂载操作必须在mount namespace之后执行   
2. 为了保证可以看到系统的文件，所以挂载操作需要在chroot之前。  
所以操作的大致顺序是 mount namespace mount挂载 chroot

容器内被挂载的目录下的东西只是被隐藏 而不是被删除了！容器 Volume 里的信息，并不会被 docker commit 提交掉；但这个挂载点目录 /test 本身，则会出现在新的镜像当中。

![Docker容器全景图](../assets/Docker容器全景图.jpg)

一组联合挂载在 /var/lib/docker/aufs/mnt 上的 rootfs，这一部分我们称为“容器镜像”（Container Image），是容器的静态视图；  
一个由 Namespace+Cgroups 构成的隔离环境，这一部分我们称为“容器运行时”（Container Runtime），是容器的动态视图。

https://github.com/linuxkit
https://github.com/goharbor/harbor  
https://linuxcontainers.org/  
https://zh.wikipedia.org/wiki/%E5%9F%BA%E4%BA%8E%E5%86%85%E6%A0%B8%E7%9A%84%E8%99%9A%E6%8B%9F%E6%9C%BA  
https://zh.wikipedia.org/wiki/QEMU

https://zh.wikipedia.org/wiki/Alpine_Linux  
https://zh.wikipedia.org/wiki/BusyBox


https://zh.wikipedia.org/wiki/%E5%8F%AF%E7%A7%BB%E6%A4%8D%E6%93%8D%E4%BD%9C%E7%B3%BB%E7%BB%9F%E6%8E%A5%E5%8F%A3  
https://zh.wikipedia.org/wiki/%E5%8A%A8%E6%80%81%E5%86%85%E6%A0%B8%E6%A8%A1%E5%9D%97%E6%94%AF%E6%8C%81
# k8s 

https://fluentbit.io/
https://www.rook.io/   
https://prometheus.io/    
https://www.redhat.com/zh/technologies/cloud-computing/openshift  


目前热度极高的微服务治理项目 Istio；  
被广泛采用的有状态应用部署框架 Operator；   
还有像 Rook 这样的开源创业项目，它通过 Kubernetes 的可扩展接口，把 Ceph 这样的重量级产品封装成了简单易用的容器存储插件。

容器编排、集群管理，调度和作业管理