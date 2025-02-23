variable "cluster_name" {
  type = string
  default = "capstone-project"
}

# variable "cluster_ca_certificate" {
#   type = string

# }
# variable "cluster_endpoint" {
#   type = string
# }
variable "main-region" {
  type = string
  default = "us-east-1"
}
variable "env_name" {
  type = string
  default = "test"
}