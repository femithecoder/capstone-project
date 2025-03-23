#!/bin/bash

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Update package index
echo "Updating package index..."
sudo apt-get update

# Install curl if not installed
if ! command_exists curl; then
    echo "Installing curl..."
    sudo apt-get install -y curl
fi

# Install Helm if not installed
if ! command_exists helm; then
    echo "Installing Helm..."
    curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
else
    echo "Helm is already installed."
fi

# Verify Helm installation
if command_exists helm; then
    echo "Helm installed successfully!"
    helm version
else
    echo "❌ Helm installation failed. Exiting."
    exit 1
fi

# Check if kubectl is installed
if ! command_exists kubectl; then
    echo "❌ kubectl not found! Please install kubectl before running this script."
    exit 1
fi

# Define namespace
NAMESPACE="monitoring"

# Check if namespace exists before creating
if kubectl get namespace "$NAMESPACE" >/dev/null 2>&1; then
    echo "Namespace '$NAMESPACE' already exists."
else
    echo "Creating namespace '$NAMESPACE'..."
    kubectl create namespace "$NAMESPACE"
fi

# Add Helm repositories only if they don't exist
if ! helm repo list | grep -q "prometheus-community"; then
    echo "Adding Prometheus Helm repository..."
    helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
else
    echo "Prometheus Helm repository already added."
fi

if ! helm repo list | grep -q "grafana"; then
    echo "Adding Grafana Helm repository..."
    helm repo add grafana https://grafana.github.io/helm-charts
else
    echo "Grafana Helm repository already added."
fi

# Update Helm repositories
echo "Updating Helm repositories..."
helm repo update

echo "🎉Helm installation and configuration completed successfully!"
