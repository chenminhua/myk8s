startup:
	minikube start --nodes 3 --driver=hyperkit --extra-disks=1 --memory=3g
	k apply -f metrics-server/components.yaml

deps:
	git clone git@github.com:rook/rook.git
	git clone git@github.com:bitnami/charts.git
	git clone git@github.com:Gradiant/bigdata-charts.git
	git clone git@github.com:istio/istio.git
	git clone git@github.com:kubernetes/client-go.git

board:
	kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.2.0/aio/deploy/recommended.yaml
	kubectl apply -f ./dashboard/account.yaml
	kubectl -n kubernetes-dashboard get secret $$(kubectl -n kubernetes-dashboard get sa/admin-user -o jsonpath="{.secrets[0].name}") -o go-template="{{.data.token | base64decode}}"
	echo "http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/"
	kubectl proxy

shadowsocks:
	helm repo add predatorray http://predatorray.github.io/charts
	helm upgrade --install shadowsocks predatorray/shadowsocks --set service.type=LoadBalancer --set shadowsocks.password.plainText=1234qwer
	kubectl get svc

mysql:
	helm install sq --set volumePermissions.enabled=true --set auth.rootPassword=secretpassword,auth.database=app_database --set metrics.enabled=true bitnami/mysql

mysql-lb:
	helm install sq --set volumePermissions.enabled=true --set auth.rootPassword=secretpassword,auth.database=app_database --set metrics.enabled=true bitnami/mysql --set primary.service.type=LoadBalancer

grafana:
	helm install gf grafana/grafana 