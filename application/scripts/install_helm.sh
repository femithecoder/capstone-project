#!/bin/bash

set -e

if command -v helm &> /dev/null; then
    echo "✅ Helm is already installed: $(helm version --short)"
else
    echo "📦 Helm not found. Installing Helm..."
    curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
    echo "✅ Helm installed successfully: $(helm version --short)"
fi