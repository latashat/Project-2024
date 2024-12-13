variable "region" {
  description = "The AWS region to deploy resources"
  type        = string
  default    = "us-east-1"
}

variable "lambda_code_bucket" {
  description = "S3 bucket to store the Lambda code"
  type        = string
}

variable "terraform_state_bucket" {
  description = "S3 bucket to store the Terraform state file"
  type        = string
}

variable "lambda_code_path" {
  description = "Path to the Lambda code zip file"
  type        = string
}

variable "lambda_function_name" {
  description = "Name of the Lambda function"
  type        = string
}