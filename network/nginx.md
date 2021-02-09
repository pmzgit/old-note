# [教程](https://linux.cn/article-4279-1.html)
### [官方文档英文](http://nginx.org/en/docs)
### [文档中文](https://cloud.tencent.com/developer/doc/1158)
### [教程](https://www.hi-linux.com/tags/#Nginx)
### 1. 优点
* 可以实现高并发
* 部署简单
* 内存消耗少
* 跨平台

### 2. 缺点
* rewrite功能不够强大
* 模块少

# 3.1yum 安装
* [centos 6.5 nginx安装与配置]
(https://gist.github.com/ifels/c8cfdfe249e27ffa9ba1)


### 3.2编译安装

```sh
前提：Linux软件编译安装必须的依赖安装包  
 
* yum -y  install  gcc   gcc-c++  make pcre  pcre-devel openssl  openssl-devel   zlib patch
* 

// 下载到 /home/pmz/pac 目录下
wget -P /home/pmz/pac http://nginx.org/download/nginx-1.15.5.tar.gz
// 解压 
tar xzvf nginx-1.12.2.tar.gz -C /home/pmz/pac
// 进入到解压后的根目录
cd ./nginx-1.12.2
// 检测环境
./configure --prefix=/usr/local/nginx --with-http_stub_status_module --with-http_ssl_module --with-pcre --with-stream --add-module=./nginx_upstream_check_module-master

添加模块重新编译安装即可 ：
[负载均衡下的后端服务健康检查](https://github.com/yaoweibin/nginx_upstream_check_module)
patch -p1 < ./nginx_upstream_check_module-master/check_1.14.0+.patch
nginx -V            显示 nginx 的版本，编译器版本和配置参数。
--add-module=./nginx_upstream_check_module-master
```sh
Configuration summary
  + using system PCRE library
  + using system OpenSSL library
  + using system zlib library

  nginx path prefix: "/usr/local/nginx"
  nginx binary file: "/usr/local/nginx/sbin/nginx"
  nginx modules path: "/usr/local/nginx/modules"
  nginx configuration prefix: "/usr/local/nginx/conf"
  nginx configuration file: "/usr/local/nginx/conf/nginx.conf"
  nginx pid file: "/usr/local/nginx/logs/nginx.pid"
  nginx error log file: "/usr/local/nginx/logs/error.log"
  nginx http access log file: "/usr/local/nginx/logs/access.log"
  nginx http client request body temporary files: "client_body_temp"
  nginx http proxy temporary files: "proxy_temp"
  nginx http fastcgi temporary files: "fastcgi_temp"
  nginx http uwsgi temporary files: "uwsgi_temp"
  nginx http scgi temporary files: "scgi_temp"

```
//编译安装  
make   
make install

```
#### 参考
* [yum 和 源码包 安装的 区别](https://segmentfault.com/a/1190000007116797)
* [llinux 环境安装编译 nginx (源码安装包)](http://www.cnblogs.com/zoulongbin/p/6253568.html)


### 4. nginx 配置
* [nginx配置、虚拟主机、负载均衡和反向代理](https://www.zybuluo.com/phper/note/89391)
* [正确配置Linux系统ulimit值的方法](https://www.cnblogs.com/ibook360/archive/2012/05/11/2495405.html#undefined)
### 5. Nginx启动关闭
```shell
start nginx
nginx -s stop       快速关闭Nginx，可能不保存相关信息，并迅速终止web服务。
nginx -s quit       平稳关闭Nginx，保存相关信息，有安排的结束web服务。
nginx -s reload     因改变了Nginx相关配置，需要重新加载配置而重载。
nginx -s reopen     重新打开日志文件。
nginx -c filename   为 Nginx 指定一个配置文件，来代替缺省的。
nginx -t            不运行，而仅仅测试配置文件。nginx 将检查配置文件的语法的正确性，并尝试打开配置文件中所引用到的文件。
nginx -v            显示 nginx 的版本。
nginx -V            显示 nginx 的版本，编译器版本和配置参数。
```

### [匹配规则说明以及匹配的优先级](https://blog.csdn.net/qq_15766181/article/details/72829672)

# nginx 作为资源下载服务器

* 假如文件存放在：`/home/upload/images/` 目录下

* nginx.conf server部分配置如下

```yml
server {
        listen       8000;
        #listen       somename:8080;
        server_name  localhost;
        charset utf-8; # 编码

        location ~ ^/images { # url正则匹配规则： images 为前缀

            root   /home/upload; # 可以看到与location配合成最终文件存放目录， /home/upload/images/
            #index  index.html index.htm;
            autoindex on; # 打开目录浏览功能
            autoindex_exact_size on; # 显示文件大小
            autoindex_localtime on; # 显示文件时间
        }
    }

```
此外 /home/upload/images/ 的权限为 `drwxr-x--- 2 root root 36864 Nov 29 15:03`  
所以 nginx.conf user部分配置为
```yml
user  root root; # 用户，用户组 防止访问时出现 403 forbidden

root和alias的区别主要在于替换的部分，root模式中，会把root配置的路径替换匹配后的url中的host。alias则把他指定的路径，替换url中匹配的部分。指令中的斜杠对于root指令没有影响，对于alise则按照替换规则匹配即可。

```
* 启动后，访问 `http://ip:8000/images/`

# NGINX ciphers 配置
* [NGINX ciphers 配置](https://blog.csdn.net/makenothing/article/details/63768914) 
* [专业配置建议](https://cipherli.st/)
```sh
 server {
        listen       443 ssl;
        server_name  locaton.pmz.cn;

        ssl_certificate      ../ssl/pmz.cn.pem;
        ssl_certificate_key  ../ssl/pmz.cn.key;

        ssl_session_cache    shared:SSL:10m;
        ssl_session_timeout  10m;

        ssl_ciphers ECDHE-RSA-AES256-GCM-SHA512:DHE-RSA-AES256-GCM-SHA512:ECDHE-RSA-AES256-GCM-SHA384:DHE-RSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-SHA384;
        ssl_prefer_server_ciphers  on;

        location / {
            root   html;
            index  index.html index.htm;
        }
    }

加密套件解读： 
ECDHE-RSA-AES128-GCM-SHA256 为例

ECDHE：秘钥交换算法 
RSA：签名算法 
AES128：对称加密算法 
GCM-SHA256：签名算法

默认项： 
秘钥交换算法：RSA 
签名算法：RSA 
模式：CBC 
AES256-SHA256 也就是 RSA-RSA-AES256-CBC-SHA256

```
# 配置
```
client_max_body_size 20m;
```
* 获取客户端真实ip  
proxy_set_header X-Real-IP $remote_addr;  
proxy_set_header Host $host;    
proxy_set_header X-Forwarded-For  $proxy_add_x_forwarded_for;  
proxy_set_header X-Forwarded-Proto  $scheme;


proxy_next_upstream off

```sh
log_format  main  '$time_local|$request_time|$status|$body_bytes_sent|$remote_addr|$request|$http_referer|$http_user_agent|$http_x_forwarded_for|$upstream_cache_status|$upstream_response_time|$upstream_status|$upstream_addr|$http_x_forwarded_for';

upstream pmz_prod
{
    least_conn
    server 192.168.40.92:8080 max_fails=5; 
    server 192.168.40.92:8081 max_fails=5;

}
upstream pmz_gray
{
    server 192.168.40.92:8081;
}

location ~* ^/Swagger{

        set $pmz pmz_prod;
        if ($remote_addr ~ '61.48.40.26|124.204.43.26') {
            set $pmz pmz_gray;
        }
        
        proxy_pass_header Server;
        proxy_set_header Host $host;
        proxy_redirect off;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Scheme $scheme;
        proxy_pass http://$pmz;
    }
```
* “~ ”和“~* ”前缀表示正则location ，“~ ”区分大小写，“~* ”不区分大小写
* [proxy_pass绝对路径和相对路径](https://www.jianshu.com/p/b113bd14f584)
* [nginx的功能](https://www.kancloud.cn/hiyang/nginx/364780)

### [适配pc和手机](https://www.jianshu.com/p/95a020d256fe)

* http://detectmobilebrowsers.com/

```sh
server {  
    listen 80;
    set $mobile_rewrite do_not_perform;
    if ($http_user_agent ~* "(android|bb\d+|meego).+mobile|avantgo|bada\/|blackberry|blazer|compal|elaine|fennec|hiptop|iemobile|ip(hone|od)|iris|kindle|lge |maemo|midp|mmp|mobile.+firefox|netfront|opera m(ob|in)i|palm( os)?|phone|p(ixi|re)\/|plucker|pocket|psp|series(4|6)0|symbian|treo|up\.(browser|link)|vodafone|wap|windows ce|xda|xiino") {
        set $mobile_rewrite perform;
    }
    if ($http_user_agent ~* "^(1207|6310|6590|3gso|4thp|50[1-6]i|770s|802s|a wa|abac|ac(er|oo|s\-)|ai(ko|rn)|al(av|ca|co)|amoi|an(ex|ny|yw)|aptu|ar(ch|go)|as(te|us)|attw|au(di|\-m|r |s )|avan|be(ck|ll|nq)|bi(lb|rd)|bl(ac|az)|br(e|v)w|bumb|bw\-(n|u)|c55\/|capi|ccwa|cdm\-|cell|chtm|cldc|cmd\-|co(mp|nd)|craw|da(it|ll|ng)|dbte|dc\-s|devi|dica|dmob|do(c|p)o|ds(12|\-d)|el(49|ai)|em(l2|ul)|er(ic|k0)|esl8|ez([4-7]0|os|wa|ze)|fetc|fly(\-|_)|g1 u|g560|gene|gf\-5|g\-mo|go(\.w|od)|gr(ad|un)|haie|hcit|hd\-(m|p|t)|hei\-|hi(pt|ta)|hp( i|ip)|hs\-c|ht(c(\-| |_|a|g|p|s|t)|tp)|hu(aw|tc)|i\-(20|go|ma)|i230|iac( |\-|\/)|ibro|idea|ig01|ikom|im1k|inno|ipaq|iris|ja(t|v)a|jbro|jemu|jigs|kddi|keji|kgt( |\/)|klon|kpt |kwc\-|kyo(c|k)|le(no|xi)|lg( g|\/(k|l|u)|50|54|\-[a-w])|libw|lynx|m1\-w|m3ga|m50\/|ma(te|ui|xo)|mc(01|21|ca)|m\-cr|me(rc|ri)|mi(o8|oa|ts)|mmef|mo(01|02|bi|de|do|t(\-| |o|v)|zz)|mt(50|p1|v )|mwbp|mywa|n10[0-2]|n20[2-3]|n30(0|2)|n50(0|2|5)|n7(0(0|1)|10)|ne((c|m)\-|on|tf|wf|wg|wt)|nok(6|i)|nzph|o2im|op(ti|wv)|oran|owg1|p800|pan(a|d|t)|pdxg|pg(13|\-([1-8]|c))|phil|pire|pl(ay|uc)|pn\-2|po(ck|rt|se)|prox|psio|pt\-g|qa\-a|qc(07|12|21|32|60|\-[2-7]|i\-)|qtek|r380|r600|raks|rim9|ro(ve|zo)|s55\/|sa(ge|ma|mm|ms|ny|va)|sc(01|h\-|oo|p\-)|sdk\/|se(c(\-|0|1)|47|mc|nd|ri)|sgh\-|shar|sie(\-|m)|sk\-0|sl(45|id)|sm(al|ar|b3|it|t5)|so(ft|ny)|sp(01|h\-|v\-|v )|sy(01|mb)|t2(18|50)|t6(00|10|18)|ta(gt|lk)|tcl\-|tdg\-|tel(i|m)|tim\-|t\-mo|to(pl|sh)|ts(70|m\-|m3|m5)|tx\-9|up(\.b|g1|si)|utst|v400|v750|veri|vi(rg|te)|vk(40|5[0-3]|\-v)|vm40|voda|vulc|vx(52|53|60|61|70|80|81|83|85|98)|w3c(\-| )|webc|whit|wi(g |nc|nw)|wmlb|wonu|x700|yas\-|your|zeto|zte\-)") {
        set $mobile_rewrite perform;
    }
    if ($http_cookie ~ 'gotopc=true') {
        set $mobile_rewrite do_not_perform;
    }
    location / {
        proxy_pass http://192.168.20.1;  # 电脑版
        if ($mobile_rewrite = perform) {
            proxy_pass http://192.168.20.2;  # 手机版
        }
    }
}


```

## [socket 转发](http://nginx.org/en/docs/stream/ngx_stream_core_module.html)
该ngx_stream_core_module模块是自1.9.0版本。此模块不是默认构建的，应使用配置参数启用 --with-stream 
```sh
stream{
    upstream abc{
        server 172.18.8.196:11911;
    }
    server{
        listen 11911;
        proxy_pass abc;
    }
}
stream {
    upstream backend {
        hash $remote_addr consistent;

        server backend1.example.com:12345 weight=5;
        server 127.0.0.1:12345            max_fails=3 fail_timeout=30s;
        server unix:/tmp/backend3;
    }

    upstream dns {
       server 192.168.0.1:53535;
       server dns.example.com:53;
    }

    server {
        listen 12345;
        proxy_connect_timeout 1s;
        proxy_timeout 3s;
        proxy_pass backend;
    }

    server {
        listen 127.0.0.1:53 udp reuseport;
        proxy_timeout 20s;
        proxy_pass dns;
    }

    server {
        listen [::1]:12345;
        proxy_pass unix:/tmp/stream.socket;
    }
```

### 变量与分支匹配
```sh
if ($remote_addr ~ '61.48.40.26|124.204.43.26|111.200.255.79') {
                  #  set $pmz pmz_gray;
                }

                if ($http_user_agent ~ 'Application/huidu_test') {
                    set $pmz pmz_gray;
                }


                location ~ ^/sns/{
                    proxy_pass_header Server;
                    proxy_set_header Host $host;
                    proxy_redirect off;
                    proxy_set_header X-Real-IP $remote_addr;
                    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
                    proxy_set_header X-Scheme $scheme;
                    proxy_pass https://locaton.pmz.cn;
                }
```