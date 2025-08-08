variable "region" {
  type        = string
  default     = "ap-south-1"
  description = "AWS region where resources are to be created"
}
variable "common_tags" {
  type        = map(string)
  default     = {}
  description = "Common tags to be added to the resources"
}
variable "assume_role_arn" {
  type        = string
  default     = ""
  description = "The role to be assumed while creating resources"
}

################################################################################
# Lambda Function
################################################################################

variable "function_name" {
  type        = string
  description = "Name for the lambda function"
}
variable "architectures" {
  type        = list(string)
  default     = ["x86_64"]
  description = "Instruction set architecture for your Lambda function. Valid values are [\"x86_64\"] and [\"arm64\"]"
}
variable "description" {
  type        = string
  default     = ""
  description = "Description of the lambda function"
}
variable "publish" {
  type        = bool
  default     = false
  description = "Whether to publish creation/change as new Lambda Function Version"
}
variable "runtime" {
  type        = string
  default     = "python3.12"
  description = "Identifier of the function's runtime. For more details visit https://docs.aws.amazon.com/lambda/latest/api/API_CreateFunction.html#API_CreateFunction_RequestSyntax"
}

################################################################################
# Limits
################################################################################

variable "memory_size" {
  type        = number
  default     = 128
  description = "Amount of memory in MB your Lambda Function can use at runtime. For more details visit https://docs.aws.amazon.com/lambda/latest/dg/gettingstarted-limits.html"
}
variable "ephemeral_storage_size" {
  type        = number
  default     = 512
  description = "The amount of Ephemeral storage(/tmp) to allocate for the Lambda Function in MB"
}
variable "reserved_concurrent_executions" {
  type        = number
  default     = -1
  description = "Amount of reserved concurrent executions for this lambda function. A value of 0 disables lambda from being triggered and -1 removes any concurrency limitations. For more details visit https://docs.aws.amazon.com/lambda/latest/dg/lambda-concurrency.html"
}
variable "function_timeout" {
  type        = number
  default     = 3
  description = "Amount of time your Lambda Function has to run in seconds. For more details visit https://docs.aws.amazon.com/lambda/latest/dg/gettingstarted-limits.html"
}

################################################################################
# Lambda Code Configuration
################################################################################

variable "package_type" {
  type        = string
  default     = "Zip"
  description = "Lambda deployment package type. Valid values are Zip and Image"
}
variable "filename" {
  type        = string
  default     = ""
  description = "Path to the function's deployment package within the local filesystem. Exactly one of 'filename', 'image_uri', or 's3_bucket_config' must be specified"
}
variable "handler_function" {
  type        = string
  default     = "lambda_handler"
  description = "The name of the method within your code that Lambda calls to run your function"
}
variable "image_uri" {
  type        = string
  default     = ""
  description = "ECR image URI containing the function's deployment package. Exactly one of 'filename', 'image_uri', or 's3_bucket_config' must be specified"
}
variable "image_config" {
  type        = map(string)
  default     = {}
  description = "Container image configuration values that override the values in the container image Dockerfile. The fields are command: Parameters that you want to pass in with entry_point, entry_point: Entry point to your application, which is typically the location of the runtime executable, working_directory: working directory"
}
variable "s3_config" {
  type        = map(string)
  default     = {}
  description = "Configuration for s3 bucket containing the function's deployment package. The fields are s3-bucket: The name of the s3 bucket, s3-key: S3 key of an object containing the function's deployment package, s3_object_version: Object version containing the function's deployment package"
}

################################################################################
# Lambda Execution Role
################################################################################

variable "execution_role_arn" {
  type        = string
  description = "ARN of the function's execution role"
}

################################################################################
# Environment Variables
################################################################################

variable "environment_variables" {
  type        = map(string)
  default     = {}
  description = "Map of environment variables that are accessible from the function code during execution"
}
variable "kms_key_arn" {
  type        = string
  default     = ""
  description = "Key that is used to encrypt environment variables. If this configuration is not provided when environment variables are in use, AWS Lambda uses a default service key"
}

################################################################################
# Logging Configuration
################################################################################

variable "logging_config" {
  type        = map(string)
  default     = {}
  description = "Advanced logging configuration. Available keys are 'application_log_level', 'log_format' and 'system_log_level'. For more details visit https://docs.aws.amazon.com/lambda/latest/dg/monitoring-cloudwatchlogs.html#monitoring-cloudwatchlogs-advanced"
}
variable "log_retention_in_days" {
  type        = number
  default     = 7
  description = "Specifies the number of days you want to retain log events. Possible values are: 1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1096, 1827, 2192, 2557, 2922, 3288, 3653, and 0. If you select 0, the events in the log group are always retained and never expire"
}
variable "log_encryption_key_arn" {
  type        = string
  default     = ""
  description = "The ARN of the KMS Key to use when encrypting log data"
}

################################################################################
# Additional Configuration
################################################################################

variable "vpc_config" {
  type        = map(any)
  default     = {}
  description = "Configuration for network connectivity to AWS resources in a VPC. Fields are security_group_ids: List of security group IDs associated with the Lambda function, subnet_ids: List of subnet IDs associated with the Lambda function and ipv6_allowed_for_dual_stack: Allows outbound IPv6 traffic on VPC functions that are connected to dual-stack subnets"
}
variable "code_signing_config_arn" {
  type        = string
  default     = ""
  description = "To enable code signing for this function, specify the ARN of a code-signing configuration. A code-signing configuration includes a set of signing profiles, which define the trusted publishers for this function"
}
variable "dead_letter_config_target_arn" {
  type        = string
  default     = ""
  description = "ARN of an SNS topic or SQS queue to notify when an invocation fails. If this option is used, the function's IAM role must be granted suitable access to write to the target object, which means allowing either the sns:Publish or sqs:SendMessage action on this ARN, depending on which service is targeted"
}
variable "layer_arns" {
  type        = list(string)
  default     = []
  description = "List of Lambda Layer Version ARNs (maximum of 5) to attach to your Lambda Function"
}
variable "tracing_config_mode" {
  type        = string
  default     = ""
  description = "Whether to sample and trace a subset of incoming requests with AWS X-Ray. Valid values are PassThrough and Active. If PassThrough, Lambda will only trace the request from an upstream service if it contains a tracing header with 'sampled=1'. If Active, Lambda will respect any tracing header it receives from an upstream service. If no tracing header is received, Lambda will call X-Ray for a tracing decision"
}