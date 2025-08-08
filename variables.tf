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

