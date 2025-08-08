variable "vpc_id" {
    description = "ID of the vpc in which deployment is to be done."
    type        = string
    default     = null
}

variable "app_subnet_ids"{
  description = "ID of the subnet in which deployment is to be done."
  type        = list(string)
}

variable "eks_subnet_ids"{
  description = "ID of the subnet in which eks deployment is to be done."
  type        = list(string)
}

variable "database_subnet_ids"{
  description = "ID of the subnet in which DB deployment is to be done."
  type        = list(string)
}

variable "private_route_table_id"{
  description = "ID of the private route table in which deployment is to be done."
  type        = string
}

variable "region"{
  description = "Region in which deployment is to be done."
  type        = string
}

variable "buckets" {
  description = "Map of S3 bucket configurations"
  type = map(object({
    region                         = string
    assume_role_arn                = string
    common_tags                    = map(string)
    enable_acceleration_status     = bool
    name                           = string
    enable_object_lock             = bool
    enable_force_destroy           = bool
    enable_replication             = bool
    enable_logging                 = bool
    object_ownership               = string
    block_public_acls              = bool
    block_public_policy            = bool
    ignore_public_acls             = bool
    restrict_public_buckets        = bool
    acl                            = string
    enable_cors_config             = bool
    cors_rules                     = list(any)
    enable_intelligent_tiering     = bool
    intelligent_tiering            = map(any)
    enable_lifecycle_configuration = bool
    lifecycle_rule                 = list(any)
    enable_versioning              = bool
    metric_configuration           = list(object({
      name   = string
      filter = optional(object({
        prefix = optional(string)
        tags   = optional(map(string))
      }))
    }))
    object_lock_configuration      = map(any)
    attach_deny_insecure_transport_policy = bool
    attach_policy                        = bool
    policy_path                          = string
    policy_vars                          = map(any)
    website                              = map(any)
    kms_key_id                           = string
  }))
  default = {}
}

variable "ecr_repositories" {
  type = map(object({
    name                            = string
    type                            = optional(string, "private")
    image_tag_mutability            = optional(string, "IMMUTABLE")
    enable_ecr_force_delete         = optional(bool, false)
    encryption_type                 = optional(string, "KMS")
    enable_image_scan_on_push       = optional(bool, false)
    lifecycle_policy_path           = optional(string, "")
    permissions_policy_path         = optional(string, "")
    registry_policy_path            = optional(string, "")
    pull_through_cache_rules        = optional(list(any), [])
    manage_registry_scanning_config = optional(bool, false)
    registry_scan_type              = optional(string, "BASIC")
    registry_scan_rules             = optional(list(any),[])
    create_registry_replication_configuration = optional(bool, false)
  }))
}

# variable "lambda_functions" {
#   type = map(object({
#     function_name          = string
#     runtime                = string
#     package_type           = optional(string, "zip")
#     filename               = string
#     kms_key_arn            = optional(string, "")
#     log_retention_in_days  = optional(number, 30)
#     log_encryption_key_arn = optional(string, "")
#     vpc_config             = optional(map(any), {})
#   }))
# }
variable "role_name" {
  description = "Name of the role to be created"
  type        = string
}
variable "policy_name" {
  description = "Name of the policy to be created"
  type        = string
}


variable "rds_databases" {
  description = "Map of RDS database configurations for for_each in module.rds_database"
  type        = map(object({
  name        = string
  identifier  = string

  # Engine & versions
  engine               = optional(string, "postgres")
  engine_version       = optional(string, "16.4")
  major_engine_version = optional(string, "16")
  family               = optional(string, "postgres16")
  parameter_group_name = optional(string, "default.postgres16")

  # Sizing & storage
  instance_class     = optional(string, "db.t3.small")
  storage_type       = optional(string, "gp2")
  allocated_storage  = optional(number, 32)
  iops               = optional(number, 0)
  database_port      = optional(number, 5432)
  storage_encrypted  = optional(bool, false)
  deletion_protection = optional(bool, false)

  # Database
  database_name = optional(string, "postgres")
  username      = optional(string, "postgres")
  password      = optional(string, "postgres")

  # Backups & maintenance
  backup_retention_period    = optional(number, 30)
  backup_window              = optional(string, "04:00-04:30")
  maintenance_window         = optional(string, "sun:04:30-sun:05:30")
  auto_minor_version_upgrade = optional(bool, true)
  final_snapshot_identifier  = optional(string, null)
  skip_final_snapshot        = optional(bool, true)
  copy_tags_to_snapshot      = optional(bool, false)
  multi_availability_zone    = optional(bool, false)
  cloudwatch_logs_exports    = optional(list(string), [])

  # Security group rules managed by submodule
  ingress_with_cidr_blocks = list(object({
    cidr_blocks = list(string)
    description = string
  }))
  egress_with_cidr_blocks  = list(object({
    cidr_blocks = list(string)
    description = string
  }))

  # Misc
  kms_key_id          = optional(string, "")
  monitoring_interval = optional(number, 0)
  rds_sg_name         = optional(string, "iexceed_rds_sg")
  db_subnet_group_name       = optional(string, "Test")
  db_subnet_group_identifier = optional(string, "")
  name_prefix                = optional(string, "")
  create_db_instance         = optional(bool, true)
  create_random_password     = optional(bool, true)
  create_db_option_group     = optional(bool, true)
  create_db_parameter_group  = optional(bool, true)
  create_db_subnet_group     = optional(bool, true)

  # Tags
  tags       = optional(map(string), {})
  extra_tags = optional(map(string), {})
  sg_tags    = optional(map(string), {})
  }))
}



variable "lambda_functions" {
  description = "Map of lambda function configurations"
  type = map(object({
    function_name          = string
    runtime                = string
    package_type           = optional(string, "zip")
    handler_function       = optional(string, "lambda_handler")
    memory_size            = number
    function_timeout       = number
    environment_variables  = optional(map(string), {})
    kms_key_arn            = optional(string, "")
    log_retention_in_days  = optional(number, 30)
    log_encryption_key_arn = optional(string, "")
    vpc_config             = optional(bool, false)
    #layer_arns             = optional(list(string), [])
    common_tags            = optional(map(string), {})
    description            = optional(string, "")
    publish                = optional(bool, false)
    architectures          = optional(list(string), ["x86_64"])
    ephemeral_storage_size = optional(number, 512)
    reserved_concurrent_executions = optional(number, -1)
    code_signing_config_arn = optional(string, "")
    dead_letter_config_target_arn = optional(string, "")
    tracing_config_mode    = optional(string, "")
    image_uri              = optional(string, "")
    image_config           = optional(map(string), {})
    s3_config              = optional(map(string), {})
    logging_config         = optional(map(string), {})
  }))
}

# variable "ec2_instances" {
#     description = "Map of ec2 instance configurations"
#     type        = map(object({
#     region                         = string
#     ingress_rules = list(object({
#       ip_protocol                  = string
#       from_port                    = number
#       to_port                      = number
#       description                  = string
#       cidr_ipv4                    = string
#       cidr_ipv6                    = optional(string)
#       prefix_list_id               = optional(string)
#       referenced_security_group_id = optional(string)
#     }))
#     egress_rules = list(object({
#       ip_protocol                  = string
#       from_port                    = optional(number)
#       to_port                      = optional(number)
#       description                  = string
#       cidr_ipv4                    = string
#       cidr_ipv6                    = optional(string)
#       prefix_list_id               = optional(string)
#       referenced_security_group_id = optional(string)
#     }))
#     common_tags                               = optional(map(string))
#     create                                    = bool
#     name                                      = string
#     ami_ssm_parameter                         = optional(string)
#     ami                                       = optional(string)
#     ignore_ami_changes                        = optional(bool)
#     associate_public_ip_address               = bool
#     maintenance_options                       = optional(any)
#     availability_zone                         = string
#     capacity_reservation_specification        = optional(any)
#     cpu_credits                               = optional(string)
#     disable_api_termination                   = optional(bool)
#     ebs_block_device                          = optional(list(any),[])
#     ebs_optimized                             = optional(bool)
#     enclave_options_enabled                   = optional(bool)
#     ephemeral_block_device                    = optional(list(map(string)), [])
#     get_password_data                         = optional(bool)
#     hibernation                               = optional(bool)
#     host_id                                   = optional(string)
#     iam_instance_profile                      = optional(string)
#     instance_initiated_shutdown_behavior      = optional(string)
#     instance_type                             = string
#     instance_tags                             = optional(map(string))
#     ipv6_address_count                        = optional(number)
#     ipv6_addresses                            = optional(list(string))
#     key_name                                  = string
#     launch_template                           = optional(map(string))
#     metadata_options                          = optional(map(string))
#     monitoring                                = optional(bool)
#     network_interface                         = optional(list(map(string)))
#     private_dns_name_options                  = optional(map(string))
#     placement_group                           = optional(string)
#     private_ip                                = optional(string)
#     root_block_device                         = optional(list(any))
#     secondary_private_ips                     = optional(list(string))
#     source_dest_check                         = optional(bool)
#     subnet_id                                 = optional(string)
#     tags                                      = map(string)
#     tenancy                                   = optional(string)
#     user_data                                 = optional(string)
#     user_data_base64                          = optional(string)
#     user_data_replace_on_change               = optional(bool)
#     volume_tags                               = optional(map(string), {})
#     enable_volume_tags                        = optional(bool, true)
#     timeouts                                  = optional(map(string), {})
#     cpu_options                               = optional(any, {})
#     cpu_core_count                            = optional(number)
#     cpu_threads_per_core                      = optional(number)
#     create_spot_instance                      = optional(bool, false)
#     spot_price                                = optional(string)
#     spot_wait_for_fulfillment                 = optional(bool)
#     spot_type                                 = optional(string)
#     spot_launch_group                         = optional(string)
#     spot_block_duration_minutes               = optional(number)
#     spot_instance_interruption_behavior       = optional(string)
#     spot_valid_until                          = optional(string)
#     spot_valid_from                           = optional(string)
#     disable_api_stop                          = optional(bool)
#     create_iam_instance_profile               = optional(bool, false)
#     iam_role_name                             = optional(string)
#     iam_role_use_name_prefix                  = optional(bool, true)
#     iam_role_description                      = optional(string)
#     iam_role_permissions_boundary             = optional(string)
#     iam_role_policies                         = optional(map(string), {})
#     iam_role_tags                             = optional(map(string), {})
#     create_eip                                = optional(bool, false)
#     eip_domain                                = optional(string, "vpc")
#     eip_tags                                  = optional(map(string), {})

#     }))
#     default = {}
# }

# variable "internal_load_balancers" {
#   description = "application load balancers to be attached in front of the ec2 instances"
#   type        = map(object({
#     create            = bool
#     tags              = optional(map(string), {})
#     access_logs       = optional(map(string), {})
#     connection_logs   = optional(map(string), {})
#     ipam_pools        = optional( map(string), {})
#     client_keep_alive = optional(number,null)
#     customer_owned_ipv4_pool          = optional(string, null)
#     desync_mitigation_mode            = optional(string, null)
#     dns_record_client_routing_policy  = optional(string, null)
#     drop_invalid_header_fields        = optional(bool, true)
#     enable_cross_zone_load_balancing  = optional(bool, true)
#     enable_deletion_protection        = optional(bool, false)
#     enable_http2                      = optional(bool, null)
#     enable_tls_version_and_cipher_suite_headers = optional(bool, null)
#     enable_waf_fail_open                        = optional(bool, null)
#     enable_xff_client_port                      = optional(bool, null)
#     enable_zonal_shift                          = optional(bool, null)
#     idle_timeout                                = optional(number, 60)
#     internal                                    = optional(bool, true)
#     ip_address_type                             = optional(string, "ipv4")
#     load_balancer_type                          = string
#     enforce_security_group_inbound_rules_on_private_link_traffic = optional(string, null)
#     name                                        = string
#     name_prefix                                 = optional(string)
#     preserve_host_header                        = optional(bool)
#     security_groups                             = optional(list(string), [])
#     subnets                                     = list(string)
#     xff_header_processing_mode                  = optional(string, "append")
#     timeouts                                    = optional(map(string), {})
#     listeners                                   = any
#     target_groups                               = any
#     additional_target_group_attachments         = optional(any, {})
#     create_security_group                       = optional(bool, true)
#     security_group_name                         = string
#     security_group_use_name_prefix              = optional(bool, true)
#     security_group_description                  = optional(string, null)
#     security_group_ingress_rules                = any
#     security_group_egress_rules                 = any
#     security_group_tags                         = optional(map(string), {})
#   }))
#   default     = {}
# }

# variable "lambda_function" {
#     description = "Map of lambda function configurations"
#     type        = map(object({
#         region                 = string
#         function_name          = string
#         runtime                = string
#         package_type           = string
#         filename               = string
#         kms_key_arn            = string
#         log_retention_in_days  = number
#         log_encryption_key_arn = string
#         vpc_config = map(any)
#             }))
# }

# variable "db_username" {
#   description = "database username"
#   type        = string
# }

# variable "db_username" {
#   description = "database username"
#   type        = string
# }

# variable "ingress_with_cidr_blocks" {
#   description = "ingress with cidr blocks"
#   type        = list(object({
#     cidr_blocks = string
#     description = string
#   }))
# }

# variable "egress_with_cidr_blocks" {
#   description = "egress with cidr blocks"
#   type        = list(object({
#     cidr_blocks = string
#     description = string
#   }))
# } 