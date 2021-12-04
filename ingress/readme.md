https://docs.microsoft.com/en-us/azure/aks/ingress-own-tls

```sh
k create namespace ingress-basic

# deploy an nginx ingress controller
# during the installation, an azure public ip is created for the ingress controller.
# https://docs.microsoft.com/en-us/azure/aks/ingress-static-ip
helm install nginx-ingress stable/nginx-ingress \
    --namespace ingress-basic \
    --set controller.replicaCount=1 \
    --set controller.nodeSelector."beta\.kubernetes\.io/os"=linux \
    --set defaultBackend.nodeSelector."beta\.kubernetes\.io/os"=linux

# validate
kubectl get service -l app=nginx-ingress --namespace ingress-basic

# genearate tls cert
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -out aks-ingress-tls.crt \
    -keyout aks-ingress-tls.key \
    -subj "/CN=api.randomaccess.com/O=aks-ingress-tls"

# create k8s secret and put cert in it
kubectl create secret tls aks-ingress-tls --key aks-ingress-tls.key --cert aks-ingress-tls.crt

# add ingress
kubectl apply -f closet-ingress.yaml
``
