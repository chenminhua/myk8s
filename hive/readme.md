https://artifacthub.io/packages/helm/gradiant/hive

helm install my-hive gradiant/hive --version 0.1.6

进 hive-server 容器
k exec -ti my-hive-server-0 -sh
用 beeline 连接hive
beeline -u jdbc:hive://localhost:10000

```
CREATE TABLE pokes (foo INT, bar STRING);
CREATE TABLE invites (foo INT, bar STRING) PARTITIONED BY (ds STRING);
SHOW TABLES;
DESCRIBE invites;
ALTER TABLE pokes ADD COLUMNS (new_col INT);
```
