variable "role_name" {
    description = "name for the role to be created"
    type        = string
    default     = "lambda_execution_role"
}

variable "policy_name" {
    description = "name for the policy to be created"
    type        = string
    default     = "lambda_execution_policy"
}