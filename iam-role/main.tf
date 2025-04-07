resource "aws_iam_role" "lambda_exec_role" {
  name = "lambda_exec_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "lambda.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy" "lambda_inline_policy" {
  name = "lambda_s3_logs_policy"
  role = aws_iam_role.lambda_exec_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = ["s3:*"],
        Resource = [
          "arn:aws:s3:::${var.bucket_name[0]}",
          "arn:aws:s3:::${var.bucket_name[0]}/*",
          "arn:aws:s3:::${var.bucket_name[1]}",
          "arn:aws:s3:::${var.bucket_name[1]}/*"
        ]
      },
      {
        Effect = "Allow",
        Action = "logs:CreateLogGroup",
        Resource = "arn:aws:logs:eu-north-1:${var.account_id}:*"
      },
      {
        Effect = "Allow",
        Action = [
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Resource = [
          "arn:aws:logs:eu-north-1:${var.account_id}:log-group:/aws/lambda/pixelator:*"
        ]
      }
    ]
  })
}