helm 是 k8s 的包管理工具。由服务端组件tiller和客户端helm组成。
helm能将一组k8s资源打包统一管理，共享。

helm是客户端工具，用于本地开发和管理chart。
tiller是helm的服务端，负责接收helm的请求，与k8s的api server进行交互。根据chart 来生成release并管理release。
helm打包的格式叫做chart，它描述了一组相关的k8s集群资源。
使用helm install在k8s中部署的chart称为release。
helm chart的仓库称为 Repository，helm客户端通过http访问repository中的chart

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

### dashboard

```sh
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.2.0/aio/deploy/recommended.yamldd
kubectl proxy
```
### etcd
```sh
helm install etcd --set volumePermissions.enabled=true --set replicaCount=3 bitnami/etcd
```

### hive
```sh
https://www.notion.so/hive-4e64292a92ea450096367bb93d226e0d

https://artifacthub.io/packages/helm/gradiant/hive

helm install my-hive gradiant/hive --version 0.1.6

进 hive-server 容器
k exec -ti my-hive-server-0 --sh
用 beeline 连接hive
beeline -u jdbc:hive2://localhost:10000

CREATE TABLE pokes (foo INT, bar STRING);
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
helm install sq --set volumePermissions.enabled=true \
  --set auth.rootPassword=secretpassword,auth.database=app_database --set metrics.enabled=true \
    bitnami/mysql
helm status sq
```

### shadowsocks

```sh
helm repo add predatorray http://predatorray.github.io/charts
helm upgrade --install shadowsocks predatorray/shadowsocks \\n    --set service.type=LoadBalancer --set shadowsocks.password.plainText=1234qwer
```

### zookeeper

```sh
https://github.com/bitnami/charts/tree/master/bitnami/zookeeper


helm repo add bitnami https://charts.bitnami.com/bitnami
helm install zk --set volumePermissions.enabled=true bitnami/zookeeper

helm install zk --set volumePermissions.enabled=true --set replicaCount=3 bitnami/zookeeper

helm status zk
```

