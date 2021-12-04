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

# add ingress
kubectl apply -f value.yaml
``
