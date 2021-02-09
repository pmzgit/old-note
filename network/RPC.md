http://thrift.apache.org/

http://thrift.apache.org/download

sudo yum -y groupinstall "Development Tools"


cd /etc/yum.repos.d/
wget -c http://download.opensuse.org/repositories/home:/jblunck:/messaging/CentOS_CentOS-6/home:jblunck:messaging.repo
yum makecache
yum install thrift