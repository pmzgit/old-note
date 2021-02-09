# [fastdfs 安装](https://github.com/happyfish100/fastdfs/wiki)
* [概念](http://www.ityouknow.com/fastdfs/2018/01/06/distributed-file-system-fastdfs.html)
* 注意要clone fastdfs 仓库最新源代码，目前5.12
```sh
# 安装libfatscommon
git clone https://github.com/happyfish100/libfastcommon.git --depth 1
./make.sh && ./make.sh install #编译安装

# 安装FastDFS
git clone https://github.com/happyfish100/fastdfs.git --depth 1
cd fastdfs/
./make.sh && ./make.sh install #编译安装
#配置文件准备
cp /etc/fdfs/tracker.conf.sample /etc/fdfs/tracker.conf
cp /etc/fdfs/storage.conf.sample /etc/fdfs/storage.conf
cp /etc/fdfs/client.conf.sample /etc/fdfs/client.conf #客户端文件，测试用
cp /usr/local/src/fastdfs/conf/http.conf /etc/fdfs/ #供nginx访问使用
cp /usr/local/src/fastdfs/conf/mime.types /etc/fdfs/ #供nginx访问使用

# 安装fastdfs-nginx-module
git clone https://github.com/happyfish100/fastdfs-nginx-module.git --depth 1
cp /usr/local/src/fastdfs-nginx-module/src/mod_fastdfs.conf /etc/fdfs

# 先配置软链接
ln -sv /usr/include/fastcommon /usr/local/include/fastcommon 
ln -sv /usr/include/fastdfs /usr/local/include/fastdfs 
ln -sv /usr/lib64/libfastcommon.so /usr/local/lib/libfastcommon.so

# 重新编译安装nginx,先看看已有nginx 编译参数 /usr/local/nginx/sbin/nginx -V

./configure --prefix=/usr/local/nginx/ --with-http_ssl_module --add-module=../../pac/fastdfs/fastdfs-nginx-module/src

make && make install #编译安装
```

# 单机部署
## 修改配置文件
```sh
#假设服务器ip为 192.168.52.1
vim /etc/fdfs/tracker.conf
#需要修改的内容如下
port=22122  # tracker服务器端口（默认22122,一般不修改）
base_path=/home/dfs/tracker  # 存储日志和数据的根目录

vim /etc/fdfs/storage.conf
#需要修改的内容如下
port=23000  # storage服务端口（默认23000,一般不修改）
base_path=/home/dfs/storage  # 数据和日志文件存储根目录
store_path0=/home/dfs/storage  # 第一个存储目录
tracker_server=192.168.52.1:22122  # tracker服务器IP和端口
http.server_port=8888  # http访问文件的端口(默认8888,看情况修改,和nginx中保持一致)

vim /etc/fdfs/client.conf
#需要修改的内容如下
base_path=/home/dfs
tracker_server=192.168.52.1:22122    #tracker服务器IP和端口


vim /etc/fdfs/mod_fastdfs.conf
#需要修改的内容如下
tracker_server=192.168.52.1:22122  #tracker服务器IP和端口
url_have_group_name=true
store_path0=/home/dfs/storage
#配置nginx.config
vim /usr/local/nginx/conf/nginx.conf
#添加如下配置
server {
    listen       8888;    ## 该端口为storage.conf中的http.server_port相同
    server_name  localhost;
    location ~/group[0-9]/ {
        ngx_fastdfs_module;
    }
    error_page   500 502 503 504  /50x.html;
    location = /50x.html {
    root   html;
    }
}

```

## 启动
```sh
#不关闭防火墙的话无法使用
systemctl stop firewalld.service #关闭
systemctl restart firewalld.service #重启

# 或者命令行在 /usr/bin/fdfs_xxx 
/etc/init.d/fdfs_trackerd start #启动tracker服务
/etc/init.d/fdfs_trackerd restart #重启动tracker服务
/etc/init.d/fdfs_trackerd stop #停止tracker服务
chkconfig fdfs_trackerd on #自启动tracker服务

/etc/init.d/fdfs_storaged start #启动storage服务
/etc/init.d/fdfs_storaged restart #重动storage服务
/etc/init.d/fdfs_storaged stop #停止动storage服务
chkconfig fdfs_storaged on #自启动storage服务

/usr/bin/fdfs_monitor /etc/fdfs/storage.conf
# 如果出现ip_addr = Active, 则表明storage服务器已经登记到tracker服务器
# 会显示会有几台服务器 有3台就会 显示 Storage 1-Storage 3的详细信息
```
## 测试
```sh
#保存后测试,返回ID表示成功 如：group1/M00/00/00/xx.tar.gz
fdfs_upload_file /etc/fdfs/client.conf /usr/local/src/nginx-1.15.4.tar.gz

#测试下载，用外部浏览器访问刚才已传过的nginx安装包,引用返回的ID
http://192.168.52.1:8888/group1/M00/00/00/wKgAQ1pysxmAaqhAAA76tz-dVgg.tar.gz
#弹出下载单机部署全部跑通
```

# 分布式部署

* fastdfs-nginx-module模块只需要安装到storage上

