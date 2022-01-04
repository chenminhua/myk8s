## run mysql
复制用户是replicator(可配置)

helm install sql-release --set auth.replicationPassword=1234qwer --set volumePermissions.enabled=true \
  --set auth.rootPassword=secretpassword,auth.database=app_database --set architecture=replication bitnami/mysql

## run kafka
helm install my-kafka bitnami/kafka --set volumePermissions.enabled=true --set zookeeper.volumePermissions.enabled=true


## 配置 maxwell
http://maxwells-daemon.io/quickstart/#docker

```
mysql> GRANT ALL ON maxwell.* TO 'replicator'@'%';
mysql> GRANT SELECT, REPLICATION CLIENT, REPLICATION SLAVE ON *.* TO 'replicator'@'%';
```
