terraform {
  required_version = ">=0.12.0" 

  backend "s3" {
    bucket = "capstone_s3_bucket"
    key = "value"
    region = "us-east-1"
  }
}