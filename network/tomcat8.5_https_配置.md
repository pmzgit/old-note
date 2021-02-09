## server.xml
* JKS 格式
```xml

<Connector port="443" protocol="org.apache.coyote.http11.Http11NioProtocol"
               maxThreads="150" SSLEnabled="true">
        <SSLHostConfig>
            <Certificate certificateKeystoreFile="conf/test1.jks" certificateKeystorePassword="123456" certificateKeyPassword="888888" certificateKeyAlias="test_pri_key_entity"
                         type="RSA" />
        </SSLHostConfig>
</Connector>

```
* PKCS12 格式
```xml
<Connector port="443" protocol="org.apache.coyote.http11.Http11NioProtocol"
               maxThreads="150" SSLEnabled="true">
        <SSLHostConfig>
            <Certificate certificateKeystoreFile="conf/domain.pfx" 
            certificateKeystoreType="PKCS12"
             certificateKeystorePassword="123456" 
             <!-- certificateKeyAlias="domain"  可选 -->
                         type="RSA" />
        </SSLHostConfig>
</Connector>

```

## 修改默认访问根目录（默认是ROOT目录）
在server.xml 配置文件Host 节点下添加以下子节点配置 ,修改docBase值，例如webApp，并在webapps下创建相应的webApp目录（默认是ROOT）
```xml
<Host name="localhost"  appBase="webapps"
            unpackWARs="true" autoDeploy="true">
	<Context path="" docBase="webApp" debug="0" reloadable="true"/>	
        
        <Valve className="org.apache.catalina.valves.AccessLogValve" directory="logs"
               prefix="localhost_access_log" suffix=".txt"
               pattern="%h %l %u %t &quot;%r&quot; %s %b" />

      </Host>

```