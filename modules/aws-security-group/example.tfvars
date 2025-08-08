region = "ap-south-1"
name   = "dev-sg"
vpc_id = "vpc-01234xxx"
ingress_rules = [
  {
    ip_protocol = "tcp"
    from_port   = 443
    to_port     = 443
    description = "https from vpc"
    cidr_ipv4   = "10.0.0.0/16"
    # other parameters are as follows
    # cidr_ipv6: The source IPv6 CIDR range
    # prefix_list_id: The ID of the source prefix list
    # referenced_security_group_id: The source security group id to add in the rule
  },
  {
    ip_protocol = "tcp"
    from_port   = 80
    to_port     = 80
    description = "http from vpc"
    cidr_ipv4   = "10.0.0.0/16"
  }
]
egress_rules = [
  {
    ip_protocol = "tcp"
    from_port   = 443
    to_port     = 443
    description = "https to vpc"
    cidr_ipv4   = "10.0.0.0/16"
    # other parameters are as follows
    # cidr_ipv6: The destination IPv6 CIDR range
    # prefix_list_id: The ID of the destination prefix list
    # referenced_security_group_id: The destination security group id to add in the rule
  },
  {
    ip_protocol = "tcp"
    from_port   = 80
    to_port     = 80
    description = "http to vpc"
    cidr_ipv4   = "10.0.0.0/16"
  }
]
