variable "region" {
  description = "The AWS region to deploy resources"
  type        = string
  default    = "us-east-1"
}

variable "s3_bucket" {
  description = "S3 bucket to store the Lambda code and Terraform state"
  type        = string
  default    = "lambda-code-bucket"
}

variable "lambda_code_path" {
  description = "Path to the Lambda zip file"
  type        = string
  default    = "C:\Users\latas\OneDrive\Desktop\Project-2024\terraform\terraform-lambda-cron"
}

variable "lambda_function_name" {
  description = "Name of the Lambda function"
  type        = string
  default    = "LambdaFunction"
}