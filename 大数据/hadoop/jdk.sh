#!/usr/bin/env bash

set -xe

tar xzf jdk-8u201-linux-x64.tar.gz -C /usr/local/

cat>>/etc/profile<<EOF
export JAVA_HOME=/usr/local/jdk1.8.0_201
export PATH=\$JAVA_HOME/bin:\$PATH
EOF

. /etc/profile
java -version