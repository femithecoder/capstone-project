variable "ami" {}
variable "key_name" {}
variable "instance_type" {}
variable "root_volume_size" {
    description = "the size of the root volume"
    type = number
    default = 16
}
variable "volume_type" {
    description = "the type of the root volume"
    type = string
    default = "gp3"
}
variable "main-region" {}
variable "subnet_id" {}
variable "vpc_id" {}