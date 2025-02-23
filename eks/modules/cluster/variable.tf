variable "vpc_id" {}

variable "private_subnets" {
  description = "List of private subnet IDs for the EKS cluster"
  type        = list(string)
}
variable "instance_types" {
  type = list(string)
  default = ["t2.medium"]
}


# variable "public_subnets" {
#   type = string
# }