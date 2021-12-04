kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yam
metrics server 被装在了 kube-system 这个 namespace 下

如果失败了的话，检查下是不是ca证书的问题，如果是测试环境，可以加  --kubelet-insecure-tls  这个参数。（在这个目录下的components.yaml文件中已经添加了这个参数）

然后你就可以
k top node
