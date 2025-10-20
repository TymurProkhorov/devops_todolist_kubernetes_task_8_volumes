#!/bin/bash

set -euo pipefail

docker build -t ikulyk404/todoapp:3.0.0 .
docker push ikulyk404/todoapp:3.0.0

kubectl create namespace todoapp --dry-run=client -o yaml | kubectl apply -f -

kubectl apply -f .infrastructure/clusterIp.yml -n todoapp
kubectl apply -f .infrastructure/nodeport.yml -n todoapp
kubectl apply -f .infrastructure/hpa.yml -n todoapp
kubectl apply -f .infrastructure/configMap.yml -n todoapp
kubectl apply -f pv.yml -n todoapp
kubectl apply -f .infrastructure/pvc.yml -n todoapp
kubectl apply -f .infrastructure/secret.yml -n todoapp
kubectl apply -f .infrastructure/deployment.yml -n todoapp