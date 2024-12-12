# Project-2024
terraform-lambda-cron

I developed a terraform script to deploy an AWS lambda function that is triggered by a cron job every 5 minutes. The solution should ensure that both the lambda function code and the terraform state file are securely stored in separate S3 buckets.

Terraform Lambda function with S3 Backend and CloudWatch

Overview: This project utilizes Terraform to set up an AWS lambda function that runs every 5 minutes. The function's code and terraform's state file are stored securely separately in an Amazon S3 bucket.

Requirements:
Terraform

AWS CLI

AWS Cloudwatch

A zip file (lambda.zip) containing the lambda function code (lambda_function.py)

Set-up Instructions:
Configure main.tf (Resources needed for AWS)

Configure variables.tf (Define the inputs terraform will utilize)

Configure outputs.tf (Define the outputs (what is seen) after running terraform

Configure terraform.tfvars (Provide values for the variables)

Deployment:
Initialize terraform by going to terraform-lambda-cron directory and run terraform init

Run terraform plan and Run terraform apply to see what will be created 

verification: check that the lambda function is created in the AWS management console and in AWS cloudwatch there should be a rule that triggers the lambda function every 5 minutes

(Please note that the terraform state file .tfstate will be automatically created and stored in the specified S3 bucket after running the terraform commands. This file is essential for tracking the state of the infrastructure)

