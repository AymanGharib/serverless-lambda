resource "aws_s3_bucket" "my_bucket" {
    count = var.bucket_count
  bucket = var.bucket_name[count.index]
  

  tags = {
    Name        = "MyBucket"
    Environment = "Dev"
  }
}

resource "aws_s3_event" "name" {
  
}