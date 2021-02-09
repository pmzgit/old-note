# 数字证书
## 概念 
 
SSL 证书有两个基本功能：网站身份验证和数据加密传输，对于电子商务网站来讲，经过权威第三方验证过网站的真实身份的证明，比加密信息本身更重要，因为一个不可信的网站(或欺诈网站)也可能有 https:// 安全锁标志 ( 主要原因是市场上有不验证网站实体身份，而只验证域名所有权的 DV SSL 证书)。

所以，绝对不能认为：看到安全锁标志就认为此网站可信，只能保证机密信息是加密传输的，还要看此 SSL 证书是什么类型的证书，从而判断此网站是否真的是网站上所声称的现实世界的某个公司。推荐电子商务网站都部署EV SSL证书 或 OV SSL证书，绝对不能部署已经被欺诈网站滥用的DV SSL证书。
* 如何区分  DV,OV,EV  
 通过 O字段： 是域名，还是公司名，或者地址栏是否显示公司名
* 参考  
https://www.wosign.com/FAQ/SSL_type_check.htm

## 分类
* https://www.barretlee.com/blog/2016/04/24/detail-about-ca-and-certs/

## openssl 自行签发SSL证书。

```sh
openssl genrsa -out server.key 4096
openssl rsa -in server.key -pubout -out server.pem
cat server.key 
cat server.pem 

openssl genrsa -out ca.key 4096
openssl req -x509 -new -key ca.key -out ca.cer -days 730 -subj '/C=CN/ST=Shanxi/L=Datong/O=Your Company Name/CN=Your Company Name Docker Registry CA'
# 以上命令中 -subj 参数里的 /C 表示国家，如 CN；/ST 表示省；/L 表示城市或者地区；/O 表示组织名；/CN 通用名称。
ifconfig 
hosts

openssl req -new -key server.key -out server.csr -sha256
openssl x509 -req -days 365 -sha256 -CA ca.cer -CAkey ca.key -CAcreateserial -in server.csr -out server.crt

openssl pkcs12 -export -in server.crt -inkey server.key -out server.p12 -name "server"
```

Pubkey: RSA, ELG, DSA, ECDH, ECDSA, EDDSA
Cipher: IDEA, 3DES, CAST5, BLOWFISH, AES, AES192, AES256, TWOFISH,
        CAMELLIA128, CAMELLIA192, CAMELLIA256
Hash: SHA1, RIPEMD160, SHA256, SHA384, SHA512, SHA224
Compression: Uncompressed, ZIP, ZLIB, BZIP2

## 公钥指纹
* 公开密钥指纹（下称：公钥指纹）是用于标识较长公共密钥字节的短序列，指纹通过应用加密散列函数到一个公共密钥来实现。由于指纹较比生成它们的密钥短得多，因此可以用来简化某些密钥的管理任务。
* 生成公钥指纹的概括步骤如下：  

        1. 公钥（以及任选的一些额外数据）被编码成一个字节序列，以确保同一指纹以后在相同情况下可以创建，因此编码必须是确定的，并且任何附加的数据必须与公共密钥一同存放。附加数据通常是使用此公共密钥的人应该知道的信息，如：密钥持有人的身份（此情况下，X.509信任固定的指纹，且所述附加数据包括一个X.509自签名证书）[2]。  
        2. 在前面步骤中产生的数据被散列加密，如使用SHA-1或SHA-2。  
        3. 如果需要，散列函数的输出可以缩短，以提供更方便管理的指纹。  
* 产生的短指纹可用于验证一个很长的公共密钥。例如，一个典型RSA公共密钥的长度会在1024位以上，MD5或SHA-1的指纹却只有128或160位。  

## 导入gpg 密钥
* `curl -fsSL https://mirrors.ustc.edu.cn/docker-ce/linux/debian/gpg | sudo apt-key add -`
* [apt-key](http://man.linuxde.net/apt-key)  
```sh
Usage: apt-key [--keyring file] [command] [arguments]

Manage apt's list of trusted keys

  apt-key add <file>          - add the key contained in <file> ('-' for stdin)
  apt-key del <keyid>         - remove the key <keyid>
  apt-key export <keyid>      - output the key <keyid>
  apt-key exportall           - output all trusted keys
  apt-key update              - update keys using the keyring package
  apt-key net-update          - update keys using the network
  apt-key list                - list keys
  apt-key finger              - list fingerprints
  apt-key adv                 - pass advanced options to gpg (download key)

If no specific keyring file is given the command applies to all keyring files.
```

http://www.ruanyifeng.com/blog/2013/07/gpg.html

## 导入证书


1）centos系统

wget https://dl.cacerts.digicert.com/BaltimoreCyberTrustRoot.crt
openssl x509 -inform der -in BaltimoreCyberTrustRoot.crt >> /etc/pki/ca-trust/extracted/pem/tls-ca-bundle.pem
update-ca-trust



2）ubuntu系统

sudo cp BaltimoreCyberTrustRoot.crt /usr/local/share/ca-certificates/BaltimoreCyberTrustRoot.crt
sudo update-ca-certificates



3）windows系统

下载更证书文件后，直接打开文件按照提示操作安装即可。