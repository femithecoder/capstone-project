variable "lb_role" {
  default = "iam_lb_role_eks"
}
variable "main_region" {
  type = string  
  default = "us-east-1"
}
variable "vpc_id" {
  type = string
}
variable "cluster_name" {
  type = string
  default = "dev_eks"
}
variable "oidc_provider_arn" {
  type = string
}
variable "grafana_admin_password" {
  type = string
  sensitive = true

}