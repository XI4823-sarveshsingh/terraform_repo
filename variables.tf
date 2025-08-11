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

variable "ec2_instances" {
    description = "Map of ec2 instance configurations"
    type        = map(object({
    region                         = string
    ingress_rules = list(object({
      ip_protocol                  = string
      from_port                    = number
      to_port                      = number
      description                  = string
      cidr_ipv4                    = string
      cidr_ipv6                    = optional(string)
      prefix_list_id               = optional(string)
      referenced_security_group_id = optional(string)
    }))
    egress_rules = list(object({
      ip_protocol                  = string
      from_port                    = optional(number)
      to_port                      = optional(number)
      description                  = string
      cidr_ipv4                    = string
      cidr_ipv6                    = optional(string)
      prefix_list_id               = optional(string)
      referenced_security_group_id = optional(string)
    }))
    common_tags                               = optional(map(string))
    create                                    = bool
    name                                      = string
    ami_ssm_parameter                         = optional(string)
    ami                                       = optional(string)
    ignore_ami_changes                        = optional(bool)
    associate_public_ip_address               = optional(bool, false)
    maintenance_options                       = optional(any)
    availability_zone                         = string
    capacity_reservation_specification        = optional(any)
    cpu_credits                               = optional(string)
    disable_api_termination                   = optional(bool)
    ebs_block_device                          = optional(list(any),[])
    ebs_optimized                             = optional(bool)
    enclave_options_enabled                   = optional(bool)
    ephemeral_block_device                    = optional(list(map(string)), [])
    get_password_data                         = optional(bool)
    hibernation                               = optional(bool)
    host_id                                   = optional(string)
    iam_instance_profile                      = optional(string)
    instance_initiated_shutdown_behavior      = optional(string)
    instance_type                             = string
    instance_tags                             = optional(map(string))
    ipv6_address_count                        = optional(number)
    ipv6_addresses                            = optional(list(string))
    key_name                                  = string
    launch_template                           = optional(map(string))
    metadata_options                          = optional(map(string))
    monitoring                                = optional(bool)
    network_interface                         = optional(list(map(string)))
    private_dns_name_options                  = optional(map(string))
    placement_group                           = optional(string)
    private_ip                                = optional(string)
    root_block_device                         = optional(list(any))
    secondary_private_ips                     = optional(list(string))
    source_dest_check                         = optional(bool)
    subnet_id                                 = optional(string)
    tags                                      = optional(map(string), {})
    tenancy                                   = optional(string)
    user_data                                 = optional(string)
    user_data_base64                          = optional(string)
    user_data_replace_on_change               = optional(bool)
    volume_tags                               = optional(map(string), {})
    enable_volume_tags                        = optional(bool, true)
    timeouts                                  = optional(map(string), {})
    cpu_options                               = optional(any, {})
    cpu_core_count                            = optional(number)
    cpu_threads_per_core                      = optional(number)
    create_spot_instance                      = optional(bool, false)
    spot_price                                = optional(string)
    spot_wait_for_fulfillment                 = optional(bool)
    spot_type                                 = optional(string)
    spot_launch_group                         = optional(string)
    spot_block_duration_minutes               = optional(number)
    spot_instance_interruption_behavior       = optional(string)
    spot_valid_until                          = optional(string)
    spot_valid_from                           = optional(string)
    disable_api_stop                          = optional(bool)
    create_iam_instance_profile               = optional(bool, false)
    iam_role_name                             = optional(string)
    iam_role_use_name_prefix                  = optional(bool, true)
    iam_role_description                      = optional(string)
    iam_role_permissions_boundary             = optional(string)
    iam_role_policies                         = optional(map(string), {})
    iam_role_tags                             = optional(map(string), {})
    create_eip                                = optional(bool, false)
    eip_domain                                = optional(string, "vpc")
    eip_tags                                  = optional(map(string), {})

    }))
    default = {}
}
