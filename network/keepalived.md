## [参考](https://renwole.com/archives/1107)
## install

```sh
yum install gcc openssl-devel libnl-devel libnfnetlink-devel ipvsadm -y
wget http://www.keepalived.org/software/keepalived-2.0.10.tar.gz
cd keepalived-2.0.10
./configure --prefix=/usr/local/keepalived
make && make install
ln -s /usr/local/keepalived/sbin/keepalived /usr/sbin
mkdir /etc/keepalived/
ln -s /usr/local/keepalived/etc/keepalived/keepalived.conf /etc/keepalived/
this build will not support IPVS with IPv6. Please install libnl/libnl-3 dev libraries to support IPv6 with IPVS.

```
sestatus -v  
getenforce  
临时关闭  
setenforce 0  
#setenforce 1  
修改配置文件需要重启机器 /etc/selinux/config

将SELINUX=enforcing改为SELINUX=disabled

## [配置](http://www.keepalived.org/manpage.html)
* 先决条件  

时间同步。  
设置SELinux和防火墙。  
互相之间/etc/hosts文件添加对方主机名（可选）。  
确认接口支持多播（组播）新网卡默认支持  

* 启用ip转发

echo "net.ipv4.ip_forward = 1" >> /etc/sysctl.conf
sysctl -p
* 添加规则  

firewall-cmd --direct --permanent --add-rule ipv4 filter INPUT 0 \
  --in-interface enp0s8 --destination 224.0.0.18 --protocol vrrp -j ACCEPT  
firewall-cmd --direct --permanent --add-rule ipv4 filter OUTPUT 0 \
  --out-interface enp0s8 --destination 224.0.0.18 --protocol vrrp -j ACCEPT  
firewall-cmd --reload

或者

firewall-cmd --add-rich-rule='rule protocol value="vrrp" accept' --permanent
firewall-cmd --reload
* centos 6   

iptables -I INPUT -i eth0 -d 224.0.0.0/8 -p vrrp -j ACCEPT    
iptables -I OUTPUT -o eth0 -d 224.0.0.0/8 -p vrrp -j ACCEPT  
service iptables save

* 不同

state BACKUP     # 此值可设置或不设置，只要保证下面的priority不一致即可
interface eth0   # 根据实际情况选择网卡
priority 40 

* 重载配置

systemctl reload keepalived

* 虚拟mac

arp -n  
网关 ip 00:00:5e:00:01.xx  
虚拟ip master mac


## 启动

systemctl start keepalive


## 日志文件
* centos 

/var/log/messages


