# terraform-aws-xebia-lambda
Terraform Module to create lambda function

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.3 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 5.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_group.lambda_log_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_lambda_function.lambda_function](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_architectures"></a> [architectures](#input\_architectures) | Instruction set architecture for your Lambda function. Valid values are ["x86\_64"] and ["arm64"] | `list(string)` | <pre>[<br>  "x86_64"<br>]</pre> | no |
| <a name="input_assume_role_arn"></a> [assume\_role\_arn](#input\_assume\_role\_arn) | The role to be assumed while creating resources | `string` | `""` | no |
| <a name="input_code_signing_config_arn"></a> [code\_signing\_config\_arn](#input\_code\_signing\_config\_arn) | To enable code signing for this function, specify the ARN of a code-signing configuration. A code-signing configuration includes a set of signing profiles, which define the trusted publishers for this function | `string` | `""` | no |
| <a name="input_common_tags"></a> [common\_tags](#input\_common\_tags) | Common tags to be added to the resources | `map(string)` | `{}` | no |
| <a name="input_dead_letter_config_target_arn"></a> [dead\_letter\_config\_target\_arn](#input\_dead\_letter\_config\_target\_arn) | ARN of an SNS topic or SQS queue to notify when an invocation fails. If this option is used, the function's IAM role must be granted suitable access to write to the target object, which means allowing either the sns:Publish or sqs:SendMessage action on this ARN, depending on which service is targeted | `string` | `""` | no |
| <a name="input_description"></a> [description](#input\_description) | Description of the lambda function | `string` | `""` | no |
| <a name="input_environment_variables"></a> [environment\_variables](#input\_environment\_variables) | Map of environment variables that are accessible from the function code during execution | `map(string)` | `{}` | no |
| <a name="input_ephemeral_storage_size"></a> [ephemeral\_storage\_size](#input\_ephemeral\_storage\_size) | The amount of Ephemeral storage(/tmp) to allocate for the Lambda Function in MB | `number` | `512` | no |
| <a name="input_execution_role_arn"></a> [execution\_role\_arn](#input\_execution\_role\_arn) | ARN of the function's execution role | `string` | n/a | yes |
| <a name="input_filename"></a> [filename](#input\_filename) | Path to the function's deployment package within the local filesystem. Exactly one of 'filename', 'image\_uri', or 's3\_bucket\_config' must be specified | `string` | `""` | no |
| <a name="input_function_name"></a> [function\_name](#input\_function\_name) | Name for the lambda function | `string` | n/a | yes |
| <a name="input_function_timeout"></a> [function\_timeout](#input\_function\_timeout) | Amount of time your Lambda Function has to run in seconds. For more details visit https://docs.aws.amazon.com/lambda/latest/dg/gettingstarted-limits.html | `number` | `3` | no |
| <a name="input_handler_function"></a> [handler\_function](#input\_handler\_function) | The name of the method within your code that Lambda calls to run your function | `string` | `"lambda_handler"` | no |
| <a name="input_image_config"></a> [image\_config](#input\_image\_config) | Container image configuration values that override the values in the container image Dockerfile. The fields are command: Parameters that you want to pass in with entry\_point, entry\_point: Entry point to your application, which is typically the location of the runtime executable, working\_directory: working directory | `map(string)` | `{}` | no |
| <a name="input_image_uri"></a> [image\_uri](#input\_image\_uri) | ECR image URI containing the function's deployment package. Exactly one of 'filename', 'image\_uri', or 's3\_bucket\_config' must be specified | `string` | `""` | no |
| <a name="input_kms_key_arn"></a> [kms\_key\_arn](#input\_kms\_key\_arn) | Key that is used to encrypt environment variables. If this configuration is not provided when environment variables are in use, AWS Lambda uses a default service key | `string` | `""` | no |
| <a name="input_layer_arns"></a> [layer\_arns](#input\_layer\_arns) | List of Lambda Layer Version ARNs (maximum of 5) to attach to your Lambda Function | `list(string)` | `[]` | no |
| <a name="input_log_encryption_key_arn"></a> [log\_encryption\_key\_arn](#input\_log\_encryption\_key\_arn) | The ARN of the KMS Key to use when encrypting log data | `string` | `""` | no |
| <a name="input_log_retention_in_days"></a> [log\_retention\_in\_days](#input\_log\_retention\_in\_days) | Specifies the number of days you want to retain log events. Possible values are: 1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1096, 1827, 2192, 2557, 2922, 3288, 3653, and 0. If you select 0, the events in the log group are always retained and never expire | `number` | `7` | no |
| <a name="input_logging_config"></a> [logging\_config](#input\_logging\_config) | Advanced logging configuration. Available keys are 'application\_log\_level', 'log\_format' and 'system\_log\_level'. For more details visit https://docs.aws.amazon.com/lambda/latest/dg/monitoring-cloudwatchlogs.html#monitoring-cloudwatchlogs-advanced | `map(string)` | `{}` | no |
| <a name="input_memory_size"></a> [memory\_size](#input\_memory\_size) | Amount of memory in MB your Lambda Function can use at runtime. For more details visit https://docs.aws.amazon.com/lambda/latest/dg/gettingstarted-limits.html | `number` | `128` | no |
| <a name="input_package_type"></a> [package\_type](#input\_package\_type) | Lambda deployment package type. Valid values are Zip and Image | `string` | `"Zip"` | no |
| <a name="input_publish"></a> [publish](#input\_publish) | Whether to publish creation/change as new Lambda Function Version | `bool` | `false` | no |
| <a name="input_region"></a> [region](#input\_region) | AWS region where resources are to be created | `string` | `"ap-south-1"` | no |
| <a name="input_reserved_concurrent_executions"></a> [reserved\_concurrent\_executions](#input\_reserved\_concurrent\_executions) | Amount of reserved concurrent executions for this lambda function. A value of 0 disables lambda from being triggered and -1 removes any concurrency limitations. For more details visit https://docs.aws.amazon.com/lambda/latest/dg/lambda-concurrency.html | `number` | `-1` | no |
| <a name="input_runtime"></a> [runtime](#input\_runtime) | Identifier of the function's runtime. For more details visit https://docs.aws.amazon.com/lambda/latest/api/API_CreateFunction.html#API_CreateFunction_RequestSyntax | `string` | `"python3.12"` | no |
| <a name="input_s3_config"></a> [s3\_config](#input\_s3\_config) | Configuration for s3 bucket containing the function's deployment package. The fields are s3-bucket: The name of the s3 bucket, s3-key: S3 key of an object containing the function's deployment package, s3\_object\_version: Object version containing the function's deployment package | `map(string)` | `{}` | no |
| <a name="input_tracing_config_mode"></a> [tracing\_config\_mode](#input\_tracing\_config\_mode) | Whether to sample and trace a subset of incoming requests with AWS X-Ray. Valid values are PassThrough and Active. If PassThrough, Lambda will only trace the request from an upstream service if it contains a tracing header with 'sampled=1'. If Active, Lambda will respect any tracing header it receives from an upstream service. If no tracing header is received, Lambda will call X-Ray for a tracing decision | `string` | `""` | no |
| <a name="input_vpc_config"></a> [vpc\_config](#input\_vpc\_config) | Configuration for network connectivity to AWS resources in a VPC. Fields are security\_group\_ids: List of security group IDs associated with the Lambda function, subnet\_ids: List of subnet IDs associated with the Lambda function and ipv6\_allowed\_for\_dual\_stack: Allows outbound IPv6 traffic on VPC functions that are connected to dual-stack subnets | `map(any)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_lambda_arn"></a> [lambda\_arn](#output\_lambda\_arn) | ARN of the lambda function |
| <a name="output_lambda_invoke_arn"></a> [lambda\_invoke\_arn](#output\_lambda\_invoke\_arn) | ARN to be used for invoking Lambda Function from API Gateway |
<!-- END_TF_DOCS -->