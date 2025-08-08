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
# Security Group
################################################################################

variable "name" {
  type        = string
  description = "Name of the security group"
}
variable "description" {
  type        = string
  default     = "Security group"
  description = "Description of the security group"
}
variable "vpc_id" {
  type        = string
  description = "VPC id for the vpc in which security group is to be created"
}
variable "ingress_rules" {
  type        = list(any)
  default     = []
  description = "List of security group ingress rules to associate with the security group"
}
variable "egress_rules" {
  type        = list(any)
  default     = []
  description = "List of security group egress rules to associate with the security group"
}