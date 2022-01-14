minikube start --nodes 3 --driver=hyperkit --extra-disks=1 --memory=3g

k apply -f metrics-server/components.yaml
