## traffic management

circuit breakers, timeout, retries, A/B testing, canary rollout, staged rollout.

依赖于envoy，所有data plane traffic都由envoy代理。

## introduction
istio需要知道你的所有endpoints，以及他们属于哪个svc。所以istio需要连接一个sd system。for example, if you run istio in k8s, istio can detects the svcs and eps automatically.

istio‘s basic sd and lb is round-robin, but you can do more fine-grained control.
Istio's traffic management API is specified using k8s CRDs(your yaml stuff)

- Virtual Services
- Destination Rules
- Gateways
- Service entries
- Sidecars

## Virtual Services
- virtual services and destination rules are the key of traffic routing.
- vs let you configure how requests are routed, building on the basic connectivity and discovery.
- each vs consists of a set of **routing rules**

### virtual service example

```yaml
apiVersion: networking.istio.io/v1alpha3
kind: VirtualService
metadata:
  name: reviews
spec:
  hosts:               
  - reviews
  http:
  - match:
    - headers:
        end-user:
          exact: jason
    route:           # jason go to reviews:v2
    - destination:
        host: reviews
        subset: v2
  - route:           # default rule
    - destination:
        host: reviews
        subset: v3

apiVersion: networking.istio.io/v1alpha3
kind: VirtualService
metadata:
  name: bookinfo
spec:
  hosts:
    - bookinfo.com
  http:
  - match:
    - uri:
        prefix: /reviews
    route:
    - destination:
        host: reviews
  - match:
    - uri:
        prefix: /ratings
    route:
    - destination:
        host: ratings

# 分流 , ab , canary
spec:
  hosts:
  - reviews
  http:
  - route:
    - destination:
        host: reviews
        subset: v1
      weight: 75
    - destination:
        host: reviews
        subset: v2
      weight: 25
```

## destination rules

- virtual services is how to route your traffic to a given dest.
- destination rules to configure what happens to traffic for that dest.

### destination rule example

my-svc with different load balancing policies:

```yaml
apiVersion: networking.istio.io/v1alpha3
kind: DestinationRule
metadata:
  name: my-destination-rule
spec:
  host: my-svc
  trafficPolicy:
    loadBalancer:
      simple: RANDOM
  subsets:
  - name: v1
    labels:
      version: v1
  - name: v2
    labels:
      version: v2
    trafficPolicy:
      loadBalancer:
        simple: ROUND_ROBIN
  - name: v3
    labels:
      version: v3
```

## gateways

- to manage inbound and outbound traffic
- Gateway configurations are applied to standalone Envoy proxies that are running at the edge of the mesh, rather than sidecar Envoy proxies running alongside your service workloads.
- gateway configure layer 4-6 load balancing properties such as ports to expose, TLS settings, and so on. 
- Then instead of adding application-layer traffic routing (L7) to the same API resource, you bind a regular Istio virtual service to the gateway.
- gateway 主要用来管理ingress traffic，但是你也可以用它来管理egress。
  - configure a dedicated exit node for the traffic leaving the mesh, 
  - limit which services can or should access external networks, 
  - enable secure control of egress traffic to add security to your mesh

Istio provides some preconfigured gateway proxy deployments (istio-ingressgateway and istio-egressgateway) that you can use - both are deployed if you use our demo installation, while just the ingress gateway is deployed with our default profile. You can apply your own gateway configurations to these deployments or deploy and configure your own gateway proxies.

### gateway example
```yaml
apiVersion: networking.istio.io/v1alpha3
kind: Gateway
metadata:
  name: ext-host-gwy
spec:
  selector:
    app: my-gateway-controller
  servers:
  - port:
      number: 443
      name: https
      protocol: HTTPS
    hosts:
    - ext-host.example.com
    tls:
      mode: SIMPLE
      credentialName: ext-host-cert
```

to specify routing and for the gateway to work as intended. you must bind the gateway to a virtual service

```yaml
apiVersion: networking.istio.io/v1alpha3
kind: VirtualService
metadata:
  name: virtual-svc
spec:
  hosts:
  - ext-host.example.com
  gateways:
  - ext-host-gwy
```

## service entries
- use a service entry to add an entry to the service registry that istio maintains internally.
- 可以用来处理mesh外的服务

```yaml
apiVersion: networking.istio.io/v1alpha3
kind: ServiceEntry
metadata:
  name: svc-entry
spec:
  hosts:
  - ext-svc.example.com
  ports:
  - number: 443
    name: https
    protocol: HTTPS
  location: MESH_EXTERNAL
  resolution: DNS
```

## sidecars

you can
- Fine-tune the set of ports and protocols that an Envoy proxy accepts.
- Limit the set of services that the Envoy proxy can reach.

```yaml
apiVersion: networking.istio.io/v1alpha3
kind: Sidecar
metadata:
  name: default
  namespace: bookinfo
spec:
  egress:
  - hosts:
    - "./*"
    - "istio-system/*"
```

## Network resilience and testing

### timeout, retry, circuit breakers, fault injection

```yaml
apiVersion: networking.istio.io/v1alpha3
kind: VirtualService
metadata:
  name: ratings
spec:
  hosts:
  - ratings
  http:
  - route:
    - destination:
        host: ratings
        subset: v1
    timeout: 10s       # 超时
    retries:           # 重试
      attempts: 3
      perTryTimeout: 2s

apiVersion: networking.istio.io/v1alpha3
kind: DestinationRule
metadata:
  name: reviews
spec:
  host: reviews
  subsets:
  - name: v1
    labels:
      version: v1
    trafficPolicy:        ## 限流，断路 
      connectionPool:
        tcp:
          maxConnections: 100

apiVersion: networking.istio.io/v1alpha3
kind: VirtualService
metadata:
  name: ratings
spec:
  hosts:
  - ratings
  http:
  - fault:    故障注入
      delay:
        percentage:
          value: 0.1
        fixedDelay: 5s
    route:
    - destination:
        host: ratings
        subset: v1
```


## 参考
https://istio.io/latest/docs/concepts/traffic-management/
https://istio.io/latest/docs/ops/deployment/architecture/


**源码解析**

describe 一下 istiod 的pod发现其container就是polit

其中 `pilot-agent` 负责数据面 `Sidecar` 实例的生命周期管理，而 `pilot-discovery` 负责控制面流量管理配置及路由规则的生成和下发。

https://cloudnative.to/blog/istio-pilot/

[架构](https://www.notion.so/0860866ad1514a25b107e192a5cc96cd)