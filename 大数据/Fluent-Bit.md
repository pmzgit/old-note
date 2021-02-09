# what

Fluent Bit was born to address the need for a high performance and optimized tool that can collect data from any input source, unify that data and deliver it to multiple destinations.



1. 特点
   ①事件驱动：使用异步操作来收集和发送数据； 
   ②路由：数据通过插件会被打上tag，可以控制数据发往一个或多个目的地； 
   ③I/O处理： 在Input/Output层提供一个抽象，以异步方式执行读写； 
   ④upstream manager： 
   ⑤安全：通过TLS提供安全传输
    支持命令行配置

 2. 突出亮点
   ①：轻量级、高性能 
   ②：可扩展 
   ③：收集系统信息


curl -s http://127.0.0.1:2020 | jq

https://docs.fluentbit.io/manual/configuration/monitoring



# 转发daoes
```sh
[SERVICE]
    Flush        5
    Daemon       Off
    Log_Level    debug

[INPUT]
    Name      forward
    Listen    0.0.0.0
    Port      24224

[OUTPUT]
    Name  es
    Match *
    Host  es7
    Port  9200
    HTTP_User elastic
    HTTP_Passwd elastic
    Logstash_Format On
    Logstash_Prefix fluentbit
    Time_Key timestamp
    Time_Key_Format %Y-%m-%dT%H:%M:%S
    Index fluentbit
```
