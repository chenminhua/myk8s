# 为什么需要 service mesh

- 服务发现
- 流量管理（ab 分流，灰度发布，流量拷贝，容灾切流）
- 弹性服务（断路，限流，超时，重试）
- 服务可见（监控，log，tracing，Dashboard）

传统的方式通常需要侵入应用程序，比如服务依赖某 sdk，或者在编译器内植入 runtime，或者编译时改字节码等等，这些方法都侵入了应用程序，也就是--服务治理功能的升级需要升级服务本身。这违反了关注点分离原则，业务逻辑与服务治理不能单独开发，升级，部署，管理。Service mesh 则简单地使用一个网络 proxy 的方式代理容器的入站与出站网络，从而把服务的控制逻辑与业务逻辑分离开来。对应用程序来说，这些治理能力的实现都是透明无感知的。

## step2 **安装 istio 到 K8s 集群**

istio 有很多[内置 configuration profile](https://istio.io/latest/docs/setup/additional-setup/config-profiles/) ，分别设置了不同的 control plane 和 data plane。我们也可以 [定制自己的 profile](https://istio.io/latest/docs/setup/install/istioctl/#customizing-the-configuration) 。在这个 quickstart 中，我们安装 demo profile（profile 在[这里](https://github.com/istio/istio/blob/master/manifests/profiles/demo.yaml)）。可以看到安装了 istio core, istiod, engressgateway, ingressgateway。一些相关的源码

- Controllers in k8s: https://github.com/kubernetes/kubernetes/tree/master/pkg/controller
- instioOperator Controller: https://github.com/istio/istio/tree/da6178604559bdf2c707a57f452d16bee0de90c8/operator/pkg/controller
- install.go: https://github.com/istio/istio/blob/da6178604559bdf2c707a57f452d16bee0de90c8/operator/cmd/mesh/install.go

kubectl api-resources | grep istio

istioctl proxy-status

# Addons

**装插件 kiali, prometheus, grafana, jaeger**

## **Dashboard kiali**

```jsx
istioctl dashboard kiali

for i in $(seq 1 100); do curl -s -o /dev/null "http://192.168.64.8:30556/productpage"; done;
```

**Metrics**

我们预装了个 istio addon，其实就是个预先配置好的 prometheus，会主动去抓取 istio 的数据。

`istioctl dashboard prometheus`

[istio/istio](https://github.com/istio/istio/blob/master/istioctl/cmd/dashboard.go) https://prometheus.io/docs/prometheus/latest/querying/basics/

`istio_requests_total istio_requests_total{destination_service="productpage.default.svc.cluster.local"} istio_requests_total{destination_service="reviews.default.svc.cluster.local", destination_version="v3"} rate(istio_requests_total{destination_service=~"productpage.*", response_code="200"}[5m])`

# arch

![arch](https://istio.io/latest/docs/ops/deployment/architecture/arch.svg)

## Components

### Envoy

envoy 是一个高性能 proxy，也是 istio 中唯一处理数据面流量的组件。envoy 有很多内置 feature：

- Dynamic service discovery
- Load balancing
- TLS termination
- HTTP/2 and gRPC proxies
- Circuit breakers
- Health checks
- Staged rollouts with %-based traffic split
- Fault injection
- Rich metrics

Some of the Istio features and tasks enabled by Envoy proxies include:

- Traffic control features: enforce fine-grained traffic control with rich routing rules for HTTP, gRPC, WebSocket, and TCP traffic.
- Network resiliency features: setup retries, failovers, circuit breakers, and fault injection.
- Security and authentication features: enforce security policies and enforce access control and rate limiting defined through the configuration API.
- Pluggable extensions model based on WebAssembly that allows for custom policy enforcement and telemetry generation for mesh traffic.

### Istiod

Istiod 提供服务发现，配置和证书管理等功能

Istiod converts high level routing rules that control traffic behavior into Envoy-specific configurations, and propagates them to the sidecars at runtime.

Pilot abstracts platform-specific service discovery mechanisms and synthesizes them into a standard format that any sidecar conforming with the Envoy API can consume.

Istio can support discovery for multiple environments such as Kubernetes, Consul, or VMs.

You can use Istio’s Traffic Management API to instruct Istiod to refine the Envoy configuration to exercise more granular control over the traffic in your service mesh.

Istiod security enables strong service-to-service and end-user authentication with built-in identity and credential management. You can use Istio to upgrade unencrypted traffic in the service mesh. Using Istio, operators can enforce policies based on service identity rather than on relatively unstable layer 3 or layer 4 network identifiers. Additionally, you can use Istio’s authorization feature to control who can access your services.

Istiod acts as a Certificate Authority (CA) and generates certificates to allow secure mTLS communication in the data plane.
