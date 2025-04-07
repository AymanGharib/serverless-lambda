
output "source_bucket_id" {
  value = aws_s3_bucket.my_bucket[0].id
}
output "bucket_name" {
  value = aws_s3_bucket.my_bucket[*].name
}