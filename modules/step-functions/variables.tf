variable "name" {
  description = "Name of the state machine"
  type        = string
}

variable "iam_role_name" {
  description = "IAM Role name for the Step Function"
  type        = string
}

variable "iam_policy_json" {
  description = "IAM policy JSON string"
  type        = string
}

variable "definition_file" {
  description = "Path to the state machine definition file (ASL JSON)"
  type        = string
}

variable "type" {
  description = "Step Function type: STANDARD or EXPRESS"
  type        = string
  default     = "STANDARD"
}

variable "tags" {
  type        = map(string)
  default     = {}
}

variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "definition" {
  type        = string
  description = "Rendered JSON definition of the Step Function"
}
