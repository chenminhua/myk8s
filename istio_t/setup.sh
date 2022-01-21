minikube start --nodes 3 --driver=hyperkit --extra-disks=1

k apply -f ../metrics-server/components.yaml

istioctl install --set profile=demo -y

k label namespace default istio-injection=enabled
