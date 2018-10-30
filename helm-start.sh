#!/bin/bash

echo "Get set up prometheus-grafana"

# install tiller with --wait and try to use helm right after
helm init
helm list
#kubectl create serviceaccount tiller --namespace kube-system
#kubectl apply -f helm-tiller-clusterrolebinding.yml
helm init --service-account tiller
helm init --service-account tiller --upgrade
helm repo add coreos https://s3-eu-west-1.amazonaws.com/coreos-charts/stable/
helm install coreos/prometheus-operator --name prometheus-operator --namespace monitoring --set rbacEnable=false
helm install coreos/kube-prometheus --name kube-prometheus --set global.rbacEnable=false --namespace monitoring
kubectl get pods -n monitoring
kubectl port-forward -n monitoring prometheus-kube-prometheus-0 9090
kubectl port-forward $(kubectl get  pods --selector=app=kube-prometheus-grafana -n  monitoring --output=jsonpath="{.items..metadata.name}") -n monitoring 3003
kubectl port-forward -n monitoring alertmanager-kube-prometheus-0 9093