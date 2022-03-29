# 三分钟搞定一个k8s集群
```sh
# create resuorce group
az group create -n level --location eastasia

# create 1 node k8s
az aks create -g level -n lk8s --node-count 1 --generate-ssh-keys

# install kubectl
az aks install-cli

# get-credentials
az aks get-credentials -g level -n lk8s

# test connection and check node
kubectl get node
```

### 一个部署的例子
https://docs.microsoft.com/en-us/azure/aks/kubernetes-walkthrough

# 一分钟搞定 container registry

```sh
# create acr
 az acr create -g level -n levelacr --sku Basic

# login acr
az acr login -n levelacr

# 试试 push
docker pull hello-world
docker tag hello-world levelacr.azurecr.io/hello-world:v1
docker push levelacr.azurecr.io/hello-world:v1

docker pull nginx
docker tag nginx levelacr.azurecr.io/nginx:v1
docker push levelacr.azurecr.io/nginx:v1
```

### 如何通过docker login访问acr?

```sh
az acr update -n levelacr --admin-enable true
docker login levelacr.azurecr.io
# 然后去portal找到用户名和密码并输入即可
```

# 集成 acr 和aks

```
az aks update -n lk8s -g level --attach-acr levelacr
```

### 测试一下

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
spec:
  selector:
    matchLabels:
      app: nginx
  replicas: 2
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: levelacr.azurecr.io/nginx:v1
        ports:
        - containerPort: 80
---
apiVersion: v1
kind: Service
metadata:
  name: nginxtest
spec:
  type: LoadBalancer
  ports:
  - port: 80
  selector:
    app: nginx
```

```sh
kubectl apply -f deploy.yaml
kubectl get service
# get the external ip and access it, you will see a nginx welcome page
```

# cost
大概看了下，上面我们创建出来的机器用的vm是Standard_DS2_v2，每个月156刀。D2s_v3则是 每个月 96 刀。前者比后者好的地方是IO能力翻倍。

```sh
# 指定vm size
az aks create -g level -n lk8s --node-count 1 --node-vm-size Standard_D2s_v3 --generate-ssh-keys
# 如果你有多个aks cluster可以查看
az aks list -o table
```

# 如果机器down机了怎么办？

az vmss restart -g MC_mh_minhua1_eastasia -n  aks-nodepool1-13336345-vmss --instance-ids 0

# 如何debug node

k debug node/aks-nodepool1-13336345-vmss000000 -ti --image=mcr.microsoft.com/aks/fundamental/base-ubuntu:v0.0.11
