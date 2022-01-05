https://logz.io/blog/deploying-the-elk-stack-on-kubernetes-with-helm/
https://kamrul.dev/deploy-efk-stack-with-helm-3-in-kubernetes/

```sh
# add elastic's helm repo
helm repo add elastic https://Helm.elastic.co

# download helm config for installing multi-node es
curl -O https://raw.githubusercontent.com/elastic/Helm-charts/master/elasticsearch/examples/minikube/values.yaml

# install elk
helm install elasticsearch elastic/elasticsearch -f ./values.yaml

1. Watch all cluster members come up.
  $ kubectl get pods --namespace=default -l app=elasticsearch-master -w
2. Test cluster health using Helm test.
  $ helm test elasticsearch --cleanup

# port forwarding
kubectl port-forward svc/elasticsearch-master 9200
```

## deploy kibana

```
helm install kibana elastic/kibana

kubectl port-forward deployment/kibana-kibana 5601 
```
