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

quickstart:
	open https://istio.io/latest/docs/setup/getting-started/