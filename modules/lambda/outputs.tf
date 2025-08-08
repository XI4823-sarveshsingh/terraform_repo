output "lambda_arn" {
  value       = aws_lambda_function.lambda_function.arn
  description = "ARN of the lambda function"
}
output "lambda_invoke_arn" {
  value       = aws_lambda_function.lambda_function.invoke_arn
  description = "ARN to be used for invoking Lambda Function from API Gateway"
}