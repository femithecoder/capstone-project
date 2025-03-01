# # Output the IAM Role ARN
# output "iam_role_arn" {
#   description = "The ARN of the IAM role for the AWS Load Balancer Controller"
#   value       = module.iam_eks_role.iam_role_arn
# }

# # Output the IAM Role Name
# output "iam_role_name" {
#   description = "The name of the IAM role for the AWS Load Balancer Controller"
#   value       = module.iam_eks_role.iam_role_name
# }

# # Output the OIDC Provider ARN
# output "oidc_provider_arn" {
#   description = "The ARN of the OIDC provider associated with the EKS cluster"
#   value       = module.eks.oidc_provider_arn
# }

# # Output the Kubernetes Service Account Name
# output "service_account_name" {
#   description = "The name of the Kubernetes service account for AWS Load Balancer Controller"
#   value       = kubernetes_service_account.service-account.metadata[0].name
# }

# # Output the Kubernetes Service Account Namespace
# output "service_account_namespace" {
#   description = "The namespace of the Kubernetes service account for AWS Load Balancer Controller"
#   value       = kubernetes_service_account.service-account.metadata[0].namespace
# }

# # Output the Helm Release Name
# output "helm_release_name" {
#   description = "The name of the Helm release for AWS Load Balancer Controller"
#   value       = helm_release.lb.name
# }

# # Output the Helm Release Namespace
# output "helm_release_namespace" {
#   description = "The namespace where the AWS Load Balancer Controller Helm release is installed"
#   value       = helm_release.lb.namespace
# }

# # Output the AWS Region
# output "aws_region" {
#   description = "The AWS region where the EKS cluster is deployed"
#   value       = var.main_region
# }

# # Output the VPC ID
# output "vpc_id" {
#   description = "The VPC ID where the EKS cluster is deployed"
#   value       = var.vpc_id
# }

# # Output the Cluster Name
# output "cluster_name" {
#   description = "The name of the EKS cluster"
#   value       = var.cluster_name
# }
