# terraform {
#   required_version = ">=0.12.0" 

#   backend "s3" {
#     bucket = "capstone-s3-bucket-femi"
#     key = "capstone/terraform.state"
#     region = "us-east-1"
#     dynamodb_table = "terraform-state-locking"
#     encrypt = false
#   }
# }