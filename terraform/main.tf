# Specify the required Terraform provider and version
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }
  required_version = ">= 1.2.0"

# Backend configuration for storing Terraform state in an S3 bucket
  backend "s3" {
    bucket = var.terraform_state_bucket
    key    = "terraform/state"
    region = var.region
    encrypt = true
# dynamodb_table = "terraform-lock-table"  # Add DynamoDB for state locking
  }
}

# AWS Provider Configuration
provider "aws" {
  region = var.region
}

# S3 Bucket for storing Lambda code
resource "aws_s3_bucket" "lambda_code_bucket" {
  bucket = var.lambda_code_bucket
  acl    = "private"

# Utilizing Server-side encryption configuration for S3 bucket
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

# S3 Object for Lambda code (consider versioning the key)
resource "aws_s3_bucket_object" "lambda_code" {
  bucket = aws_s3_bucket.lambda_code_bucket.bucket
  key    = "lambda_${timestamp()}.zip"  # Version the Lambda code file
  source = var.lambda_code_path
}

# IAM Role for Lambda execution
resource "aws_iam_role" "lambda_exec_role" {
  name = "lambda_exec_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Principal = {
          Service = "lambda.amazonaws.com",
        },
        Effect = "Allow",
        Sid    = "",
      },
    ],
  })
}

# Attach basic Lambda execution policy to the IAM role
resource "aws_iam_role_policy_attachment" "lambda_policy" {
  role      = aws_iam_role.lambda_exec_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# Lambda Function Definition
resource "aws_lambda_function" "my_lambda" {
  filename        = var.lambda_code_path
  function_name  = var.lambda_function_name
  role            = aws_iam_role.lambda_exec_role.arn
  handler        = "lambda_function.lambda_handler"
  source_code_hash = filebase64sha256(var.lambda_code_path)
  runtime        = "python3.11" # Adjust runtime version; update as needed for compatibility (python3.8-python3.11)
#  memory_size    = 128  # Adjust as needed
#  timeout        = 30    # Adjust based on Lambda function needs

# Optionally add environment variables if needed
# environment {
#    variables = {
#      "MY_ENV_VAR" = "some_value"
    }
  }
}

# CloudWatch Event Rule for triggering Lambda every 5 minutes
resource "aws_cloudwatch_event_rule" "every_5_minutes" {
  name                = "Every5Minutes"
  schedule_expression = "cron(0/5 * * * ? *)"
}

# CloudWatch Event Target to trigger Lambda function
resource "aws_cloudwatch_event_target" "trigger_lambda" {
  rule      = aws_cloudwatch_event_rule.every_5_minutes.name
  target_id = "lambda_target"
  arn      = aws_lambda_function.my_lambda.arn
}

# Grant CloudWatch permission to invoke Lambda function
resource "aws_lambda_permission" "allow_cloudwatch" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.my_lambda.function_name
  principal    = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.every_5_minutes.arn
}
