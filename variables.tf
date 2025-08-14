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

variable "region"{
  description = "Region in which deployment is to be done."
  type        = string
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
#     associate_public_ip_address               = optional(bool, false)
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
#     tags                                      = optional(map(string), {})
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


variable "rds_databases" {
  description = "Map of RDS database configurations for for_each in module.rds_database"
  type        = map(object({
    identifier = string

    # Networking
    vpc_security_group_ids = optional(list(string), [])
    subnet_ids             = optional(list(string))

    # Engine & versions
    engine         = optional(string, "postgres")
    engine_version = optional(string, "17.5")
    family         = optional(string, "postgres17")

    # Sizing & storage
    instance_class      = string
    storage_type        = optional(string, "gp3")
    allocated_storage   = number
    max_allocated_storage = number
    port                = optional(number, 5432)
    storage_encrypted   = optional(bool, true)
    deletion_protection = optional(bool, false)

    # Database
    db_name  = optional(string)
    username = string
    password = string
    manage_master_user_password = bool

    # Backups & maintenance
    backup_retention_period    = optional(number, 30)
    backup_window              = optional(string, "03:16-03:46")
    maintenance_window         = optional(string, "sun:13:16-sun:13:46")
    auto_minor_version_upgrade = optional(bool, true)
    final_snapshot_identifier  = optional(string)
    skip_final_snapshot        = optional(bool, true)
    copy_tags_to_snapshot      = optional(bool, true)
    multi_az                   = optional(bool, false)
    enabled_cloudwatch_logs_exports = optional(list(string), ["audit", "error", "general", "slowquery"]) 

    # Parameter/Subnet groups
    db_subnet_group_name       = optional(string)
    db_subnet_group_identifier = optional(string, "")
    create_db_parameter_group  = optional(bool, true)
    create_db_subnet_group     = optional(bool, true)

    # Misc
    kms_key_id          = optional(string)
    create_monitoring_role = optional(bool, true)
    monitoring_role_name = optional(string, "hal-sbn-crew-onboarding-db-monitoring-role")
    monitoring_interval = optional(number, 60)
    create_db_instance  = optional(bool, true)

    # Tags
    tags = optional(map(string), {})
  }))
}