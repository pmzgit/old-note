## [SSL For Free](https://www.sslforfree.com/)

## ca,系统信任根证书的保存位置
debain:"/etc/ssl/certs/"  
redhat:"/etc/pki/tls/certs/ca-bundle.crt" 
* [OCSP_stapling_enabled](http://www.vpnhosting.cz/ocsp/)
* [How To Configure OCSP Stapling on Apache and Nginx](https://www.digitalocean.com/community/tutorials/how-to-configure-ocsp-stapling-on-apache-and-nginx)




## [jdk 根证书](https://docs.oracle.com/javase/6/docs/technotes/tools/solaris/keytool.html)
* 查找其中是否包含特定主题Subject/签发者（issuer）CN（Common Name）/的可信证书  
keytool -list -v -keystore $JAVA_HOME/jre/lib/security/cacerts
* 说明：证书序列号的显示方式一般有两种，一种是带":"的，以两个16进制数一组；一种是不带":"的，与前一种表示方法相比，其数值相同，但是最左边的0会被省略。
* 添加根证书到cacerts  
keytool -keystore $JAVA_HOME/jre/lib/security/cacerts -importcert -alias CAFriendlyName -file rootca-cert.pem 
--注：rootca-cert.pem为PEM格式的根CA证书文件，请使用表1中链接下载PEM格式根证书，CAFriendlyName是计划给此根CA的友好名称/别名，您可以用根证书主题名称代替,这个别名在一个jks中必须唯一。
* Java中一般使用如下几种方式来指定trustStore：  

1. 代码中设定，示例代码：
System.setProperty("javax.net.ssl.trustStore", "<same .jks file>");
2. 设置系统变量javax.net.ssl.trustStore
3. 修改JVM启动选项："-Djavax.net.ssl.trustStore=-Djavax.net.ssl.trustStore=<some .jks file>"

## 中间证书及证书链
中间证书，其实也叫中间 CA （中间证书颁发机构， Intermediate certificate authority, Intermedia CA ），对应的是根证书颁发机构（ Root certificate authority ， Root CA ）。为了验证证书是否可信，必须确保证书的颁发机构在设备的可信 CA 中。如果证书不是由可信 CA 签发，则会检查颁发这个 CA 证书的上层 CA 证书是否是可信 CA ，客户端将重复这个步骤，直到证明找到了可信 CA （将允许建立可信连接）或者证明没有可信 CA （将提示错误）。

为了构建信任链，每个证书都包括字段：“使用者”和“颁发者”。 中间 CA 将在这两个字段中显示不同的信息，显示设备如何获得下一个 CA 证书，重复检查是否是可信 CA 。

根证书，必然是一个自签名的证书，“使用者”和“颁发者”都是相同的，所以不会进一步向下检查，如果根 CA 不是可信 CA ，则将不允许建立可信连接，并提示错误。

例如：一个服务器证书 domain.com ，是由 Intermedia CA 签发，而 Intermedia CA 的颁发者 Root CA 在 WEB 浏览器可信 CA 列表中，则证书的信任链如下：

证书 1 - 使用者： domain.com ；颁发者： Intermedia CA

证书 2 - 使用者： Intermedia CA ；颁发者： Root CA

证书 3 - 使用者： Root CA ； 办法和： Root CA

当 Web 浏览器验证到证书 3 ： Root CA 时，发现是一个可信 CA ，则完成验证，允许建立可信连接。当然有些情况下， Intermedia CA 也在可信 CA 列表中，这个时候，就可以直接完成验证，建立可信连接。

但如果 Web 浏览器在验证过程中，没有找到这个 Intermedia CA ，那即使 Root CA 本身是可信 CA ，但因为 WEB 浏览器无法通过中间证书来发现这个 Root CA ，最后也会导致无法完成验证，无法建立可信连接。

要获得中间证书，一般有两种方式：第一种、由客户端自动下载中间证书；第二种、由服务器推送中间证书。
* [证书链检查](https://www.myssl.cn/tools/check-server-cert.html)
* 获取服务端配置的证书链
openssl s_client -connect es.broaddeep.com.cn:443 -servername es.broaddeep.com.cn  -showcerts  

openssl s_client -connect 127.0.0.1:443 -cert cert/sm2/sm21.cer -key cert/sm2/sm21.key -CAfile cert/sm2/sm2root.cer -dcert cert/sm2/sm22.cer -dkey cert/sm2/sm22.key -cipher ECDHE-SM4-SM3 -top1.1

openssl  s_server -cert cert/sm2/sm22.cer -key cert/sm2/sm22.key   -dcert cert/sm2/sm21.cer -dkey cert/sm2/sm21.key  -Verify 1  -CAfile cert/sm2/sm2root.cer   -port 443 -cipher ECDHE-SM4-SM3 -top1.1


* 由服务器推送中间证书
顺序 server.pem > 中间证书.pem




./certbot-auto certonly --webroot --agree-tos -v -t --email pmz010@126.com -w ./ -d www.isuosuo.cn






















NET::ERR_CERT_COMMON_NAME_INVALID

Subject: pmzng.ngrok.xiaomiqiu.cn

Issuer: Let's Encrypt Authority X3

Expires on: 2018年5月30日

Current date: 2018年3月1日

此服务器无法证明它是192.168.200.67；其安全证书来自pmzng.ngrok.xiaomiqiu.cn。出现此问题的原因可能是配置有误或您的连接被拦截了。



```sh
Root logging level set at 10
Saving debug log to /var/log/letsencrypt/letsencrypt.log
Requested authenticator webroot and installer None
Single candidate plugin: * webroot
Description: Place files in webroot directory
Interfaces: IAuthenticator, IPlugin
Entry point: webroot = certbot.plugins.webroot:Authenticator
Initialized: <certbot.plugins.webroot.Authenticator object at 0x7f8dbe8e2278>
Prep: True
Selected authenticator <certbot.plugins.webroot.Authenticator object at 0x7f8dbe8e2278> and installer None
Plugins selected: Authenticator webroot, Installer None
Picked account: <Account(RegistrationResource(new_authzr_uri='https://acme-v01.api.letsencrypt.org/acme/new-authz', body=Registration(contact=('mailto:pmz010@126.com',), key=JWKRSA(key=<ComparableRSAKey(<cryptography.hazmat.backends.openssl.rsa._RSAPublicKey object at 0x7f8dbca1f940>)>), status='valid', agreement='https://letsencrypt.org/documents/LE-SA-v1.2-November-15-2017.pdf'), terms_of_service='https://letsencrypt.org/documents/LE-SA-v1.2-November-15-2017.pdf', uri='https://acme-v01.api.letsencrypt.org/acme/reg/30273308'), 86ab7756d400d80dd538d50144c28c3e, Meta(creation_dt=datetime.datetime(2018, 2, 28, 13, 47, 20, tzinfo=<UTC>), creation_host='chinaunicom.cn'))>
Sending GET request to https://acme-v01.api.letsencrypt.org/directory.
Starting new HTTPS connection (1): acme-v01.api.letsencrypt.org
https://acme-v01.api.letsencrypt.org:443 "GET /directory HTTP/1.1" 200 562
Received response:
HTTP 200
Server: nginx
Content-Type: application/json
Content-Length: 562
Replay-Nonce: zFuUKo0sVQcQktdIciuiXbcSsrj27QvsJatwdyHTX2g
X-Frame-Options: DENY
Strict-Transport-Security: max-age=604800
Expires: Thu, 01 Mar 2018 11:02:12 GMT
Cache-Control: max-age=0, no-cache, no-store
Pragma: no-cache
Date: Thu, 01 Mar 2018 11:02:12 GMT
Connection: keep-alive

b'{\n  "key-change": "https://acme-v01.api.letsencrypt.org/acme/key-change",\n  "lT705BocURo": "https://community.letsencrypt.org/t/adding-random-entries-to-the-directory/33417",\n  "meta": {\n    "terms-of-service": "https://letsencrypt.org/documents/LE-SA-v1.2-November-15-2017.pdf"\n  },\n  "new-authz": "https://acme-v01.api.letsencrypt.org/acme/new-authz",\n  "new-cert": "https://acme-v01.api.letsencrypt.org/acme/new-cert",\n  "new-reg": "https://acme-v01.api.letsencrypt.org/acme/new-reg",\n  "revoke-cert": "https://acme-v01.api.letsencrypt.org/acme/revoke-cert"\n}'
Obtaining a new certificate
Requesting fresh nonce
Sending HEAD request to https://acme-v01.api.letsencrypt.org/acme/new-authz.
https://acme-v01.api.letsencrypt.org:443 "HEAD /acme/new-authz HTTP/1.1" 405 0
Received response:
HTTP 405
Server: nginx
Content-Type: application/problem+json
Content-Length: 91
Allow: POST
Replay-Nonce: BajjJa7gJWFnrbUtQB7O_TUzp1mmvOg2LGykHZi-KKk
Expires: Thu, 01 Mar 2018 11:02:15 GMT
Cache-Control: max-age=0, no-cache, no-store
Pragma: no-cache
Date: Thu, 01 Mar 2018 11:02:15 GMT
Connection: keep-alive

b''
Storing nonce: BajjJa7gJWFnrbUtQB7O_TUzp1mmvOg2LGykHZi-KKk
JWS payload:
b'{\n  "resource": "new-authz",\n  "identifier": {\n    "type": "dns",\n    "value": "pmzng.ngrok.xiaomiqiu.cn"\n  }\n}'
Sending POST request to https://acme-v01.api.letsencrypt.org/acme/new-authz:
{
  "protected": "eyJhbGciOiAiUlMyNTYiLCAiandrIjogeyJuIjogInF5Tzh6QTYxc3cyUTRKVGRlRkxqQ0hkejlkZlBqLTY4VXBGV1RVTExEeWFsUXJoOEt5dmo2a1JQclRrWGtIcTlTWmE4a0dvQy12R29iQjg0bmRPb0otQmZjeGlfaUNSS2NRT1FkeDZ0MlFEQmJOZl82MUE1dDRjS1Q0YS13bGItbWs0cXZHWFMxaXQ2UGZrMDQ2dFlkcU56RVduUjB5V29SNnotNy1UZGVZZGpuSF9sWUZYVE5WUzYtUVpDMHBpWV85eEl3cTNFMl9SMy1JWDk4Vk9fWXM5NkFCNy1tRzVIMDRIWmt2Q0EtQzQ2Nmg3RGpjLXB3X3I4NTN6aWNWd2o2OEZMc0ktQjQwN1RqQ0diX1Jpb0xfSjhsOFFiRDFuN2g5VUsxdmhucmxrVERyZDVHaS12WlZNVFpibUM1SUQ3MXlOeDFEUGNPZzZESVpRdGRaejNKdyIsICJlIjogIkFRQUIiLCAia3R5IjogIlJTQSJ9LCAibm9uY2UiOiAiQmFqakphN2dKV0ZucmJVdFFCN09fVFV6cDFtbXZPZzJMR3lrSFppLUtLayJ9",
  "payload": "ewogICJyZXNvdXJjZSI6ICJuZXctYXV0aHoiLAogICJpZGVudGlmaWVyIjogewogICAgInR5cGUiOiAiZG5zIiwKICAgICJ2YWx1ZSI6ICJwbXpuZy5uZ3Jvay54aWFvbWlxaXUuY24iCiAgfQp9",
  "signature": "KlSkJ7Q1A4EehI_550LYqlkYGzd9fZtnd0VXIu_7-83X9mGg95uelirhaxlJwOBL2sQ5j-gwVNZnM5YUwtj2hHF569WlFyN8mXXX8Eexpejg7VPpTPVRaDW05P9sOKFF8w9H1zAIhk0zJ8fc3uzJfiiOESWIW_cMbzUCq80Db77vH4J5FQspNTeq35W2SVZ7y-TyL8XqPRRmHHSAtox9CdNYq0kMkkbk5ckhLQKiqi7hII01nonGjttMZUIkWNeTKj-EKpEgzE03ONhCerYsGO17DO5YcWNuTdkU-InskmDzPu_eQO_hBh6nIbvVwiHQhlQm_oqN3IuQVvXA8tBeBg"
}
https://acme-v01.api.letsencrypt.org:443 "POST /acme/new-authz HTTP/1.1" 201 739
Received response:
HTTP 201
Server: nginx
Content-Type: application/json
Content-Length: 739
Boulder-Requester: 30273308
Link: <https://acme-v01.api.letsencrypt.org/acme/new-cert>;rel="next"
Location: https://acme-v01.api.letsencrypt.org/acme/authz/UdSS4kWloOLAJ30daOV3U5g0i62ByB0rhJc0ou7s7S8
Replay-Nonce: YK87VI5BzERrdLQeaSgwnnwa9UJhjHBYJUU9Wh-SgcY
X-Frame-Options: DENY
Strict-Transport-Security: max-age=604800
Expires: Thu, 01 Mar 2018 11:02:18 GMT
Cache-Control: max-age=0, no-cache, no-store
Pragma: no-cache
Date: Thu, 01 Mar 2018 11:02:18 GMT
Connection: keep-alive

b'{\n  "identifier": {\n    "type": "dns",\n    "value": "pmzng.ngrok.xiaomiqiu.cn"\n  },\n  "status": "pending",\n  "expires": "2018-03-08T11:02:18.863490566Z",\n  "challenges": [\n    {\n      "type": "http-01",\n      "status": "pending",\n      "uri": "https://acme-v01.api.letsencrypt.org/acme/challenge/UdSS4kWloOLAJ30daOV3U5g0i62ByB0rhJc0ou7s7S8/3647254138",\n      "token": "AEhZqUMCosuPwlVdPgqUgAkt_IOLrVfXq0lWxuDeaaI"\n    },\n    {\n      "type": "dns-01",\n      "status": "pending",\n      "uri": "https://acme-v01.api.letsencrypt.org/acme/challenge/UdSS4kWloOLAJ30daOV3U5g0i62ByB0rhJc0ou7s7S8/3647254139",\n      "token": "6YGyGsiUF36PLlgyVIYCObG9j7ZcKPg3VoYk3FY_Wx8"\n    }\n  ],\n  "combinations": [\n    [\n      0\n    ],\n    [\n      1\n    ]\n  ]\n}'
Storing nonce: YK87VI5BzERrdLQeaSgwnnwa9UJhjHBYJUU9Wh-SgcY
Performing the following challenges:
http-01 challenge for pmzng.ngrok.xiaomiqiu.cn
Using the webroot path /home/pmz/me/letsencrypt for all unmatched domains.
Creating root challenges validation dir at /home/pmz/me/letsencrypt/.well-known/acme-challenge
Attempting to save validation to /home/pmz/me/letsencrypt/.well-known/acme-challenge/AEhZqUMCosuPwlVdPgqUgAkt_IOLrVfXq0lWxuDeaaI
Waiting for verification...
JWS payload:
b'{\n  "type": "http-01",\n  "resource": "challenge",\n  "keyAuthorization": "AEhZqUMCosuPwlVdPgqUgAkt_IOLrVfXq0lWxuDeaaI.T_mtVt9eXGkcwx9GP7IIdA5EKBlSv-sPRPIJ4ExDNxk"\n}'
Sending POST request to https://acme-v01.api.letsencrypt.org/acme/challenge/UdSS4kWloOLAJ30daOV3U5g0i62ByB0rhJc0ou7s7S8/3647254138:
{
  "protected": "eyJhbGciOiAiUlMyNTYiLCAiandrIjogeyJuIjogInF5Tzh6QTYxc3cyUTRKVGRlRkxqQ0hkejlkZlBqLTY4VXBGV1RVTExEeWFsUXJoOEt5dmo2a1JQclRrWGtIcTlTWmE4a0dvQy12R29iQjg0bmRPb0otQmZjeGlfaUNSS2NRT1FkeDZ0MlFEQmJOZl82MUE1dDRjS1Q0YS13bGItbWs0cXZHWFMxaXQ2UGZrMDQ2dFlkcU56RVduUjB5V29SNnotNy1UZGVZZGpuSF9sWUZYVE5WUzYtUVpDMHBpWV85eEl3cTNFMl9SMy1JWDk4Vk9fWXM5NkFCNy1tRzVIMDRIWmt2Q0EtQzQ2Nmg3RGpjLXB3X3I4NTN6aWNWd2o2OEZMc0ktQjQwN1RqQ0diX1Jpb0xfSjhsOFFiRDFuN2g5VUsxdmhucmxrVERyZDVHaS12WlZNVFpibUM1SUQ3MXlOeDFEUGNPZzZESVpRdGRaejNKdyIsICJlIjogIkFRQUIiLCAia3R5IjogIlJTQSJ9LCAibm9uY2UiOiAiWUs4N1ZJNUJ6RVJyZExRZWFTZ3dubndhOVVKaGpIQllKVVU5V2gtU2djWSJ9",
  "payload": "ewogICJ0eXBlIjogImh0dHAtMDEiLAogICJyZXNvdXJjZSI6ICJjaGFsbGVuZ2UiLAogICJrZXlBdXRob3JpemF0aW9uIjogIkFFaFpxVU1Db3N1UHdsVmRQZ3FVZ0FrdF9JT0xyVmZYcTBsV3h1RGVhYUkuVF9tdFZ0OWVYR2tjd3g5R1A3SUlkQTVFS0JsU3Ytc1BSUElKNEV4RE54ayIKfQ",
  "signature": "m8Omr1OMty9jMdVyTZ2eT8wJ1sK4rOlHiGSI8K04QbPDM7z-bA-qbDP9BqQ05Sv_cjifC0kUDOv8I0OFhc-HV9Yku1z3raSfnuhaKO-psMYPdHeeQY_t6FQTJUAdLMzGFh8NWD-XhOIKT6nHj9KE_SHIkL_XCE2oV5kUsM18En3d_eVx3Rar1b52ZFfA957U-28ezbjNsszJiggjL0Bwipt8v5nBxbNmjPJku5FgBRk4FRp0pxzSSU0cZ54gmE7mXO6AZXhtdcarwMUluO225GpeJ9Hg3RMIBljUlt6gsNITDc1gZuoKATuy6H1bu6QpKOh1k5m2bfAo-Mp6scnucA"
}
https://acme-v01.api.letsencrypt.org:443 "POST /acme/challenge/UdSS4kWloOLAJ30daOV3U5g0i62ByB0rhJc0ou7s7S8/3647254138 HTTP/1.1" 202 336
Received response:
HTTP 202
Server: nginx
Content-Type: application/json
Content-Length: 336
Boulder-Requester: 30273308
Link: <https://acme-v01.api.letsencrypt.org/acme/authz/UdSS4kWloOLAJ30daOV3U5g0i62ByB0rhJc0ou7s7S8>;rel="up"
Location: https://acme-v01.api.letsencrypt.org/acme/challenge/UdSS4kWloOLAJ30daOV3U5g0i62ByB0rhJc0ou7s7S8/3647254138
Replay-Nonce: QAy4RblP4FvcDfS0O3vNI-nDq_hxr4ozx3AuY6NvTOE
Expires: Thu, 01 Mar 2018 11:02:22 GMT
Cache-Control: max-age=0, no-cache, no-store
Pragma: no-cache
Date: Thu, 01 Mar 2018 11:02:22 GMT
Connection: keep-alive

b'{\n  "type": "http-01",\n  "status": "pending",\n  "uri": "https://acme-v01.api.letsencrypt.org/acme/challenge/UdSS4kWloOLAJ30daOV3U5g0i62ByB0rhJc0ou7s7S8/3647254138",\n  "token": "AEhZqUMCosuPwlVdPgqUgAkt_IOLrVfXq0lWxuDeaaI",\n  "keyAuthorization": "AEhZqUMCosuPwlVdPgqUgAkt_IOLrVfXq0lWxuDeaaI.T_mtVt9eXGkcwx9GP7IIdA5EKBlSv-sPRPIJ4ExDNxk"\n}'
Storing nonce: QAy4RblP4FvcDfS0O3vNI-nDq_hxr4ozx3AuY6NvTOE
Sending GET request to https://acme-v01.api.letsencrypt.org/acme/authz/UdSS4kWloOLAJ30daOV3U5g0i62ByB0rhJc0ou7s7S8.
https://acme-v01.api.letsencrypt.org:443 "GET /acme/authz/UdSS4kWloOLAJ30daOV3U5g0i62ByB0rhJc0ou7s7S8 HTTP/1.1" 200 1213
Received response:
HTTP 200
Server: nginx
Content-Type: application/json
Content-Length: 1213
Link: <https://acme-v01.api.letsencrypt.org/acme/new-cert>;rel="next"
Replay-Nonce: 28ja_xSjbGIMArFpa6VI32EI1dtqLoon_8RwggXTqy8
X-Frame-Options: DENY
Strict-Transport-Security: max-age=604800
Expires: Thu, 01 Mar 2018 11:02:27 GMT
Cache-Control: max-age=0, no-cache, no-store
Pragma: no-cache
Date: Thu, 01 Mar 2018 11:02:27 GMT
Connection: keep-alive

b'{\n  "identifier": {\n    "type": "dns",\n    "value": "pmzng.ngrok.xiaomiqiu.cn"\n  },\n  "status": "valid",\n  "expires": "2018-03-31T11:02:23Z",\n  "challenges": [\n    {\n      "type": "http-01",\n      "status": "valid",\n      "uri": "https://acme-v01.api.letsencrypt.org/acme/challenge/UdSS4kWloOLAJ30daOV3U5g0i62ByB0rhJc0ou7s7S8/3647254138",\n      "token": "AEhZqUMCosuPwlVdPgqUgAkt_IOLrVfXq0lWxuDeaaI",\n      "keyAuthorization": "AEhZqUMCosuPwlVdPgqUgAkt_IOLrVfXq0lWxuDeaaI.T_mtVt9eXGkcwx9GP7IIdA5EKBlSv-sPRPIJ4ExDNxk",\n      "validationRecord": [\n        {\n          "url": "http://pmzng.ngrok.xiaomiqiu.cn/.well-known/acme-challenge/AEhZqUMCosuPwlVdPgqUgAkt_IOLrVfXq0lWxuDeaaI",\n          "hostname": "pmzng.ngrok.xiaomiqiu.cn",\n          "port": "80",\n          "addressesResolved": [\n            "120.25.161.137"\n          ],\n          "addressUsed": "120.25.161.137"\n        }\n      ]\n    },\n    {\n      "type": "dns-01",\n      "status": "pending",\n      "uri": "https://acme-v01.api.letsencrypt.org/acme/challenge/UdSS4kWloOLAJ30daOV3U5g0i62ByB0rhJc0ou7s7S8/3647254139",\n      "token": "6YGyGsiUF36PLlgyVIYCObG9j7ZcKPg3VoYk3FY_Wx8"\n    }\n  ],\n  "combinations": [\n    [\n      0\n    ],\n    [\n      1\n    ]\n  ]\n}'
Cleaning up challenges
Removing /home/pmz/me/letsencrypt/.well-known/acme-challenge/AEhZqUMCosuPwlVdPgqUgAkt_IOLrVfXq0lWxuDeaaI
All challenges cleaned up, removing /home/pmz/me/letsencrypt/.well-known/acme-challenge
Generating key (2048 bits): /etc/letsencrypt/keys/0000_key-certbot.pem
Creating CSR: /etc/letsencrypt/csr/0000_csr-certbot.pem
CSR: CSR(file='/etc/letsencrypt/csr/0000_csr-certbot.pem', data=b'-----BEGIN CERTIFICATE REQUEST-----\nMIICezCCAWMCAQIwADCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAM1f\n2KGmlDZVimQIES/W5qSSQtGHDUYMPgiDNpuIqpb2Wj7PlmMnqYIvfgANSJ2FNxzn\nB7UF1y4LnQALufzocR43eVYhkKbUq32wRpRGhkf1suVy9DnNBENq8SuhWAM7lYvU\nAFJRqM9+eDsDoaC9s1pwgN7b2u6IuA5fBpn9WLNMS8od2Mw79QyZe6baSz+RRBef\n2xsA3qgSzh8I2uPnqmnj9qBb0cQLg+y7Hk1kXRJfSe/LbBwHr8+nouJnh7fO7TYk\ndE9P2LZsRE5OL58tO/7VCoMMLKnxy6aCy4OYhQ16BubaAz0kYmvsc90y//L5IRNj\nCA3IUIx4O+VUQRKlQI8CAwEAAaA2MDQGCSqGSIb3DQEJDjEnMCUwIwYDVR0RBBww\nGoIYcG16bmcubmdyb2sueGlhb21pcWl1LmNuMA0GCSqGSIb3DQEBCwUAA4IBAQBQ\ncAu+0BCOMyb1ohGJVAQp0wbqHMD9vrcBbLnLj4P0E3QCsvZaWt7pD30uI/DH7Vty\nMZ19xz16Xx2YTXXx1MLL2a+rhMg2N3oORusHNnZZTKQR1KK/z5RJmuR6aTS4++Mm\neMgk7bOkxiBtI48HLNwTsyglMteWmP7dpB/JBhphbQuxr4oA+6kGz8VWlWSmUC2N\nNvxqyLgW5+/5piA1nELrA+Xo3jMpfuihVScQRH0P0yzjmTeX4wl0tjI4WEKtTKk8\nb+hFWpFRvjfy5lTHfu6wbMKwRcsb+cNvYh3owqRTlVUPCu/Dub4fv99LZLNSAFt6\nsNzul1QqsWGAn+8vONhK\n-----END CERTIFICATE REQUEST-----\n', form='pem'), domains: ['pmzng.ngrok.xiaomiqiu.cn']
Requesting issuance...
JWS payload:
b'{\n  "resource": "new-cert",\n  "csr": "MIICezCCAWMCAQIwADCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAM1f2KGmlDZVimQIES_W5qSSQtGHDUYMPgiDNpuIqpb2Wj7PlmMnqYIvfgANSJ2FNxznB7UF1y4LnQALufzocR43eVYhkKbUq32wRpRGhkf1suVy9DnNBENq8SuhWAM7lYvUAFJRqM9-eDsDoaC9s1pwgN7b2u6IuA5fBpn9WLNMS8od2Mw79QyZe6baSz-RRBef2xsA3qgSzh8I2uPnqmnj9qBb0cQLg-y7Hk1kXRJfSe_LbBwHr8-nouJnh7fO7TYkdE9P2LZsRE5OL58tO_7VCoMMLKnxy6aCy4OYhQ16BubaAz0kYmvsc90y__L5IRNjCA3IUIx4O-VUQRKlQI8CAwEAAaA2MDQGCSqGSIb3DQEJDjEnMCUwIwYDVR0RBBwwGoIYcG16bmcubmdyb2sueGlhb21pcWl1LmNuMA0GCSqGSIb3DQEBCwUAA4IBAQBQcAu-0BCOMyb1ohGJVAQp0wbqHMD9vrcBbLnLj4P0E3QCsvZaWt7pD30uI_DH7VtyMZ19xz16Xx2YTXXx1MLL2a-rhMg2N3oORusHNnZZTKQR1KK_z5RJmuR6aTS4--MmeMgk7bOkxiBtI48HLNwTsyglMteWmP7dpB_JBhphbQuxr4oA-6kGz8VWlWSmUC2NNvxqyLgW5-_5piA1nELrA-Xo3jMpfuihVScQRH0P0yzjmTeX4wl0tjI4WEKtTKk8b-hFWpFRvjfy5lTHfu6wbMKwRcsb-cNvYh3owqRTlVUPCu_Dub4fv99LZLNSAFt6sNzul1QqsWGAn-8vONhK"\n}'
Sending POST request to https://acme-v01.api.letsencrypt.org/acme/new-cert:
{
  "protected": "eyJhbGciOiAiUlMyNTYiLCAiandrIjogeyJuIjogInF5Tzh6QTYxc3cyUTRKVGRlRkxqQ0hkejlkZlBqLTY4VXBGV1RVTExEeWFsUXJoOEt5dmo2a1JQclRrWGtIcTlTWmE4a0dvQy12R29iQjg0bmRPb0otQmZjeGlfaUNSS2NRT1FkeDZ0MlFEQmJOZl82MUE1dDRjS1Q0YS13bGItbWs0cXZHWFMxaXQ2UGZrMDQ2dFlkcU56RVduUjB5V29SNnotNy1UZGVZZGpuSF9sWUZYVE5WUzYtUVpDMHBpWV85eEl3cTNFMl9SMy1JWDk4Vk9fWXM5NkFCNy1tRzVIMDRIWmt2Q0EtQzQ2Nmg3RGpjLXB3X3I4NTN6aWNWd2o2OEZMc0ktQjQwN1RqQ0diX1Jpb0xfSjhsOFFiRDFuN2g5VUsxdmhucmxrVERyZDVHaS12WlZNVFpibUM1SUQ3MXlOeDFEUGNPZzZESVpRdGRaejNKdyIsICJlIjogIkFRQUIiLCAia3R5IjogIlJTQSJ9LCAibm9uY2UiOiAiUUF5NFJibFA0RnZjRGZTME8zdk5JLW5EcV9oeHI0b3p4M0F1WTZOdlRPRSJ9",
  "payload": "ewogICJyZXNvdXJjZSI6ICJuZXctY2VydCIsCiAgImNzciI6ICJNSUlDZXpDQ0FXTUNBUUl3QURDQ0FTSXdEUVlKS29aSWh2Y05BUUVCQlFBRGdnRVBBRENDQVFvQ2dnRUJBTTFmMktHbWxEWlZpbVFJRVNfVzVxU1NRdEdIRFVZTVBnaUROcHVJcXBiMldqN1BsbU1ucVlJdmZnQU5TSjJGTnh6bkI3VUYxeTRMblFBTHVmem9jUjQzZVZZaGtLYlVxMzJ3UnBSR2hrZjFzdVZ5OURuTkJFTnE4U3VoV0FNN2xZdlVBRkpScU05LWVEc0RvYUM5czFwd2dON2IydTZJdUE1ZkJwbjlXTE5NUzhvZDJNdzc5UXlaZTZiYVN6LVJSQmVmMnhzQTNxZ1N6aDhJMnVQbnFtbmo5cUJiMGNRTGcteTdIazFrWFJKZlNlX0xiQndIcjgtbm91Sm5oN2ZPN1RZa2RFOVAyTFpzUkU1T0w1OHRPXzdWQ29NTUxLbnh5NmFDeTRPWWhRMTZCdWJhQXowa1ltdnNjOTB5X19MNUlSTmpDQTNJVUl4NE8tVlVRUktsUUk4Q0F3RUFBYUEyTURRR0NTcUdTSWIzRFFFSkRqRW5NQ1V3SXdZRFZSMFJCQnd3R29JWWNHMTZibWN1Ym1keWIyc3VlR2xoYjIxcGNXbDFMbU51TUEwR0NTcUdTSWIzRFFFQkN3VUFBNElCQVFCUWNBdS0wQkNPTXliMW9oR0pWQVFwMHdicUhNRDl2cmNCYkxuTGo0UDBFM1FDc3ZaYVd0N3BEMzB1SV9ESDdWdHlNWjE5eHoxNlh4MllUWFh4MU1MTDJhLXJoTWcyTjNvT1J1c0hOblpaVEtRUjFLS196NVJKbXVSNmFUUzQtLU1tZU1nazdiT2t4aUJ0STQ4SExOd1RzeWdsTXRlV21QN2RwQl9KQmhwaGJRdXhyNG9BLTZrR3o4VldsV1NtVUMyTk52eHF5TGdXNS1fNXBpQTFuRUxyQS1YbzNqTXBmdWloVlNjUVJIMFAweXpqbVRlWDR3bDB0akk0V0VLdFRLazhiLWhGV3BGUnZqZnk1bFRIZnU2d2JNS3dSY3NiLWNOdlloM293cVJUbFZVUEN1X0R1YjRmdjk5TFpMTlNBRnQ2c056dWwxUXFzV0dBbi04dk9OaEsiCn0",
  "signature": "NHZWJMPLd6rmu1ulrCOP7LuA7A9hmaqVUBJUKPW12NlAOqzhB_L7wc1Hk3_mvH4L33ymbLBW8Rom_uSVNkhAR1zmGiwt3kiR90YdforLrSXc6TxG2O68jLtNVwYu3r5WxnGXqs_KIuQR7T-kvuxuSZ5V2PbeKY2JFYMsqrob2zcHNtjSJTTNQkVMYyq_gNf1S5To5evf4F55I3RbNYv9gFGHa3Pgjar_u1aebNUiRNr1OA0Hnhmbnr80Oj2_rM8ncA466aDDwf6RcyWCcNFGPGSKgPB-35PaG-KOZSj4-omGMF5dCNJLDj_xAPFg7NzSLkAmYNSuwLNDTSaZb5S6DA"
}
https://acme-v01.api.letsencrypt.org:443 "POST /acme/new-cert HTTP/1.1" 201 1303
Received response:
HTTP 201
Server: nginx
Content-Type: application/pkix-cert
Content-Length: 1303
Boulder-Requester: 30273308
Link: <https://acme-v01.api.letsencrypt.org/acme/issuer-cert>;rel="up"
Location: https://acme-v01.api.letsencrypt.org/acme/cert/03f2467cdbac44837b49e4fe2818c5c66c00
Replay-Nonce: TAB0K-PQfpE_B2Fk9_73ITTdcHr2ua1aGgmXRmmoQeU
X-Frame-Options: DENY
Strict-Transport-Security: max-age=604800
Expires: Thu, 01 Mar 2018 11:02:30 GMT
Cache-Control: max-age=0, no-cache, no-store
Pragma: no-cache
Date: Thu, 01 Mar 2018 11:02:30 GMT
Connection: keep-alive

b'MIIFEzCCA/ugAwIBAgISA/JGfNusRIN7SeT+KBjFxmwAMA0GCSqGSIb3DQEBCwUAMEoxCzAJBgNVBAYTAlVTMRYwFAYDVQQKEw1MZXQncyBFbmNyeXB0MSMwIQYDVQQDExpMZXQncyBFbmNyeXB0IEF1dGhvcml0eSBYMzAeFw0xODAzMDExMDAyMzBaFw0xODA1MzAxMDAyMzBaMCMxITAfBgNVBAMTGHBtem5nLm5ncm9rLnhpYW9taXFpdS5jbjCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAM1f2KGmlDZVimQIES/W5qSSQtGHDUYMPgiDNpuIqpb2Wj7PlmMnqYIvfgANSJ2FNxznB7UF1y4LnQALufzocR43eVYhkKbUq32wRpRGhkf1suVy9DnNBENq8SuhWAM7lYvUAFJRqM9+eDsDoaC9s1pwgN7b2u6IuA5fBpn9WLNMS8od2Mw79QyZe6baSz+RRBef2xsA3qgSzh8I2uPnqmnj9qBb0cQLg+y7Hk1kXRJfSe/LbBwHr8+nouJnh7fO7TYkdE9P2LZsRE5OL58tO/7VCoMMLKnxy6aCy4OYhQ16BubaAz0kYmvsc90y//L5IRNjCA3IUIx4O+VUQRKlQI8CAwEAAaOCAhgwggIUMA4GA1UdDwEB/wQEAwIFoDAdBgNVHSUEFjAUBggrBgEFBQcDAQYIKwYBBQUHAwIwDAYDVR0TAQH/BAIwADAdBgNVHQ4EFgQU5CpsNkx5gT03yjukxTHnMkxMG+gwHwYDVR0jBBgwFoAUqEpqYwR93brm0Tm3pkVl7/Oo7KEwbwYIKwYBBQUHAQEEYzBhMC4GCCsGAQUFBzABhiJodHRwOi8vb2NzcC5pbnQteDMubGV0c2VuY3J5cHQub3JnMC8GCCsGAQUFBzAChiNodHRwOi8vY2VydC5pbnQteDMubGV0c2VuY3J5cHQub3JnLzAjBgNVHREEHDAaghhwbXpuZy5uZ3Jvay54aWFvbWlxaXUuY24wgf4GA1UdIASB9jCB8zAIBgZngQwBAgEwgeYGCysGAQQBgt8TAQEBMIHWMCYGCCsGAQUFBwIBFhpodHRwOi8vY3BzLmxldHNlbmNyeXB0Lm9yZzCBqwYIKwYBBQUHAgIwgZ4MgZtUaGlzIENlcnRpZmljYXRlIG1heSBvbmx5IGJlIHJlbGllZCB1cG9uIGJ5IFJlbHlpbmcgUGFydGllcyBhbmQgb25seSBpbiBhY2NvcmRhbmNlIHdpdGggdGhlIENlcnRpZmljYXRlIFBvbGljeSBmb3VuZCBhdCBodHRwczovL2xldHNlbmNyeXB0Lm9yZy9yZXBvc2l0b3J5LzANBgkqhkiG9w0BAQsFAAOCAQEALKcZ8ymLd5HfbFbLcIUbpnU2DwiPft5dxpJjJZuRVIVWsua45/103/QrLTRfVudMPRqrrEVK9YrrXIepz24z1whafzxghC/eTezJIKyjQn6B3ozYRUccV6a5i8duUHksj9Awa3MfksLwzpyaPw8HnqDuZJfra85gR5GY0TZNkZJlIx0ZnV/2rbKQooeWkO9QAbisa0mbIqwaNO6/I6IuNkbovqiQfTQ6B/vF43A7iLljP5nYyGEULZQWs51o4sMBkKwy9FHStYQLSHMIV3+0/QQntLfmjTn6mNnl49zaDvkaSZmnI2Pwo7a4uUOlAnKWeCQF/1ymcBEWEovqShSUpQ=='
Storing nonce: TAB0K-PQfpE_B2Fk9_73ITTdcHr2ua1aGgmXRmmoQeU
Sending GET request to https://acme-v01.api.letsencrypt.org/acme/issuer-cert.
https://acme-v01.api.letsencrypt.org:443 "GET /acme/issuer-cert HTTP/1.1" 200 1174
Received response:
HTTP 200
Server: nginx
Content-Type: application/pkix-cert
Content-Length: 1174
Replay-Nonce: MttN5ZMSjOKs4mvFIgZ3huFz_T-2EbtQq44Ua3j0GkI
X-Frame-Options: DENY
Strict-Transport-Security: max-age=604800
Expires: Thu, 01 Mar 2018 11:02:32 GMT
Cache-Control: max-age=0, no-cache, no-store
Pragma: no-cache
Date: Thu, 01 Mar 2018 11:02:32 GMT
Connection: keep-alive

b'MIIEkjCCA3qgAwIBAgIQCgFBQgAAAVOFc2oLheynCDANBgkqhkiG9w0BAQsFADA/MSQwIgYDVQQKExtEaWdpdGFsIFNpZ25hdHVyZSBUcnVzdCBDby4xFzAVBgNVBAMTDkRTVCBSb290IENBIFgzMB4XDTE2MDMxNzE2NDA0NloXDTIxMDMxNzE2NDA0NlowSjELMAkGA1UEBhMCVVMxFjAUBgNVBAoTDUxldCdzIEVuY3J5cHQxIzAhBgNVBAMTGkxldCdzIEVuY3J5cHQgQXV0aG9yaXR5IFgzMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAnNMM8FrlLke3cl03g7NoYzDq1zUmGSXhvb418XCSL7e4S0EFq6meNQhY7LEqxGiHC6PjdeTm86dicbp5gWAf15Gan/PQeGdxyGkOlZHP/uaZ6WA8SMx+yk13EiSdRxta67nsHjcAHJyse6cF6s5K671B5TaYucv9bTyWaN8jKkKQDIZ0Z8h/pZq4UmEUEz9l6YKHy9v6Dlb2honzhT+Xhq+w3Brvaw2VFn3EK6BlspkENnWAa6xK8xuQSXgvopZPKiAlKQTGdMDQMc2PMTiVFrqoM7hD8bEfwzB/onkxEz0tNvjj/PIzark5McWvxI0NHWQWM6r6hCm21AvA2H3DkwIDAQABo4IBfTCCAXkwEgYDVR0TAQH/BAgwBgEB/wIBADAOBgNVHQ8BAf8EBAMCAYYwfwYIKwYBBQUHAQEEczBxMDIGCCsGAQUFBzABhiZodHRwOi8vaXNyZy50cnVzdGlkLm9jc3AuaWRlbnRydXN0LmNvbTA7BggrBgEFBQcwAoYvaHR0cDovL2FwcHMuaWRlbnRydXN0LmNvbS9yb290cy9kc3Ryb290Y2F4My5wN2MwHwYDVR0jBBgwFoAUxKexpHsscfrb4UuQdf/EFWCFiRAwVAYDVR0gBE0wSzAIBgZngQwBAgEwPwYLKwYBBAGC3xMBAQEwMDAuBggrBgEFBQcCARYiaHR0cDovL2Nwcy5yb290LXgxLmxldHNlbmNyeXB0Lm9yZzA8BgNVHR8ENTAzMDGgL6AthitodHRwOi8vY3JsLmlkZW50cnVzdC5jb20vRFNUUk9PVENBWDNDUkwuY3JsMB0GA1UdDgQWBBSoSmpjBH3duubRObemRWXv86jsoTANBgkqhkiG9w0BAQsFAAOCAQEA3TPXEfNjWDjdGBX7CVW+dla5cEilaUcne8IkCJLxWh9KEik3JHRRHGJouM2VcGfl96S8TihRzZvoroed6ti6WqEBmtzw3Wodatg+VyOeph4EYpr/1wXKtx8/wApIvJSwtmVi4MFU5aMqrSDE6ea73Mj2tcMyo5jMd6jmeWUHK8so/joWUoHOUgwuX4Po1QYz+3dszkDqMp4fklxBwXRsW10KXzPMTZ+sOPAveyxindmjkW8lGy+QsRlGPfZ+G6Z6h7mjem0Y+iWlkYcV4PIWL1iwBi8saCbGS5jN2p8M+X+Q7UNKEkROb3N6KOqkqm57TH2H3eDJAkSnh6/DNFu0Qg=='
Creating directory /etc/letsencrypt/archive.
Creating directory /etc/letsencrypt/live.
Archive directory /etc/letsencrypt/archive/pmzng.ngrok.xiaomiqiu.cn and live directory /etc/letsencrypt/live/pmzng.ngrok.xiaomiqiu.cn created.
Writing certificate to /etc/letsencrypt/live/pmzng.ngrok.xiaomiqiu.cn/cert.pem.
Writing private key to /etc/letsencrypt/live/pmzng.ngrok.xiaomiqiu.cn/privkey.pem.
Writing chain to /etc/letsencrypt/live/pmzng.ngrok.xiaomiqiu.cn/chain.pem.
Writing full chain to /etc/letsencrypt/live/pmzng.ngrok.xiaomiqiu.cn/fullchain.pem.
Writing README to /etc/letsencrypt/live/pmzng.ngrok.xiaomiqiu.cn/README.
Requested authenticator webroot and installer <certbot.cli._Default object at 0x7f8dbc2a09b0>
Default Detector is Namespace(account=<certbot.cli._Default object at 0x7f8dbc319c50>, agree_dev_preview=None, allow_subset_of_names=<certbot.cli._Default object at 0x7f8dbc319a90>, apache=<certbot.cli._Default object at 0x7f8dbc3192e8>, apache_challenge_location=<certbot.cli._Default object at 0x7f8dbc2a51d0>, apache_ctl=<certbot.cli._Default object at 0x7f8dbc2a5470>, apache_dismod=<certbot.cli._Default object at 0x7f8dbc2a3d30>, apache_enmod=<certbot.cli._Default object at 0x7f8dbc2a3c50>, apache_handle_modules=<certbot.cli._Default object at 0x7f8dbc2a52b0>, apache_handle_sites=<certbot.cli._Default object at 0x7f8dbc2a5390>, apache_init_script=<certbot.cli._Default object at 0x7f8dbc2a5550>, apache_le_vhost_ext=<certbot.cli._Default object at 0x7f8dbc2a3e10>, apache_logs_root=<certbot.cli._Default object at 0x7f8dbc2a50f0>, apache_server_root=<certbot.cli._Default object at 0x7f8dbc2a3ef0>, apache_vhost_root=<certbot.cli._Default object at 0x7f8dbc2a3fd0>, authenticator='webroot', break_my_certs=<certbot.cli._Default object at 0x7f8dbc31e940>, cert_path=<certbot.cli._Default object at 0x7f8dbc2a07b8>, certname=<certbot.cli._Default object at 0x7f8dbc344f28>, chain_path=<certbot.cli._Default object at 0x7f8dbc2a0518>, checkpoints=<certbot.cli._Default object at 0x7f8dbc2a01d0>, config_dir=<certbot.cli._Default object at 0x7f8dbc2a0be0>, config_file=None, configurator=<certbot.cli._Default object at 0x7f8dbc2a09b0>, csr=<certbot.cli._Default object at 0x7f8dbc344ba8>, debug=<certbot.cli._Default object at 0x7f8dbc31e2e8>, debug_challenges=<certbot.cli._Default object at 0x7f8dbc31e400>, delete_after_revoke=<certbot.cli._Default object at 0x7f8dbc2a06a0>, deploy_hook=<certbot.cli._Default object at 0x7f8dbc31e278>, dialog=None, directory_hooks=<certbot.cli._Default object at 0x7f8dbc319eb8>, dns_cloudflare=<certbot.cli._Default object at 0x7f8dbc2a32b0>, dns_cloudxns=<certbot.cli._Default object at 0x7f8dbc2a32e8>, dns_digitalocean=<certbot.cli._Default object at 0x7f8dbc2a3390>, dns_dnsimple=<certbot.cli._Default object at 0x7f8dbc2a35c0>, dns_dnsmadeeasy=<certbot.cli._Default object at 0x7f8dbc2a36a0>, dns_google=<certbot.cli._Default object at 0x7f8dbc2a3780>, dns_luadns=<certbot.cli._Default object at 0x7f8dbc2a3860>, dns_nsone=<certbot.cli._Default object at 0x7f8dbc2a3940>, dns_rfc2136=<certbot.cli._Default object at 0x7f8dbc2a3a20>, dns_route53=<certbot.cli._Default object at 0x7f8dbc2a3b00>, domains='pmzng.ngrok.xiaomiqiu.cn', dry_run=<certbot.cli._Default object at 0x7f8dbc319080>, duplicate=<certbot.cli._Default object at 0x7f8dbc319d68>, eff_email=<certbot.cli._Default object at 0x7f8dbc319438>, email='pmz010@126.com', expand=<certbot.cli._Default object at 0x7f8dbc3196d8>, force_interactive=<certbot.cli._Default object at 0x7f8dbc344d30>, fullchain_path=<certbot.cli._Default object at 0x7f8dbc2a07f0>, func=<function certonly at 0x7f8dbfc84d08>, hsts=<certbot.cli._Default object at 0x7f8dbc31eda0>, http01_address=<certbot.cli._Default object at 0x7f8dbc31e860>, http01_port=<certbot.cli._Default object at 0x7f8dbc31e780>, ifaces=<certbot.cli._Default object at 0x7f8dbc2a0f28>, init=<certbot.cli._Default object at 0x7f8dbc2a0400>, installer=<certbot.cli._Default object at 0x7f8dbc2a09b0>, key_path=<certbot.cli._Default object at 0x7f8dbc2a0390>, logs_dir=<certbot.cli._Default object at 0x7f8dbc2a0898>, manual=<certbot.cli._Default object at 0x7f8dbc2a3470>, manual_auth_hook=<certbot.cli._Default object at 0x7f8dbc2a3c18>, manual_cleanup_hook=<certbot.cli._Default object at 0x7f8dbc2a5710>, manual_public_ip_logging_ok=<certbot.cli._Default object at 0x7f8dbc2a57f0>, max_log_backups=<certbot.cli._Default object at 0x7f8dbc344be0>, must_staple=<certbot.cli._Default object at 0x7f8dbc31eb00>, nginx=<certbot.cli._Default object at 0x7f8dbc3191d0>, nginx_ctl=<certbot.cli._Default object at 0x7f8dbc2a59b0>, nginx_server_root=<certbot.cli._Default object at 0x7f8dbc2a5630>, no_bootstrap=<certbot.cli._Default object at 0x7f8dbc31e048>, no_self_upgrade=<certbot.cli._Default object at 0x7f8dbc319f28>, no_verify_ssl=<certbot.cli._Default object at 0x7f8dbc31e4e0>, noninteractive_mode=<certbot.cli._Default object at 0x7f8dbc344cc0>, num=<certbot.cli._Default object at 0x7f8dbc319a58>, os_packages_only=<certbot.cli._Default object at 0x7f8dbc319e48>, post_hook=<certbot.cli._Default object at 0x7f8dbc31e630>, pre_hook=<certbot.cli._Default object at 0x7f8dbc31e7f0>, pref_challs=<certbot.cli._Default object at 0x7f8dbc31e9b0>, prepare=<certbot.cli._Default object at 0x7f8dbc2a0668>, quiet=<certbot.cli._Default object at 0x7f8dbc31e128>, reason=<certbot.cli._Default object at 0x7f8dbc344e10>, redirect=<certbot.cli._Default object at 0x7f8dbc31ebe0>, register_unsafely_without_email=<certbot.cli._Default object at 0x7f8dbc319160>, reinstall=<certbot.cli._Default object at 0x7f8dbc3195f8>, renew_by_default=<certbot.cli._Default object at 0x7f8dbc3198d0>, renew_hook=<certbot.cli._Default object at 0x7f8dbc31e470>, renew_with_new_domains=<certbot.cli._Default object at 0x7f8dbc3199b0>, rsa_key_size=<certbot.cli._Default object at 0x7f8dbc31ea20>, server=<certbot.cli._Default object at 0x7f8dbc2a05c0>, staging=<certbot.cli._Default object at 0x7f8dbc31e208>, standalone=<certbot.cli._Default object at 0x7f8dbc319048>, standalone_supported_challenges=<certbot.cli._Default object at 0x7f8dbc2a5a90>, staple=<certbot.cli._Default object at 0x7f8dbc31eef0>, strict_permissions=<certbot.cli._Default object at 0x7f8dbc31eb70>, text_mode=True, tls_sni_01_address=<certbot.cli._Default object at 0x7f8dbc31e6a0>, tls_sni_01_port=<certbot.cli._Default object at 0x7f8dbc31e5c0>, tos=True, uir=<certbot.cli._Default object at 0x7f8dbc31ef60>, update_registration=<certbot.cli._Default object at 0x7f8dbc319240>, user_agent=<certbot.cli._Default object at 0x7f8dbc8bcc88>, user_agent_comment=<certbot.cli._Default object at 0x7f8dbc344ef0>, validate_hooks=<certbot.cli._Default object at 0x7f8dbc31e0b8>, verb='certonly', verbose_count=True, webroot=True, webroot_map=<certbot.cli._Default object at 0x7f8dbc2a5c50>, webroot_path='./', work_dir=<certbot.cli._Default object at 0x7f8dbc2a04e0>)
Writing new config /etc/letsencrypt/renewal/pmzng.ngrok.xiaomiqiu.cn.conf.
Reporting to user: Congratulations! Your certificate and chain have been saved at:
/etc/letsencrypt/live/pmzng.ngrok.xiaomiqiu.cn/fullchain.pem
Your key file has been saved at:
/etc/letsencrypt/live/pmzng.ngrok.xiaomiqiu.cn/privkey.pem
Your cert will expire on 2018-05-30. To obtain a new or tweaked version of this certificate in the future, simply run certbot-auto again. To non-interactively renew *all* of your certificates, run "certbot-auto renew"
Reporting to user: If you like Certbot, please consider supporting our work by:

Donating to ISRG / Let's Encrypt:   https://letsencrypt.org/donate
Donating to EFF:                    https://eff.org/donate-le



IMPORTANT NOTES:
 - Congratulations! Your certificate and chain have been saved at:
   /etc/letsencrypt/live/pmzng.ngrok.xiaomiqiu.cn/fullchain.pem
   Your key file has been saved at:
   /etc/letsencrypt/live/pmzng.ngrok.xiaomiqiu.cn/privkey.pem
   Your cert will expire on 2018-05-30. To obtain a new or tweaked
   version of this certificate in the future, simply run certbot-auto
   again. To non-interactively renew *all* of your certificates, run
   "certbot-auto renew"
 - If you like Certbot, please consider supporting our work by:

   Donating to ISRG / Let's Encrypt:   https://letsencrypt.org/donate
   Donating to EFF:                    https://eff.org/donate-le
```