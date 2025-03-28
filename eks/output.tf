# output "cluster_id" {
#   description = "EKS Cluster ID"
#   value       = module.eks.cluster_id
# }

# output "cluster_arn" {
#   description = "EKS Cluster ARN"
#   value       = module.eks.cluster_arn
# }

# output "cluster_endpoint" {
#   description = "EKS Cluster API endpoint"
#   value       = module.eks.cluster_endpoint
# }

# output "cluster_certificate_authority_data" {
#   description = "EKS Cluster Certificate Authority Data"
#   value       = module.eks.cluster_certificate_authority[0].data
#   sensitive   = true
# }

# output "cluster_security_group_id" {
#   description = "Security Group attached to EKS Cluster"
#   value       = module.eks.cluster_security_group_id
# }

# output "eks_oidc_issuer" {
#   description = "OIDC Issuer for EKS Cluster (for IAM Roles for Service Accounts)"
#   value       = module.eks.oidc_provider
# }

# output "eks_managed_node_group_role_arn" {
#   description = "IAM Role ARN for EKS Managed Node Group"
#   value       = module.eks.eks_managed_node_group_defaults.iam_role_additional_policies
# }

# output "vpc_id" {
#   description = "VPC ID where the EKS cluster is deployed"
#   value       = module.eks.vpc_id
# }

# output "private_subnets" {
#   description = "List of private subnets associated with the EKS cluster"
#   value       = module.eks.private_subnets
# }

# output "eks_managed_node_group_instance_types" {
#   description = "Instance types used by EKS Managed Node Groups"
#   value       = module.eks.eks_managed_node_group_defaults.instance_types
# }
