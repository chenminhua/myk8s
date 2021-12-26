- k8s 的架构与其原型项目 Borg 非常类似，都由 Master 和 Node 两种节点组成。
- Master 由三个组件组成，分别是负责 API 服务的 kube-apiserver、负责调度的 kube-scheduler，以及负责容器编排的 kube-controller-manager。整个集群的持久化数据，则由 kube-apiserver 处理后保存在 Etcd 中。
- 计算节点核心的部分是 kubelet。kubelet负责和 CRI 打交道，而不关心具体是什么容器运行时。而具体的容器运行时负责将对 CRI 的请求翻译成系统调用（namespace 和 Cgroup 等）。
- Kubelet 另一个功能，是调用网络插件和存储插件为容器配置网络和持久化。对应接口分别是 CNI 和 CSI。kubelet 还和 Device Plugin 交互来管理 GPU 等物理设备。


# control plane 组件
https://kubernetes.io/docs/concepts/overview/components/

### api-server
expose k8s api, the front end of k8s control plane

### etcd
HA kv-store, for storing all cluster data. (make sure you have backup plan)

### kube-scheduler
scheduler负责查看所有新创建的pod中没有assign到node的pod，并负责给这些pod寻找最适合的node。
kube-scheduler是k8s默认的scheduler，也是k8s的control plane的默认组成部分。你也可以写自己的scheduler。

集群中，满足调度需求的node被称为feasible node。如果始终找不到feasible node，则pod会一直处于unscheduled状态。

scheduler找到最佳node后，就通知api server。这个操作叫做binding。

Factors that need taken into account for scheduling decisions include individual and collective resource requirements, hardware / software / policy constraints, affinity and anti-affinity specifications, data locality, inter-workload interference, and so on.

kube-scheduler select node for pod in 2 step: Filtering, Scoring

Scheduling Policies

Scheduling Profiles

### kube-controller-manager
- node controller
- replication controller
- service account & token controllers
- ...

### cloud-controller-manager
embeds cloud-specific control logic. The cloud controller manager lets you link your cluster into your cloud provider's api.

# Node 组件
- kubelet: agent that runs on each node. kubelet take PodSpecs and ensure containers described in PodSpecs are running and healthy.
- kube-proxy: network proxy that runs on each node. maintains network rules on nodes.
    - kube-proxy uses the operating system packet filtering layer if there is one and it's available. Otherwise, kube-proxy forwards the traffic itself.
    - kube-proxy maintains network rules on nodes.
- Container runtime: Responsible for running container. implement CRI, like docker, containerd

# 插件 （addons）

belong within kube-system namespae

[https://kubernetes.io/docs/concepts/cluster-administration/addons/](https://kubernetes.io/docs/concepts/cluster-administration/addons/)

- DNS
- Web UI
- Container Resource Monitoring
- Cluster-level Logging
