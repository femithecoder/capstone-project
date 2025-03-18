variable "cluster_name" {
  type = string
  default = "dev_eks"
}
variable "main_region" {
  type = string  
  default = "us-east-1"
}
# variable "oidc_provider_arn" {
#   type = string
# }
# variable "grafana_admin_password" {
#   type = string
#   sensitive = true
# }