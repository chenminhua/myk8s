https://github.com/rook/rook/blob/master/Documentation/quickstart.md

# block storage
Block storage allows a single pod to mount storage. 

在rook项目目录下

```
kubectl apply -f deploy/examples/csi/rbd/storageclass.yaml

k get CephBlockPool -n rook-ceph
k get storageclass

kubectl create -f deploy/examples/mysql.yaml
kubectl create -f deploy/examples/wordpress.yaml

k get pvc
k get pv
```

# shared filesystem
https://github.com/rook/rook/blob/master/Documentation/ceph-filesystem.md

A shared filesystem can be mounted with read/write permission from multiple pods. This may be useful for applications which can be clustered using a shared filesystem.

# 对象存储  Object
https://github.com/rook/rook/blob/master/Documentation/ceph-object.md

# dashboard
https://github.com/rook/rook/blob/master/Documentation/ceph-dashboard.md

```yaml
spec:
    dashboard:
      enabled: true
```

kubectl -n rook-ceph get service