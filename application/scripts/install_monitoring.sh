#!/bin/bash

set -e

echo "📦 Adding Helm repos..."
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo add grafana https://grafana.github.io/helm-charts
helm repo update

echo "🚀 Installing Prometheus..."
helm upgrade --install prometheus prometheus-community/kube-prometheus-stack \
  --namespace backend --create-namespace \
  -f prometheus-values.yaml

echo "🚀 Installing Grafana..."
helm upgrade --install grafana grafana/grafana \
  --namespace backend \
  -f grafana-values.yaml

echo "✅ Monitoring stack deployed!"
