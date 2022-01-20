helm install nginx-ingress stable/nginx-ingress --set rbac.create=true --namespace=kube-system

获取 nginx-ingress-controller 的 public ip

helm install cert-manager jetstack/cert-manager --namespace cert-manager --create-namespace --version v1.5.3 --set installCRDs=true
