data "aws_vpc" "existing_vpc" {
    id = var.vpc_id
    }
 
data "aws_subnets" "subnets_for_eks" {
  filter {
      name   = "subnet-id"  # Filter by exact subnet IDs
      values = var.eks_subnet_ids  # Your list of 2 IDs
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
