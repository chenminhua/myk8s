# 为什么需要service mesh

- 服务发现
- 流量管理（ab分流，灰度发布，流量拷贝，容灾切流）
- 弹性服务（断路，限流，超时，重试）
- 服务可见（监控，log，tracing，Dashboard）

传统的方式通常需要侵入应用程序，比如服务依赖某sdk，或者在编译器内植入runtime，或者编译时改字节码等等，这些方法都侵入了应用程序，也就是--服务治理功能的升级需要升级服务本身。这违反了关注点分离原则，业务逻辑与服务治理不能单独开发，升级，部署，管理。Service mesh则简单地使用一个网络proxy的方式代理容器的入站与出站网络，从而把服务的控制逻辑与业务逻辑分离开来。对应用程序来说，这些治理能力的实现都是透明无感知的。

# Quick Start
https://istio.io/latest/docs/setup/getting-started/

## step1 **安装istio命令行工具**

```sh
curl -sL https://istio.io/downloadIstioctl | sh -
export PATH=$PATH:$HOME/.istioctl/bin
```
## step2 **安装istio到K8s集群**

istio有很多[内置configuration profile](https://istio.io/latest/docs/setup/additional-setup/config-profiles/) ，分别设置了不同的control plane和data plane。我们也可以 [定制自己的profile](https://istio.io/latest/docs/setup/install/istioctl/#customizing-the-configuration) 。在这个quickstart中，我们安装demo profile（profile在[这里](https://github.com/istio/istio/blob/master/manifests/profiles/demo.yaml)）。可以看到安装了istio core, istiod, engressgateway, ingressgateway。一些相关的源码

- Controllers in k8s: https://github.com/kubernetes/kubernetes/tree/master/pkg/controller
- instioOperator Controller: https://github.com/istio/istio/tree/da6178604559bdf2c707a57f452d16bee0de90c8/operator/pkg/controller
- install.go:  https://github.com/istio/istio/blob/da6178604559bdf2c707a57f452d16bee0de90c8/operator/cmd/mesh/install.go

```jsx

istioctl install --set profile=demo
k get ns   # 有一个新增的namespace，为istio-system
k -n istio-system get all

# 给default namespace打上label istio-injection=enabled，这样在这个namespace里面部署的Pod都会有个sidecar部署的istio-proxy（envoy）。
k label namespace default istio-injection=enabled
k describe ns default
k api-resources
kubectl api-resources | grep istio

istioctl proxy-status
```

## step3 **部署demo**

```jsx
k apply -f samples/bookinfo/platform/kube/bookinfo.yaml
k get all
k describe pod ...... 查看container的sidecar
```

## step4 **check服务启动效果**

```jsx
kubectl exec "$(kubectl get pod -l app=ratings -o jsonpath='{.items[0].metadata.name}')" -c ratings -- curl -s productpage:9080/productpage
```

## step5 要让应用可以被外部访问，需要创建istio ingress gateway

```jsx
kubectl apply -f [samples/bookinfo/networking/bookinfo-gateway.yaml](https://raw.githubusercontent.com/istio/istio/release-1.7/samples/bookinfo/networking/bookinfo-gateway.yaml)

# 新建了个gateway和一个virtualservice

k get vs,gateway

istioctl analyze
```

然后要找到这个gateway的地址

```jsx
export INGRESS_PORT=$(kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.spec.ports[?(@.name=="http2")].nodePort}')
echo $INGRESS_PORT
export SECURE_INGRESS_PORT=$(kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.spec.ports[?(@.name=="https")].nodePort}')
echo $SECURE_INGRESS_PORT
export INGRESS_HOST=$(minikube ip)
echo $INGRESS_HOST
export GATEWAY_URL=$INGRESS_HOST:$INGRESS_PORT
echo "$GATEWAY_URL"
```

## Tunnel your minikube (virtualbox for me)

```jsx
minikube tunnel
访问http://$GATEWAY_URL/productpage
可以 K logs 查看下日志
```

# Quick Cleanup

```jsx
# uninstall the app
kubectl delete -f [samples/addons](https://raw.githubusercontent.com/istio/istio/release-1.9/samples/addons)
istioctl manifest generate --set profile=demo | kubectl delete --ignore-not-found=true -f -
kubectl delete namespace istio-system
kubectl label namespace default istio-injection-

# uninsatll istio
istioctl x uninstall --purge
```

# Addons

**装插件  kiali, prometheus, grafana, jaeger**

```jsx
kubectl apply -f [samples/addons](https://raw.githubusercontent.com/istio/istio/release-1.7/samples/addons)
```

"If there are errors trying to install the addons, try running the command again. There may be some timing issues which will be resolved when the command is run again."

## **Dashboard kiali**

```jsx
istioctl dashboard kiali

for i in $(seq 1 100); do curl -s -o /dev/null "http://192.168.64.8:30556/productpage"; done;
```


**Metrics**

我们预装了个istio addon，其实就是个预先配置好的prometheus，会主动去抓取istio的数据。

`istioctl dashboard prometheus`

[istio/istio](https://github.com/istio/istio/blob/master/istioctl/cmd/dashboard.go)  https://prometheus.io/docs/prometheus/latest/querying/basics/

`istio_requests_total
istio_requests_total{destination_service="productpage.default.svc.cluster.local"}
istio_requests_total{destination_service="reviews.default.svc.cluster.local", destination_version="v3"}
rate(istio_requests_total{destination_service=~"productpage.*", response_code="200"}[5m])`

**Grafana**

`istioctl dashboard grafana
 while :; do curl -s -o /dev/null 192.168.99.100:32182/productpage;  done`

[http://localhost:3000/dashboard/db/istio-mesh-dashboard](http://localhost:3000/dashboard/db/istio-mesh-dashboard)

This gives the global view of the Mesh along with services and workloads in the mesh. You can get more details about services and workloads by navigating to their specific dashboards as explained below.

http://localhost:3000/d/LJ_uJAvmk/istio-service-dashboard?orgId=1&refresh=1m

http://localhost:3000/d/UbsSZTDik/istio-workload-dashboard?orgId=1&refresh=1m

The Istio Dashboard consists of three main sections:

1. A Mesh Summary View. This section provides Global Summary view of the Mesh and shows HTTP/gRPC and TCP workloads in the Mesh.
2. Individual Services View. This section provides metrics about requests and responses for each individual service within the mesh (HTTP/gRPC and TCP). This also provides metrics about client and service workloads for this service.
3. Individual Workloads View: This section provides metrics about requests and responses for each individual workload within the mesh (HTTP/gRPC and TCP). This also provides metrics about inbound workloads and outbound services for this workload.

For more on how to create, configure, and edit dashboards, please see the [Grafana documentation](https://docs.grafana.org/).

`k exec -ti details-v1-79f774bdb9-kkzxk -c istio-proxy /bin/sh`
