module "iam" {
  source = "./iam-role"

  bucket_name = module.s3.bucket_name
  account_id = var.account_id
}

module "s3" {
  source = "./s3"
  bucket_count = 2
  bucket_name = var.bucket_names
}

module "lambda" {
  source = "./lambda"
  bucket_name = module.s3.bucket_name
  role_arn = module.iam.role_arn
  source_bucket_id = module.s3.source_bucket_id
}