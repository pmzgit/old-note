#!/usr/bin/env bash

set -xe

cat>>/etc/hosts<<EOF
10.10.2.187 h187
10.10.2.188 h188
10.10.2.189 h189
EOF
ping -c1 h187
ping -c1 h188
ping -c1 h189

# centos6 /etc/sysconfig/selinux
sed -i 's@SELINUX=enforcing@SELINUX=disabled@g' /etc/selinux/config 
setenforce 0
systemctl disable firewalld  # 开机不自启防火墙
systemctl stop firewalld     # 关闭防火墙

#service iptables stop
#chkconfig iptables off

yum install -y ntp
\cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
echo "* * */4 * *  /usr/sbin/ntpdate cn.pool.ntp.org > /dev/null 2>&1" >> /var/spool/cron/root

cat>>/etc/security/limits.conf<<EOF
@root hard nofile 1048576
@pmz hard nofile 1048576
* soft nproc 1048576
* hard nproc 1048576
* soft nofile 1048576
* hard nofile 1048576
EOF
echo "ulimit -SHn 65535">>/etc/rc.local
ulimit -SHn 65535
/etc/sysctl.conf
net.core.somaxconn=32768
cat /proc/sys/net/core/somaxconn

关闭swap分区
任何进程只要涉及到换页向磁盘写文件都会降低hadoop的性能,默认是60.它设置成0可以尽可能地减少内存和磁盘的延迟。

加入vm.swappiness=1
vm.overcommit_memory=1
cat /proc/sys/vm/swappiness

elasticSearch使用的是mmapfs/niofs文件系统保存索引，默认值设置为65530，太小，会造成内存异常。
vm.max_map_count=262144
# check 
getenforce
ulimit -SHn
crontab -l|grep ntpdate