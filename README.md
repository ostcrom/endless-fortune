# endless-fortune

endless-fortune is an application to help generate a large amount of container logs in a Kubernetes environment. This tool is intended to stress test Kubernetes environments, so please use accordingly. 

Requires Azure CLI, Docker and kubectl to be installed. 

*All steps below assume you are running the commands from within endless-fortune's main directory.*

## Step 1 (Optional):
If you don't already have an AKS instance, run this script with your bare subscription ID as a parameter:

```
./aks-deploy.sh XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX
```
This will create an Azure Container Registery, an AKS cluster and link them together. 

Take note of the Azure Container Registry name, with this script it will be "acrk8s" followed by a random number.

## Step 2:
Log into your ACR and list the repository:
```
az acr login --name [ACRNAME]
az acr list | grep loginServer 
```

The login server should be similar to [ACRNAME].azurecr.io.

## Step 3:
Build the docker image, being sure to tag it with the ACR login server:
```
docker build -t [ACRNAME].azurecr.io/endless-fortune:1
```

## Step 4:
Push the docker image to your container registry:
```
docker push [ACRNAME].azurecr.io/endless-fortune:1
```

## Step 5:
Update endless-fortune-deployment.yaml.example to have the correct image name on line 17. Save your changes as just "endless-fortune-deployment.yaml".

## Step 6:
Apply the updated manifest to kubernetes:
```
kubectl apply -f ./endless-fortune-deployment.yaml
```

## Step 7(Optional):
You can mess with the deployment yaml in two obvious areas.

First is the replicas, on line 6. This is the number of instances of endless-fortune to run concurrently. (Default AKS limit is 110 pods per node, after accounting for kube-system pods, you have an effective default limit of ~100 pods per nods.)

Second is the value for the ENV\_SLEEP variable on line 20. Default is "1", the endless-fortune application will sleep 1 second between each message. Make this smaller

On paper, the general through put of container log messages should be as follows:

```
Messages/per minute = R * (1/t) * 60 
```

R is the number of replicas, and "t" is the sleep value provided in the template. So 3 replicas with a ".5" wait would be expected to produce 360 messages per minute (but may not always due to performance issues.)

https://learn.microsoft.com/en-us/azure/aks/cluster-container-registry-integration?tabs=azure-cli - Instructions for c

### TODO:
- Add endless-fortune container image to a public image repo and remove the need to build and push the container image. 
- May be able to help optimize performance by switching to an Alpine based image. 
