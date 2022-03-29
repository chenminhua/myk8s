kubectl cluster-info

# 按照label取数据
k get pods -l run=hello

# 打标签
k label pod xxxxxxxx app=v1
k get pods -l app=v1

# scale up
k scale deployments/hello --replicas=4

# 查看更新状态
k rollout status deployments/hello

# 回滚
k rollout undo deployments/hello
