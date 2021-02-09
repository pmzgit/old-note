#!/usr/bin/env bash

set -xe

cat>>/etc/profile<<EOF
export HADOOP_HOME=/home/pmz/app/hadoop-2.6.5
export HADOOP_CONF_DIR=\$HADOOP_HOME/etc/hadoop
export PATH=\$HADOOP_HOME/bin:\$HADOOP_HOME/sbin:\$PATH
EOF

source /etc/profile