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