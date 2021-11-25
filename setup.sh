# variables
region=eastasia
groupname=closet
aksname=clk8s
nodecount=1
node_vm_size=Standard_D2s_v3
acrname=clarc
acrsku=Basic

# clean
az group delete -n $groupname -y

# create azure resource group
az group create -n $groupname --location $region

# create 1 node k8s
az aks create -g $groupname -n $aksname --node-count $nodecount --node-vm-size $node_vm_size --generate-ssh-keys

# install kubectl
az aks install-cli

# get-credentials
az aks get-credentials -g $groupname -n $aksname


# create azure container registry
az acr create -g $groupname -n $acrname --sku $acrsku
az acr login -n $acrname
# enable admin login
az acr update -n $acrname --admin-enable true
# docker login clarc.azurecr.io

# integrate aks and acr
az aks update -n $aksname -g $groupname --attach-acr $acrname
