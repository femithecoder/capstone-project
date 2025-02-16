resource "aws_s3_bucket" "s3_bucket" {
  bucket = var.bucket_name
  #region = "us-east-1"

  tags = {
    Name        = "capstone_s3_bucket"
    Environment = "dev"
  }
}
resource "aws_s3_bucket_server_side_encryption_configuration" "sse" {
  bucket = aws_s3_bucket.s3_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}
resource "aws_s3_bucket_versioning" "version" {
  bucket = aws_s3_bucket.s3_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}
resource "aws_s3_bucket_lifecycle_configuration" "lifecycle_rule" {
  bucket = aws_s3_bucket.s3_bucket.id

  rule {
    id = "rule-1"

    filter {}

    status = "Enabled"

    transition {
      days          = 365
      storage_class = "GLACIER"
    }
  }

}
resource "aws_dynamodb_table" "terraform_locks" {
  name         = var.dynamo_table
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}