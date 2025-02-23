variable "vpc_id" {
  description = "VPC ID which EKS cluster is deployed in"
  type        = string
}

variable "private_subnets" {
  description = "List of private subnet IDs for the EKS cluster"
  type        = list(string)
}
variable "instance_types" {
  type = list(string)
  default = ["t2.medium"]
}
variable "main_region" {
  type = string
  default = "us-east-1"
}
variable "cluster_name" {
}
variable "role_arn" {
  default = "arn:aws:iam::548570664128:role/ec2-connect" 
}


# variable "public_subnets" {
#   type = string
# }