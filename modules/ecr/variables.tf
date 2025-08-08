variable "region" {
  type        = string
  description = "Region in which Redis needs to create."
  default     = "ap-south-1"
}
variable "assume_role_arn" {
  description = "Assume role in which account to create"
  type        = string
  default     = ""
}
variable "common_tags" {
  type        = map(string)
  default     = {}
  description = "Add common tags to your resources"
}

##################################################################################################################
# ECR
##################################################################################################################

variable "name" {
  description = "The name of the repository"
  type        = string
}
variable "type" {
  description = "The type of repository to create. Either `public` or `private`. Public repo can only be used with 'region' variable set to us-east-1"
  type        = string
  default     = "private"
}

##################################################################################################################
# Private ECR
##################################################################################################################

variable "image_tag_mutability" {
  description = "The tag mutability setting for the repository. Must be one of: `MUTABLE` or `IMMUTABLE`. Defaults to `IMMUTABLE`"
  type        = string
  default     = "IMMUTABLE"
}
variable "enable_force_delete" {
  description = "Whether to delete the repository even if it contains images"
  default     = false
  type        = bool
}
variable "encryption_type" {
  description = "The encryption type for the repository. Must be one of: `KMS` or `AES256`. Defaults to `KMS`"
  type        = string
  default     = "KMS"
}
variable "kms_key_id" {
  description = "The ARN of the KMS key to use when encryption_type is `KMS`. If not specified, uses the default AWS managed key for ECR"
  type        = string
  default     = ""
}
variable "enable_image_scan_on_push" {
  description = "Indicates whether images are scanned after being pushed to the repository (`true`) or not scanned (`false`)"
  type        = bool
  default     = true
}
variable "lifecycle_policy_path" {
  type        = string
  default     = ""
  description = "The path of the lifecycle policy document. Empty value indicates no lifecycle policy will be created"
}

###################################################################################################################
# Public Repository
###################################################################################################################

variable "catalog_data" {
  description = "Catalog data configuration for the repository"
  type        = any
  default     = {}
}

###################################################################################################################
# Repository Policy (Permissions)
###################################################################################################################

variable "permissions_policy_path" {
  type        = string
  default     = ""
  description = "The path of the permissions policy document to be used to create permissions policy. Empty value indicates no permissions policy will be created"
}
variable "permissions_policy_vars" {
  type        = map(any)
  default     = {}
  description = "Map of policy variables to substitue in permissions policy document(if any)"
}

###################################################################################################################
# Registry Configuration
###################################################################################################################

variable "registry_policy_path" {
  description = "Path of the registry policy document. Empty value indicates no registry policy will be created"
  type        = string
  default     = ""
}
variable "registry_policy_vars" {
  type        = map(any)
  default     = {}
  description = "Map of registry policy variables to substitue in registroy policy document(if any)"
}
variable "pull_through_cache_rules" {
  description = "List of pull through cache rules to create"
  type        = list(any)
  default     = []
}
variable "manage_registry_scanning_config" {
  description = "Determines whether the registry scanning configuration will be managed"
  type        = bool
  default     = false
}
variable "registry_scan_type" {
  description = "the scanning type to set for the registry. Can be either `ENHANCED` or `BASIC`"
  type        = string
  default     = "ENHANCED"
}
variable "registry_scan_rules" {
  description = "One or multiple blocks specifying scanning rules to determine which repository filters are used and at what frequency scanning will occur"
  type        = list(any)
  default     = []
}
variable "create_registry_replication_configuration" {
  description = "Determines whether a registry replication configuration will be created"
  type        = bool
  default     = false
}
variable "registry_replication_rules" {
  description = "The replication rules for a replication configuration. A maximum of 10 are allowed"
  type        = list(any)
  default     = []
}