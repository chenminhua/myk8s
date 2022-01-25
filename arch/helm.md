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
