https://cert-manager.io/docs/installation/helm/

1. helm repo add jetstack https://charts.jetstack.io
2. helm repo update
3. helm install cert-manager jetstack/cert-manager --namespace cert-manager --create-namespace --version v1.6.1 --set installCRDs=true

按照完成 cert-manager, cert-manager-cainjector, cert-manager-webhook
