################################################################################
# IAM Role
################################################################################

output "iam_role_arn" {
  description = "ARN of IAM role"
  value       = aws_iam_role.lambda_execution_role.arn
}
output "iam_role_name" {
  description = "Name of IAM role"
  value       = aws_iam_role.lambda_execution_role.name
}

################################################################################
# IAM Policy
################################################################################

output "iam_policy_arn" {
  description = "The ARN assigned by AWS to this policy."
  value       = aws_iam_policy.lambda_execution_policy.arn
}
output "iam_policy_name" {
  description = "The name of the policy."
  value       = aws_iam_policy.lambda_execution_policy.name
}