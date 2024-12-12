output "lambda_function_arn" {
  description = "The ARN of the Lambda function"
  value       = aws_lambda_function.my_lambda.arn
}

output "cloudwatch_event_rule_arn" {
  description = "The ARN of the CloudWatch Event Rule"
  value       = aws_cloudwatch_event_rule.every_5_minutes.arn
}