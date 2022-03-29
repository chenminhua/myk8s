brew install kind

kind create cluster
kind create cluster --name kind-2

kind get clusters

kind delete cluster

### load image into your cluster
kind load docker-image my-custom-image-0 my-custom-image-1

