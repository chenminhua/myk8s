# Quick Start

## step1 **安装istio命令行工具**

Download https://github.com/istio/istio/releases， 并将bin加入path

## step2**安装istio到K8s集群**

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
kubectl delete -f [samples/addons](https://raw.githubusercontent.com/istio/istio/release-1.9/samples/addons)istioctl manifest generate --set profile=demo | kubectl delete --ignore-not-found=true -f -
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
```
