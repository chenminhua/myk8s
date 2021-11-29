## 1.下载 helm 包到本地
helm fetch incubator/mysqlha --untar --untardir ./

## 2.调整values.yaml
主要是改mysqlRootPassword, mysqlReplicationPassword

## 3.部署mysql ha
helm install mysql-ha -f values.yaml incubator/mysqlha
helm status mysql-ha

## 4.整个mysql-client来调试
kubectl run -it --rm --image=mysql:5.7 --restart=Never mysql-client -- sh
