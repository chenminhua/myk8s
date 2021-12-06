https://github.com/bitnami/charts/tree/master/bitnami/zookeeper


helm repo add bitnami https://charts.bitnami.com/bitnami
helm install zk --set volumePermissions.enabled=true bitnami/zookeeper

helm install zk --set volumePermissions.enabled=true --set replicaCount=3 bitnami/zookeeper

helm status zk
