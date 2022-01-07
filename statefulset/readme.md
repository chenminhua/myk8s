deployment不足以覆盖所有应用编排问题。deployment假设所有pod都是对等的，但试试并非如此。

- 实例间可能有依赖关系。如主从关系，主备关系。
- 数据存储类应用，实例会在本地磁盘保存数据。

statefulset把真实世界中的应用状态，抽象为两种情况：

- 拓扑状态
- 存储状态。

而statefulSet的核心，就是通过某种方式记录这些状态。然后在Pod重建时恢复这些状态。

## headless service

service有两种方式被访问，一种是vip(虚拟ip)方式，一种是dns方式。而dns方式又分为normal service和headless service。

- normal service其实就是通过dns解析到vip，然后访问vip时转发到某一个pod上。(dns name -> service vip -> pod id)
- headless service则不需要分配vip，而是直接通过dns解析出某个Pod的ip。(dns name -> pod ip)

所谓的headless service其实也是个service，但是他定义中的ClusterIp是None，这样service被创建后不会被分配vip，而是以dns记录的方式暴露其代理的pod。

## example-1 拓扑状态

```yaml
apiVersion: v1
kind: Service
metadata:
  name: nginx
  labels:
    app: nginx
spec:
  ports:
  - port: 80
    name: web
  clusterIP: None    # headless service，没有vip
  selector:
    app: nginx
---
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: web
spec:
  serviceName: "nginx"   # 注意这个 serviceName field，就是告诉statefulSet controller，请使用nginx这个headless service 来保证pod的可解析身份。
  replicas: 2
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx:1.9.1
        ports:
        - containerPort: 80
          name: web
```

运行下面命令，你会发现，这两个pod是依次创建的。在web-0进入ready前，web-1一直会处于pending状态。

```sh
kubectl get pods -w -l app=nginx

kubectl exec web-0 -- sh -c 'hostname'
# web-0
kubectl exec web-1 -- sh -c 'hostname'
# web-1
```

我们以dns方式来访问一下这两个pod

```sh
kubectl run -i --tty --image busybox:1.28.4 dns-test --restart=Never --rm /bin/sh 
# nslookup web-0.nginx
# nslookup web-1.nginx
```

通过这种方法，Kubernetes 就成功地将 Pod 的拓扑状态（比如：哪个节点先启动，哪个节点后启动），按照 Pod 的“名字 + 编号”的方式固定了下来。此外，Kubernetes 还为每一个 Pod 提供了一个固定并且唯一的访问入口，即：这个 Pod 对应的 DNS 记录。这些状态，在 StatefulSet 的整个生命周期里都会保持不变，绝不会因为对应 Pod 的删除或者重新创建而失效。

## 存储状态

给每个pod的volume里面写入一个文件

```sh
for i in 0 1; do kubectl exec web-$i -- sh -c 'echo hello $(hostname) > /usr/share/nginx/html/index.html'; done

kubectl run multitool --image=praqma/network-multitool
# curl web-0.nginx
# curl web-1.nginx
```

然后尝试删除这两个pod，等Pod重启后再curl一下，发现内容没有丢失或者改变。原因是：

当你删除Pod后，其对应的pv和pvc其实都还在，volume里面的数据也都还在。这时,stateful控制器发现pod消失了，就重新创建一个pod，而他声明的pvc的名称也还是没变（比如我们这里的www-web-0），而当Pod被创建出来后，查找到了其对应的pvc，进而找到对应的pv，完成绑定。

## 小结
statefulSet里面的pod是不同的，每个都有字节的hostname，名字等等。只要pod的名字不变，pod的dns记录也不会变，其绑定的pv也不会变。