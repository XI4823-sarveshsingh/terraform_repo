# security groups for ec2 instances 

module "security_groups" {
  source = "./submodules/aws-security-group" # Path to your security group module
  region        = var.region
  common_tags   = try(var.common_tags, {}) # Use default empty map if not specified
  name          = "${var.name}_security-group"
  description   = "Security Group for ${var.name} EC2 Instance"
  vpc_id        = var.vpc_id
  ingress_rules = try(var.ingress_rules, []) # Use default empty list if not specified
  egress_rules  = try(var.egress_rules, []) # Use default empty list if not specified
}

# EC2 instances
module "ec2_instances" {
  source = "./submodules/aws-ec2-instance"
  create                = var.create
  name                  = var.name
  subnet_id             = var.subnet_id
  vpc_security_group_ids= [module.security_groups.security_group_id]
  ami                   = try(var.ami, null) 
  instance_type         = try(var.instance_type, null) 
  associate_public_ip_address = try(var.associate_public_ip_address, false) 
  user_data             = try(var.user_data, null)
  key_name              = try(var.key_name, null)
  iam_instance_profile  = try(var.iam_instance_profile, null)
  monitoring            = try(var.monitoring, null)
  root_block_device     = try(var.root_block_device, [])
  ebs_block_device      = try(var.ebs_block_device, [])
  tags                  = try(var.tags, {})
  instance_tags         = try(var.instance_tags, {})
  volume_tags           = try(var.volume_tags, {})
  enable_volume_tags    = try(var.enable_volume_tags, true)
  create_iam_instance_profile = try(var.create_iam_instance_profile, false)
  iam_role_name              = try(var.iam_role_name, null)
  iam_role_policies          = try(var.iam_role_policies, {})
  iam_role_tags              = try(var.iam_role_tags, {})
  create_spot_instance = try(var.create_spot_instance, false)
  spot_price          = try(var.spot_price, null)

  create_eip = try(var.create_eip, false)
  eip_tags   = try(var.eip_tags, {})
}