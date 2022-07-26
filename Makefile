UNAME_S := $(shell uname -s)
startup:
ifeq ($(UNAME_S),Darwin)
	minikube start --nodes 3 --driver=hyperkit --extra-disks=1 --memory=3g
endif
ifeq ($(UNAME_S),Linux)
	minikube start --nodes 3 --driver=virtualbox --memory=3g
endif
	k apply -f metrics-server/components.yaml
	

deps:
	git clone git@github.com:rook/rook.git
	git clone git@github.com:bitnami/charts.git
	git clone git@github.com:Gradiant/bigdata-charts.git
	git clone git@github.com:istio/istio.git
	git clone git@github.com:kubernetes/client-go.git

############### dashboard, metrics, prometheus ###############
board:
	kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.2.0/aio/deploy/recommended.yaml
	kubectl apply -f ./dashboard/account.yaml
	kubectl -n kubernetes-dashboard get secret $$(kubectl -n kubernetes-dashboard get sa/admin-user -o jsonpath="{.secrets[0].name}") -o go-template="{{.data.token | base64decode}}"
	echo "http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/"
	kubectl proxy

grafana:
	helm install gf grafana/grafana 

############### service #####################
consul:
	helm install consul --set volumePermissions.enabled=true bitnami/consul

nginx:
	helm install ng bitnami/nginx

shadowsocks:
	helm repo add predatorray http://predatorray.github.io/charts
	helm upgrade --install shadowsocks predatorray/shadowsocks --set service.type=LoadBalancer --set shadowsocks.password.plainText=1234qwer
	kubectl get svc

############### compute #################
pyspark:
	kubectl apply -f ./pyspark/pyspark.yaml

conda:
	kubectl apply -f ./conda/condapod.yaml

########## storeage, mq ###############
# 这个charts是production ready的，对本地k8s集群不友好，参考 https://github.com/elastic/helm-charts/tree/main/elasticsearch/examples/minikube,
# 参考 https://github.com/elastic/helm-charts/issues/644
# k port-forward svc/elasticsearch-master 9201:9200
# curl localhost:9201
elasticsearch:
	helm install es elastic/elasticsearch -f ./efk/values.yaml

etcd:
	helm install etcd --set volumePermissions.enabled=true --set replicaCount=3 bitnami/etcd

hbase:
	helm install my-hbase gradiant/hbase --version 0.1.6 --set zookeeper.volumePermissions.enabled=true

hive:
	helm install my-hive gradiant/hive --version 0.1.6 --set metastore.postgresql.volumePermissions.enabled=true

kafka:
	helm install my-kafka bitnami/kafka --set volumePermissions.enabled=true --set zookeeper.volumePermissions.enabled=true

mongo:
	helm install mg bitnami/mongodb --set volumePermissions.enabled=true

mysql:
	helm install sq --set volumePermissions.enabled=true --set auth.rootPassword=secretpassword,auth.database=app_database --set metrics.enabled=true bitnami/mysql

mysql-lb:
	helm install sq --set volumePermissions.enabled=true --set auth.rootPassword=secretpassword,auth.database=app_database --set metrics.enabled=true bitnami/mysql --set primary.service.type=LoadBalancer

pg:
	helm install pg bitnami/postgresql --set volumePermissions.enabled=true

redis:
	helm install redis bitnami/redis --set volumePermissions.enabled=true

redis-cluster:
	helm install rc bitnami/redis-cluster --set volumePermissions.enabled=true

zookeeper:
	helm install zk --set volumePermissions.enabled=true --set replicaCount=3 bitnami/zookeeper
