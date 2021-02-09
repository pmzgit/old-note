https://www.cnblogs.com/qingyunzong/p/9435048.html


ln -s /jdk安装位置/* usr/java/default/

create database hive DEFAULT CHARSET utf8 COLLATE utf8_general_ci;
create database scm DEFAULT CHARSET utf8 COLLATE utf8_general_ci;

use mysql;
CREATE USER 'scm'@'%' IDENTIFIED BY 'scm';
GRANT ALL PRIVILEGES ON *.* TO scm@"%" IDENTIFIED BY "scm";
flush privileges;

echo never > /sys/kernel/mm/redhat_transparent_hugepage/enabled
echo never > /sys/kernel/mm/redhat_transparent_hugepage/defrag

vi /etc/rc.local
echo 0 >  /proc/sys/vm/swappiness
echo never > /sys/kernel/mm/redhat_transparent_hugepage/enabled
echo never > /sys/kernel/mm/redhat_transparent_hugepage/defrag
swapoff -a

scp /etc/rc.local bigdata02:$PWD
scp /etc/rc.local bigdata03:$PWD

ntp

yum install -y perl

http://archive.cloudera.com/cm5/
http://archive.cloudera.com/cdh5/parcels/

useradd --system --home=/opt/cloudera-manager/cm-5.14.1/run/cloudera-scm-server --no-create-home --shell=/bin/false --comment "Cloudera SCM User" cloudera-scm

passwd cloudera-scm


https://dev.mysql.com/downloads/file/?id=476197

