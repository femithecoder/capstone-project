terraform {
  required_version = ">=0.12.0" 

  backend "s3" {
    bucket = "capstone-s3-bucket-femi"
    key = "value"
    region = "us-east-1"
  }
}