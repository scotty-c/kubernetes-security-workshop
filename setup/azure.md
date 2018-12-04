# Azure

## Requirements 

### Azure cli
The first thing that you will need is to have the Azure cli installed. The instructions for that can be found [here](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest)

### Kubectl
The next binary we will need to be installed is `kubectl` to install that please issue `az aks install-cli`

### Set up the cli
The first thing we will need to do to create our cluster is login to our Azure subscription. 
We do that by issuing `az login` and following the prompts.

### Creating a resource group
Then we are going to create a resource group for the cluster. If you already have one please skip this step.
If not we will create one with `az group create --name workshop --location $LOCATION`   replacing $LOCATION with the location you have access too.

## Creating the Kubernetes cluster
Now we are at the final step of creating a cluster. We will do that with 
```
az aks create --resource-group workshop \
--name workshop-cluster \
--generate-ssh-keys \
--kubernetes-version 1.11.5 \
--enable-rbac \
--node-vm-size Standard_DS3_v2

```

We will then set up our `kubectl` with `az aks get-credentials --resource-group workshop --name workshop-cluster --admin`

We can now test that we can connect to our cluster with `kubectl get nodes`

