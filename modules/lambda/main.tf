# provider "aws" {
#   region = var.region
#   default_tags {
#     tags = var.common_tags
#   }
#   assume_role {
#     role_arn = var.assume_role_arn
#   }
# }

################################################################################
# Lambda Function
################################################################################

resource "aws_cloudwatch_log_group" "lambda_log_group" {
  name              = "/aws/lambda/${var.function_name}"
  retention_in_days = var.log_retention_in_days
  kms_key_id        = var.log_encryption_key_arn
}

resource "aws_lambda_function" "lambda_function" {
  function_name                  = var.function_name
  role                           = var.execution_role_arn
  architectures                  = var.architectures
  description                    = var.description
  runtime                        = var.runtime
  code_signing_config_arn        = var.code_signing_config_arn
  filename                       = var.filename != "" ? var.filename : null
  handler                        = var.filename != "" ? var.handler_function : null
  image_uri                      = var.image_uri != "" ? var.image_uri : null
  kms_key_arn                    = var.environment_variables != {} ? var.kms_key_arn : null
  layers                         = var.layer_arns
  memory_size                    = var.memory_size
  package_type                   = var.package_type
  publish                        = var.publish
  reserved_concurrent_executions = var.reserved_concurrent_executions
  s3_bucket                      = length(var.s3_config) != 0 ? var.s3_config.s3_bucket : null
  s3_key                         = length(var.s3_config) != 0 ? var.s3_config.s3_key : null
  s3_object_version              = length(var.s3_config) != 0 ? var.s3_config.s3_object_version : null
  timeout                        = var.function_timeout
  ephemeral_storage {
    size = var.ephemeral_storage_size
  }
  dynamic "image_config" {
    for_each = length(var.image_config) != 0 ? [1] : []
    content {
      command           = try(var.image_config.command, null)
      entry_point       = try(var.image_config.entry_point, null)
      working_directory = try(var.image_config.working_directory, null)
    }
  }
  dynamic "dead_letter_config" {
    for_each = var.dead_letter_config_target_arn != "" ? [1] : []
    content {
      target_arn = var.dead_letter_config_target_arn
    }
  }
  dynamic "environment" {
    for_each = length(var.environment_variables) != 0 ? [1] : []
    content {
      variables = var.environment_variables
    }
  }
  dynamic "logging_config" {
    for_each = length(var.logging_config) != 0 ? [1] : []
    content {
      application_log_level = try(var.logging_config.application_log_level, null)
      log_format            = var.logging_config.log_format
      log_group             = aws_cloudwatch_log_group.lambda_log_group.arn
      system_log_level      = try(var.logging_config.system_log_level, null)
    }
  }
  dynamic "tracing_config" {
    for_each = var.tracing_config_mode != "" ? [1] : []
    content {
      mode = var.tracing_config_mode
    }
  }
  dynamic "vpc_config" {
    for_each = length(var.vpc_config) != 0 ? [1] : []
    content {
      security_group_ids          = var.vpc_config.security_group_ids
      subnet_ids                  = var.vpc_config.subnet_ids
      ipv6_allowed_for_dual_stack = try(var.vpc_config.ipv6_allowed_for_dual_stack, false)
    }
  }
}