minikube:
	minikube start --nodes 3 --driver=hyperkit --extra-disks=1
	kubectl apply -f ../metrics-server/components.yaml

setup:
	istioctl install --set profile=demo -y
	kubectl label namespace default istio-injection=enabled

addons:
	kubectl apply -f ../istio/samples/addons

kiali:
	istioctl dashboard kiali
prome:
	istioctl dashboard prometheus
grafana:
	istioctl dashboard grafana

cleanup:
	kubectl delete -f ../istio/samples/bookinfo/platform/kube/bookinfo.yaml
	# delete istio
	istioctl manifest generate --set profile=demo | kubectl delete --ignore-not-found=true -f -
	kubectl delete namespace istio-system
	kubectl label namespace default istio-injection-
	istioctl x uninstall --purge

bookinfo:
	kubectl apply -f ../istio/samples/bookinfo/platform/kube/bookinfo.yaml
# kubectl exec "$(kubectl get pod -l app=ratings -o jsonpath='{.items[0].metadata.name}')" -c ratings -- curl -s productpage:9080/productpage

bookinfo_ingress:
	kubectl apply -f ../istio/samples/bookinfo/networking/bookinfo-gateway.yaml
# k get vs,gateway;   
# istioctl analyze

quickstart:
	open https://istio.io/latest/docs/setup/getting-started/

install_istio_cli:
	curl -sL https://istio.io/downloadIstioctl | sh -
	export PATH=$PATH:$HOME/.istioctl/bin
