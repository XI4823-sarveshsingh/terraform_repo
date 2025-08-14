data "aws_vpc" "existing_vpc" {
    id = var.vpc_id
    }
 
data "aws_subnets" "subnets_for_eks" {
  filter {
      name   = "subnet-id"  # Filter by exact subnet IDs
      values = var.eks_subnet_ids  # Your list of 2 IDs
    }
}

data "aws_subnets" "subnets_for_rds" {
  filter {
      name   = "subnet-id"  # Filter by exact subnet IDs
      values = var.database_subnet_ids  # Your list of 2 IDs
    }
  }


# Tag private subnets as internal ELBs
resource "aws_ec2_tag" "subnet_internal_elb" {
  for_each    = toset(data.aws_subnets.subnets_for_eks.ids)
  resource_id = each.value
  key         = "kubernetes.io/role/internal-elb"
  value       = "1"
}

resource "aws_iam_policy" "nginx_ingress_policy" {
  name        = "nginx-ingress-policy"
  path        = "/"
  description = "IAM policy for NGINX Ingress Controller"

  policy = jsonencode({
    Version   = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ec2:DescribeAccountAttributes",
          "ec2:DescribeAddresses",
          "ec2:DescribeInternetGateways"
        ]
        Resource = "*"
      },
    ]
  })
}

data "local_file" "json_data" {
  filename = "${path.module}/aws-lb-controller-iam-policy.json"
}

resource "aws_iam_policy" "alb_controller_policy" {
  name        = "AWSLoadBalancerControllerIAMPolicy"
  path        = "/"
  description = "IAM policy for the AWS Load Balancer Controller"
  policy      = data.local_file.json_data.content
}

module "eks" {
source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  # Required variables
  cluster_name = "hac-crewonbrd-eks-01"
  vpc_id       = var.vpc_id
  subnet_ids   = data.aws_subnets.subnets_for_eks.ids
  # Optional variables
  cluster_addons = {
    coredns                = {most_recent = true}
    kube-proxy             = {most_recent = true}
    vpc-cni                = {most_recent = false}
    external-dns           = {most_recent = true}
    metrics-server         = {most_recent = true}
    eks-pod-identity-agent = {most_recent = true}
  }
  cluster_version                = "1.33"
  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = false
  cluster_enabled_log_types      = ["api", "audit", "authenticator"]
  cloudwatch_log_group_retention_in_days = 90
  create_kms_key = false  
  cluster_encryption_config      = {}
  # Node group configuration with additional IAM policies
  eks_managed_node_groups = {
    node-group-01 =    {
      min_size       = 2
      max_size       = 5
      desired_size   = 2
      instance_types = ["c3.2xlarge"]
      ami_type       = "AL2023_x86_64_STANDARD"
      capacity_type  = "ON_DEMAND"
      disk_size      = 30
      iam_role_additional_policies = {
        ingress_manage_policy = aws_iam_policy.nginx_ingress_policy.arn
        alb_controller_policy = aws_iam_policy.alb_controller_policy.arn
      }
    }
  }
  enable_cluster_creator_admin_permissions = true
  cluster_additional_security_group_ids = ["sg-08fd7aaadd78f6f85"]
}

module "ecr_repo" {
  for_each = var.ecr_repositories 
  source = "./modules/ecr"
  region                          = var.region
  name                            = each.value.name
  type                            = each.value.type
  image_tag_mutability            = each.value.image_tag_mutability
  enable_force_delete             = each.value.enable_ecr_force_delete
  encryption_type                 = each.value.encryption_type
  enable_image_scan_on_push       = each.value.enable_image_scan_on_push
  lifecycle_policy_path           = each.value.lifecycle_policy_path
  permissions_policy_path         = each.value.permissions_policy_path
  registry_policy_path            = each.value.registry_policy_path
  pull_through_cache_rules        = each.value.pull_through_cache_rules
  manage_registry_scanning_config = each.value.manage_registry_scanning_config
  registry_scan_type              = each.value.registry_scan_type
  registry_scan_rules             = each.value.registry_scan_rules
  create_registry_replication_configuration = each.value.create_registry_replication_configuration
}

# security groups for ec2 instances 
# module "ec2" {
#   source = "./modules/ec2" # Path to your ec2 module

#   for_each = var.ec2_instances

#   region        = var.region
#   common_tags   = try(each.value.common_tags, {}) # Use default empty map if not specified
#   vpc_id        = var.vpc_id
#   ingress_rules = try(each.value.ingress_rules, []) # Use default empty list if not specified
#   egress_rules  = try(each.value.egress_rules, []) # Use default empty list if not specified
#   create                = each.value.create
#   name                  = each.value.name
#   subnet_id             = data.aws_subnets.subnets_for_eks.ids[0]
#   ami                   = try(each.value.ami, null) 
#   instance_type         = try(each.value.instance_type, null) 
#   associate_public_ip_address = try(each.value.associate_public_ip_address, false) 
#   user_data             = try(each.value.user_data, null)
#   key_name              = try(each.value.key_name, null)
#   iam_instance_profile  = try(each.value.iam_instance_profile, null)
#   monitoring            = try(each.value.monitoring, null)
#   root_block_device     = try(each.value.root_block_device, [])
#   ebs_block_device      = try(each.value.ebs_block_device, [])
#   tags                  = try(each.value.tags, {})
#   instance_tags         = try(each.value.instance_tags, {})
#   volume_tags           = try(each.value.volume_tags, {})
#   enable_volume_tags    = try(each.value.enable_volume_tags, true)
#   create_iam_instance_profile = try(each.value.create_iam_instance_profile, false)
#   iam_role_name              = try(each.value.iam_role_name, null)
#   iam_role_policies          = try(each.value.iam_role_policies, {})
#   iam_role_tags              = try(each.value.iam_role_tags, {})
#   create_spot_instance = try(each.value.create_spot_instance, false)
#   spot_price          = try(each.value.spot_price, null)

#   create_eip = try(each.value.create_eip, false)
#   eip_tags   = try(each.value.eip_tags, {})
# }

module "rds_database" {
  for_each = var.rds_databases

  source = "./modules/rds"

  # Networking
  subnet_ids = data.aws_subnets.subnets_for_rds.ids
  vpc_security_group_ids = each.value.vpc_security_group_ids

  # Identification
  identifier  = each.value.identifier

  # Engine & versions
  engine               = each.value.engine
  engine_version       = each.value.engine_version
  family               = each.value.family

  # Sizing & storage
  instance_class     = each.value.instance_class
  storage_type       = each.value.storage_type
  allocated_storage  = each.value.allocated_storage
  max_allocated_storage = each.value.max_allocated_storage
  port               = each.value.port
  storage_encrypted  = each.value.storage_encrypted
  deletion_protection = each.value.deletion_protection

  # Database
  db_name       = each.value.db_name
  username      = each.value.username
  password      = each.value.password
  manage_master_user_password = each.value.manage_master_user_password

  # Backups & maintenance
  backup_retention_period    = each.value.backup_retention_period
  backup_window              = each.value.backup_window
  maintenance_window         = each.value.maintenance_window
  auto_minor_version_upgrade = each.value.auto_minor_version_upgrade
  skip_final_snapshot        = each.value.skip_final_snapshot
  copy_tags_to_snapshot      = each.value.copy_tags_to_snapshot
  multi_az                  = each.value.multi_az
  enabled_cloudwatch_logs_exports = each.value.enabled_cloudwatch_logs_exports

  # Misc
  kms_key_id          = each.value.kms_key_id
  create_monitoring_role = each.value.create_monitoring_role
  monitoring_role_name = each.value.monitoring_role_name
  monitoring_interval = each.value.monitoring_interval
  db_subnet_group_name       = each.value.db_subnet_group_name
  create_db_instance         = each.value.create_db_instance
  create_db_parameter_group  = each.value.create_db_parameter_group
  create_db_subnet_group     = each.value.create_db_subnet_group

  # Tags
  tags       = each.value.tags
}
