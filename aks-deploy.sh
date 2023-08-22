#!/bin/bash
SUBID=$1
echo "Using SUBID: $SUBID"
az login --use-device-code
az account set --subscription $1
RANDOMSUFFIX=$RANDOM
NAME="k8s$RANDOMSUFFIX"
RGNAME="k8slab$RANDOMSUFFIX"
az group create -l southcentralus -n $RGNAME --tags akslab=true
az acr create -n "acr$NAME" -g $RGNAME --sku basic 
az aks create -n "aks$NAME" -g $RGNAME --generate-ssh-keys --attach-acr "acr$NAME" --node-count 1 --tags akslab=true
az aks get-credentials --resource-group $RGNAME --name "aks$NAME"
