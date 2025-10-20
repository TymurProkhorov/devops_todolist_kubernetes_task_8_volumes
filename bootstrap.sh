#!/bin/bash

docker build -t ikulyk404/todoapp:3.0.0 .
docker push ikulyk404/todoapp:3.0.0

kubectl create namespace todoapp --dry-run=client -o yaml | kubectl apply -f -
kubectl config set-context --current --namespace=todoapp

kubectl apply -f .infrastructure/clusterIp.yml
kubectl apply -f .infrastructure/nodeport.yml
kubectl apply -f .infrastructure/hpa.yml
kubectl apply -f .infrastructure/configMap.yml
kubectl apply -f .infrastructure/pv.yml
kubectl apply -f .infrastructure/pvc.yml
kubectl apply -f .infrastructure/secret.yml
kubectl apply -f .infrastructure/deployment.yml