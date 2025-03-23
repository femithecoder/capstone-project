#!/bin/bash
response="$(aws eks list-clusters --region us-west-1 --output text | grep -i dev_eks 2>&1)" 
if [[ $? -eq 0 ]]; then
    echo "Success: EKS cluster exist"
    aws eks --region us-west-1 update-kubeconfig --name dev_eks && export KUBE_CONFIG_PATH=~/.kube/config

else
    echo "Error: EKS cluster does not exist"
fi