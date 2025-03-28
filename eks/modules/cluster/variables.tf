variable "vpc_id" {
  type = string
}
variable "cluster_name" {
  type = string
  default = "dev_eks"
}
variable "private_subnets" {
  description = "VPC Private Subnets which EKS cluster is deployed in"
  type        = list(any)
}
# variable "grafana_admin_password" {
#   type = string
#   sensitive = true
# }