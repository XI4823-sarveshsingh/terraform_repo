# getting the id for existing vpc
data "aws_vpc" "existing_vpc" { 
    id = var.vpc_id 
    }


# getting the id for existing subnets
# data "aws_subnets" "subnets_for_rds" {
#   filter {
#       name   = "subnet-id"  # Filter by exact subnet IDs
#       values = var.database_subnet_ids  # Your list of 2 IDs
#     }
#   }

# data "aws_subnets" "subnets_for_ec2" {
#   filter {
#       name   = "subnet-id"  # Filter by exact subnet IDs
#       values = var.app_subnet_ids  # Your list of 2 IDs
#     }
# }


data "aws_subnets" "subnets_for_eks" {
  filter {
      name   = "subnet-id"  # Filter by exact subnet IDs
      values = var.eks_subnet_ids  # Your list of 2 IDs
    }
}



# Tag private subnets as internal ELBs
resource "aws_ec2_tag" "subnet_internal_elb" {
  for_each    = toset(data.aws_subnets.subnet_for_eks.id)
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
  cluster_name = "eks-xchat-clstr-dev"
  vpc_id       = var.vpc_id
  subnet_ids   = data.aws_subnets.subnets_for_eks.id
  # Optional variables
  cluster_addons = {
    coredns                = {most_recent = true}
    kube-proxy             = {most_recent = true}
    vpc-cni                = {most_recent = true}
    external-dns           = {most_recent = true}
    metrics-server         = {most_recent = true}
    eks-pod-identity-agent = {most_recent = true}
  }
  cluster_version                = "1.33"
  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = false
  cluster_enabled_log_types      = ["api", "audit", "authenticator"]
  cloudwatch_log_group_retention_in_days = 90
  create_kms_key = false  #cloudwatch_log_group_kms_key_arn  = "arn:aws:kms:us-east-1:427942813953:key/660f4d14-74e8-4777-9b12-33895d9631e8"
  cluster_encryption_config      = {}
  # Node group configuration with additional IAM policies
  eks_managed_node_groups = {
    worker-1 =    {
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
#   access_entries = {
#   my-admin-role = {
#     principal_arn = "arn:aws:iam::427942813953:user/Sarvesh" #can't be the iam role running terraform apply
#     type          = "STANDARD"
#     policy_associations = {
#       admin = {
#         policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
#         access_scope = {
#           type = "cluster"
#         }
#       }
#     }
#   }
# }
}