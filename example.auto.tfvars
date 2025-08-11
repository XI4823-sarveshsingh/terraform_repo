vpc_id    = "vpc-0fc2a2b6df73c5152"
app_subnet_ids = ["subnet-09ec22b6b1d143473", "subnet-06dcc9255ae6e5838", "subnet-0a95b4eed2fbabe2b"]
eks_subnet_ids = ["subnet-09ec22b6b1d143473", "subnet-06dcc9255ae6e5838", "subnet-0a95b4eed2fbabe2b"]
region = "us-east-1"

ecr_repositories = {
  "repo1" = {
    name = "hac-crewonbrd-repo/webapp"
  },
  "repo2" = {
    name = "hac-crewonbrd-repo/middleware"
  },
  "repo3" = {
    name = "hac-crewonbrd-repo/maps"
  },
  "repo4" = {
    name = "hac-crewonbrd-repo/chatbot-middleware"
  },
  "repo5" = {
    name = "hac-crewonbrd-repo/chatbot"
  }
}

ec2_instances = {
  "jenkins" = {
    region   = "us-east-1"
    ingress_rules = [
      {
        ip_protocol = "tcp"
        from_port   = 8080
        to_port     = 8080
        description = "Allow for jenkins ui"
        cidr_ipv4   = "10.0.0.0/8"
      },
      {
        ip_protocol = "tcp"
        from_port   = 22
        to_port     = 22
        description = "Allow SSH from trusted IP"
        cidr_ipv4   = "10.0.0.0/8" # Replace with your IP range
      },
      {
        ip_protocol = "tcp"
        from_port   = 8080
        to_port     = 8080
        description = "Allow for jenkins ui"
        cidr_ipv4   = "172.16.0.0/12"
      },
      {
        ip_protocol = "tcp"
        from_port   = 22
        to_port     = 22
        description = "Allow SSH from trusted IP"
        cidr_ipv4   = "172.16.0.0/12" # Replace with your IP range
      },
      {
        ip_protocol = "tcp"
        from_port   = 8080
        to_port     = 8080
        description = "Allow for jenkins ui"
        cidr_ipv4   = "192.168.0.0/16"
      },
      {
        ip_protocol = "tcp"
        from_port   = 22
        to_port     = 22
        description = "Allow SSH from trusted IP"
        cidr_ipv4   = "192.168.0.0/16" # Replace with your IP range
      }
    ]
    egress_rules = [
      {
        ip_protocol = "-1" # All protocols
        description = "Allow all outbound traffic"
        cidr_ipv4   = "0.0.0.0/0"
      }
    ]
    common_tags = {
      Component   = "jenkins"
    }
    create                = true
    name                  = "jenkins-instance-ec2"
    instance_type         = "t2.xlarge" 
    key_name              = "jumpbox-key"
    associate_public_ip_address   = false
    root_block_device = [
      {
        volume_size = 100 # Override default
        volume_type = "gp3"
        encrypted   = false
      }
    ]
    tags = {
      Environment = "prod"
      Component   = "jenkins"
    }
    availability_zone           = "us-east-1a"
    create_iam_instance_profile = true
    iam_role_name             = "jenkins-role-for-ec2"
    iam_role_policies = {
      "admin-access" = "arn:aws:iam::aws:policy/AdministratorAccess"
    }
  }
}