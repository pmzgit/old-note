#!/bin/bash
server=192.168.200.185:10010
cd /home
wget $server/docker/dockersoft.tar.gz
tar -xf dockersoft.tar.gz
rm -rf dockersoft.tar.gz
cd dockersoft
bash docker_install.sh
systemctl enabled docker 
systemctl restart docker
docker version
exit
