## rook quickstart

https://rook.io/docs/rook/v1.8/quickstart.html

```
git clone --single-branch --branch v1.8.0 https://github.com/rook/rook.git
cd rook/deploy/examples
kubectl create -f crds.yaml -f common.yaml -f operator.yaml

kubectl create -f cluster.yaml
# 如果是在minikube上的话
kubectl create -f deploy/examples/cluster-test.yaml  
# 遇到一个问题 https://github.com/rook/rook/issues/5022
https://blog.csdn.net/weixin_48225168/article/details/110129241

minikube 启动的时候加上 extra disk 并且disk搞大点？

kubectl -n rook-ceph get pod
```

1. 现在k8s上安装rook operator。也可以用helm来装 https://rook.io/docs/rook/v1.8/helm-operator.html
2. create a ceph cluster
3. 运行rook toolbox，并执行ceph status，如果health不是health_ok的话，check this https://rook.io/docs/rook/v1.8/ceph-common-issues.html

```
All mons should be in quorum
A mgr should be active
At least one OSD should be active
If the health is not HEALTH_OK, the warnings or errors should be investigated
```

## rook toolbox
https://rook.io/docs/rook/v1.8/ceph-toolbox.html

#### 安装toolbox

```sh
kubectl create -f deploy/examples/toolbox.yaml
kubectl -n rook-ceph rollout status deploy/rook-ceph-tools
kubectl -n rook-ceph exec -it deploy/rook-ceph-tools -- bash

ceph status
ceph osd status
ceph df
rados df

kubectl -n rook-ceph delete deploy/rook-ceph-tools
```