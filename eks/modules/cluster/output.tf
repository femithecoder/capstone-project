output "cluster_ca_certificate" {
  value = module.eks.cluster_certificate_authority_data
}
output "cluster_arn" {
  value = module.eks.cluster_arn
}
output "cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

output "oidc_provider_arn" {
  value = module.eks.oidc_provider_arn
}

output "oidc_provider" {
  value = module.eks.oidc_providers
}