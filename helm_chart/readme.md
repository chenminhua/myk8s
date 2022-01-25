helm 是 k8s 的包管理工具。由服务端组件 tiller 和客户端 helm 组成。
helm 能将一组 k8s 资源打包统一管理，共享。

helm 是客户端工具，用于本地开发和管理 chart。
tiller 是 helm 的服务端，负责接收 helm 的请求，与 k8s 的 api server 进行交互。根据 chart 来生成 release 并管理 release。
helm 打包的格式叫做 chart，它描述了一组相关的 k8s 集群资源。
使用 helm install 在 k8s 中部署的 chart 称为 release。
helm chart 的仓库称为 Repository，helm 客户端通过 http 访问 repository 中的 chart

## search on web

[https://artifacthub.io/packages/search?ts_query_web=hive&page=1](https://artifacthub.io/packages/search?ts_query_web=hive&page=1)

## cmd

```
brew install helm
helm repo add influxdata [https://helm.influxdata.com/](https://helm.influxdata.com/)
helm search repo influxdata
helm repo update
helm install influxdata/influxdb --generate-name
helm list
```

## charts

### cert-manager

```sh
https://cert-manager.io/docs/installation/helm/

1. helm repo add jetstack https://charts.jetstack.io
2. helm repo update
3. helm install cert-manager jetstack/cert-manager --namespace cert-manager --create-namespace --version v1.6.1 --set installCRDs=true

按照完成 cert-manager, cert-manager-cainjector, cert-manager-webhook
```

### consul

```sh
helm install consul --set volumePermissions.enabled=true bitnami/consul
```

### etcd

```sh
helm install etcd --set volumePermissions.enabled=true --set replicaCount=3 bitnami/etcd
```

### hbase

```
helm install my-hbase gradiant/hbase --version 0.1.6 --set zookeeper.volumePermissions.enabled=true
```

### hive

```sh
https://www.notion.so/hive-4e64292a92ea450096367bb93d226e0d

https://artifacthub.io/packages/helm/gradiant/hive

helm install my-hive gradiant/hive --version 0.1.6 --set metastore.postgresql.volumePermissions.enabled=true

进 hive-server 容器
k exec -ti my-hive-server-0 --sh
用 beeline 连接hive
beeline -u jdbc:hive2://localhost:10000

CREATE TABLE pokes (foo INT, bar STRING);
insert into pokes (foo, bar) values (1, "hello"), (2, "world");

CREATE TABLE invites (foo INT, bar STRING) PARTITIONED BY (ds STRING);
SHOW TABLES;
DESCRIBE invites;
ALTER TABLE pokes ADD COLUMNS (new_col INT);
```

### kafka

```
helm install my-kafka bitnami/kafka --set volumePermissions.enabled=true --set zookeeper.volumePermissions.enabled=true
helm status my-kafka
```

### mysql

```
helm status sq
```

### redis-cluster

```
helm install rc bitnami/redis-cluster --set volumePermissions.enabled=true
```

### zookeeper

```sh
https://github.com/bitnami/charts/tree/master/bitnami/zookeeper


helm repo add bitnami https://charts.bitnami.com/bitnami
helm install zk --set volumePermissions.enabled=true bitnami/zookeeper

helm install zk --set volumePermissions.enabled=true --set replicaCount=3 bitnami/zookeeper

helm status zk
```
