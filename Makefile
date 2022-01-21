startup:
	minikube start --nodes 3 --driver=hyperkit --extra-disks=1 --memory=3g
	k apply -f metrics-server/components.yaml

deps:
	git clone git@github.com:rook/rook.git
	git clone git@github.com:bitnami/charts.git
	git clone git@github.com:Gradiant/bigdata-charts.git
	git clone git@github.com:istio/istio.git
	git clone git@github.com:kubernetes/client-go.git