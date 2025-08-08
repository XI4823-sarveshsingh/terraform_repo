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
# Security Group
################################################################################

resource "aws_security_group" "sg" {
  name        = var.name
  description = var.description
  vpc_id      = var.vpc_id
  tags = {
    "Name" = var.name
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_vpc_security_group_ingress_rule" "ingress" {
  count                        = length(var.ingress_rules)
  security_group_id            = aws_security_group.sg.id
  ip_protocol                  = var.ingress_rules[count.index].ip_protocol
  from_port                    = var.ingress_rules[count.index].from_port
  to_port                      = var.ingress_rules[count.index].to_port
  description                  = try(var.ingress_rules[count.index].description, null)
  cidr_ipv4                    = try(var.ingress_rules[count.index].cidr_ipv4, null)
  cidr_ipv6                    = try(var.ingress_rules[count.index].cidr_ipv6, null)
  prefix_list_id               = try(var.ingress_rules[count.index].prefix_list_id, null)
  referenced_security_group_id = try(var.ingress_rules[count.index].referenced_security_group_id, null)
}

resource "aws_vpc_security_group_egress_rule" "egress" {
  count                        = length(var.egress_rules)
  security_group_id            = aws_security_group.sg.id
  ip_protocol                  = var.egress_rules[count.index].ip_protocol
  from_port                    = var.egress_rules[count.index].from_port
  to_port                      = var.egress_rules[count.index].to_port
  description                  = try(var.egress_rules[count.index].description, null)
  cidr_ipv4                    = try(var.egress_rules[count.index].cidr_ipv4, null)
  cidr_ipv6                    = try(var.egress_rules[count.index].cidr_ipv6, null)
  prefix_list_id               = try(var.egress_rules[count.index].prefix_list_id, null)
  referenced_security_group_id = try(var.egress_rules[count.index].referenced_security_group_id, null)
}