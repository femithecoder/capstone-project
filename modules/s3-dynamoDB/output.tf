output "bucket_name" {
  value = aws_s3_bucket.s3_bucket.id
}
output "dynamo_table" {
  value = aws_dynamodb_table.terraform_locks.id
}