variable "region" {
  type        = string
  description = "Provide region name"
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
  description = "Add common tags to your resource"
}
###############################################################################################################
# configure s3 
###############################################################################################################
variable "enable_acceleration_status" {
  description = "Sets the accelerate configuration of an existing bucket."
  type        = bool
  default     = true
}
variable "name" {
  type        = string
  description = "Provide a name for the bucket to be created"
}
variable "enable_object_lock" {
  description = "Whether S3 bucket should have an Object Lock configuration enabled"
  type        = bool
  default     = true
}
variable "enable_force_destroy" {
  description = "A boolean that indicates all objects should be deleted from the bucket when the bucket is destroyed"
  type        = bool
  default     = false
}
variable "enable_replication" {
  description = "Whether to enable replication bucket or not"
  type        = bool
  default     = true
}
variable "enable_logging" {
  description = "Whether to enable logging bucket or not"
  type        = bool
  default     = true
}

###############################################################################################################
# s3 ownership
###############################################################################################################
variable "object_ownership" {
  description = "Object ownership. Valid values: BucketOwnerEnforced, BucketOwnerPreferred or ObjectWriter. 'BucketOwnerEnforced': ACLs are disabled, and the bucket owner automatically owns and has full control over every object in the bucket. 'BucketOwnerPreferred': Objects uploaded to the bucket change ownership to the bucket owner if the objects are uploaded with the bucket-owner-full-control canned ACL. 'ObjectWriter': The uploading account will own the object if the object is uploaded with the bucket-owner-full-control canned ACL."
  type        = string
  default     = "BucketOwnerEnforced"
}
###############################################################################################################
# manages public access for the bucket
###############################################################################################################
variable "block_public_acls" {
  description = "Whether Amazon S3 should block public ACLs for this bucket."
  type        = bool
  default     = true
}
variable "block_public_policy" {
  description = "Whether Amazon S3 should block public bucket policies for this bucket."
  type        = bool
  default     = true
}
variable "ignore_public_acls" {
  description = "Whether Amazon S3 should ignore public ACLs for this bucket."
  type        = bool
  default     = true
}
variable "restrict_public_buckets" {
  description = "Whether Amazon S3 should restrict public bucket policies for this bucket."
  type        = bool
  default     = true
}
###############################################################################################################
# acl
###############################################################################################################
variable "acl" {
  description = "Sets the access control list for the bucket. Can be private or public-read."
  type        = string
  default     = "private"
}
###############################################################################################################
# CORS config and replication config
###############################################################################################################
variable "enable_cors_config" {
  description = "Whether cors configuration should be enabled or not on s3 bucket."
  type        = bool
  default     = true
}
variable "cors_rules" {
  description = "List of maps containing rules for Cross-Origin Resource Sharing."
  type        = list(any)
  default     = []
}
variable "replication_configuration" {
  type        = map(any)
  default     = {}
  description = "Specifies the replication rules for S3 bucket replication if enabled"
}
###############################################################################################################
# manages public access for the bucket
###############################################################################################################
variable "enable_intelligent_tiering" {
  description = "Whether to enable intelligent tiering or not"
  type        = bool
  default     = false
}
variable "intelligent_tiering" {
  description = "Map containing intelligent tiering configuration."
  type        = map(any)
  default     = {}
}
variable "enable_lifecycle_configuration" {
  description = "Whether to enable lifecycle configuration or not"
  type        = bool
  default     = false
}
variable "lifecycle_rule" {
  description = "List of maps containing configuration of object lifecycle management."
  type        = list(any)
  default     = []
}
###############################################################################################################
# versioning and metric config
###############################################################################################################
variable "enable_versioning" {
  type        = bool
  default     = true
  description = "A state of versioning. Versioning is a means of keeping multiple variants of an object in the same bucket"
}
variable "metric_configuration" {
  description = "Map containing bucket metric configuration."
  type        = list(any)
  default     = []
}
###############################################################################################################
# object lock config
###############################################################################################################
variable "object_lock_configuration" {
  description = "Map containing S3 object locking configuration."
  type        = map(any)
  default     = {}
}
###############################################################################################################
# policies
###############################################################################################################
variable "attach_deny_insecure_transport_policy" {
  description = "Controls if S3 bucket should have deny non-SSL transport policy attached"
  type        = bool
  default     = false
}
variable "attach_policy" {
  description = "Controls if S3 bucket should have bucket policy attached (set to `true` to use value of `policy` as bucket policy)"
  type        = bool
  default     = false
}
variable "policy_path" {
  type        = string
  default     = ""
  description = "The path of the policy document to be used to create policy"
}
variable "policy_vars" {
  type        = map(any)
  default     = {}
  description = "Policy variables to substitue in policy document(if any)"
}
###############################################################################################################
# website config
###############################################################################################################
variable "website" {
  description = "Map containing static web-site hosting or redirect configuration."
  type        = map(any)
  default     = {}
}
variable "kms_key_id" {
  type        = string
  description = "Contain key id for kms key"
}