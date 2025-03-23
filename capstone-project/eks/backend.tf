terraform {
  required_version = ">=0.12.0" 

  backend "s3" {
    bucket = "capstone-s3-bucket-jide"
    key = "capstone/terraform.state_1"
    region = "us-east-1"
    dynamodb_table = "table"
    encrypt = false
    use_lockfile = true
  }
}