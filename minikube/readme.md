## clean all
```
minikube delete --all --purge
```

### **Quickstart minikube**

- https://minikube.sigs.k8s.io/docs/start/
- 安装minikube，for mac (更新也是用一样的方法)

```shell
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-darwin-amd64
sudo install minikube-darwin-amd64 /usr/local/bin/minikube
```

- Start minikube cluster

```shell
minikube start --driver=virtualbox
kubectl get node -o wide
minikube status
minikube dashboard
// stop
minikube stop
```

### multi node

[https://minikube.sigs.k8s.io/docs/tutorials/multi_node/](https://minikube.sigs.k8s.io/docs/tutorials/multi_node/)

```shell
minikube start --nodes 3 --driver=virtualbox
minikube start --nodes 3 --driver=virtualbox --extra-disks=1  (currently only implemented for
hyperkit and kvm2 drivers)
vboxManage list vms
```

apply this

```shell
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: hello
spec:
  replicas: 2
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxUnavailable: 100%
  selector:
    matchLabels:
      app: hello
  template:
    metadata:
      labels:
        app: hello
    spec:
      affinity:
        # ⬇⬇⬇ This ensures pods will land on separate hosts
        podAntiAffinity:
          requiredDuringSchedulingIgnoredDuringExecution:
          - labelSelector:
              matchExpressions: [{ key: app, operator: In, values: [hello] }]
            topologyKey: "kubernetes.io/hostname"
      containers:
      - name: hello-from
        image: pbitty/hello-from:latest
        ports:
          - name: http
            containerPort: 80
      terminationGracePeriodSeconds: 1
---
apiVersion: v1
kind: Service
metadata:
  name: hello
spec:
  type: NodePort
  selector:
    app: hello
  ports:
    - protocol: TCP
      nodePort: 31000
      port: 80
      targetPort: http
```

然后查看地址

```shell
minikube service list
minikube tunnel
```

try curl

### addon

```shell
minikube addons list
```

### basic control

```shell
minikube dashboard

# 升级你的cluster
minikube start --kubernetes-version=latest

# 起第二个cluster
minikube start -p cluster2
```

### cni

```shell
minikube start --nodes 3 --driver=virtualbox --cni=flannel
```
