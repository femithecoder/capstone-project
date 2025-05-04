variable "bucket_name" {
  type    = string
  default = "capstone-s3-bucket-01"
}
variable "dynamo_table" {
  type    = string
  default = "table"
}
variable "main-region" {
  type = string
  default = "us-east-1" 
}
