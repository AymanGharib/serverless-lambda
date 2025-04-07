data "archive_file" "lambda_zip" {
  type        = "zip"
  source_dir  = "${path.module}/mylambda"
  output_path = "${path.module}/mylambda.zip"
}



resource "aws_lambda_function" "hello_lambda" {
  function_name = "pixelator"
  role          = var.role_arn
  handler       = "handler.lambda_handler"
  runtime       = "Python 3.9"
  architectures = [ "x86_64" ]
  filename      = data.archive_file.lambda_zip.output_path
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256
  environment {

    variables = {
         processed_bucket = var.bucket_name[1]
    }
  
  }
  
}



resource "aws_lambda_permission" "allow_s3" {
  statement_id  = "AllowExecutionFromS3"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.hello_lambda.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = var.role_arn
}



resource "aws_s3_bucket_notification" "s3_to_lambda" {
  bucket = var.source_bucket_id

  lambda_function {
    lambda_function_arn = aws_lambda_function.hello_lambda.arn
    events              = ["s3:ObjectCreated:*"]

  }

  depends_on = [aws_lambda_permission.allow_s3]
}
