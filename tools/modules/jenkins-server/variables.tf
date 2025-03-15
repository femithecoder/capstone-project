variable "ami" {
  description = "ubuntu amazon machine image "
}

variable "instance_type" {
  description = "Size of instance"
}

variable "key_name" {
  description = "name of the key-pair"
}
variable "main-region" {}
variable "subnet_id" {}
variable "vpc_id" {}