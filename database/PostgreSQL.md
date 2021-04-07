https://zh.wikipedia.org/wiki/PostgreSQL

https://www.postgresql.org/about/featurematrix/


http://www.postgres.cn/docs/13/index.html

## 安装
```sh
docker pull postgres

version: '3.1'

services:

  db:
    image: postgres
    restart: always
    environment:
      POSTGRES_PASSWORD: postgres
    ports:
      - 5432:5432
    volumes:
      - pg_data:/var/lib/postgresql/data  


volumes:
  pg_data:

networks:
    kafka-net:


docker stack deploy -c stack.yml postgres
```

## 客户端

* 当在命令行上指定用户和数据库名时，它们的大小写会被保留 — 空格或特殊字符的出现可能需要使用引号。表名和其他标识符的大小写不会被保留并且可能需要使用双引号
```sh

psql -U postgres -h ipaddress -d postgres
```