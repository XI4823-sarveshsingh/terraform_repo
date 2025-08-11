output "Instance_id" {
  description = "The ID of the instance"
  value       = module.ec2_instances.id
}

output "arn" {
  description = "The ARN of the instance"
  value       = module.ec2_instances.arn
}

output "instance_state" {
  description = "The state of the instance. One of: `pending`, `running`, `shutting-down`, `terminated`, `stopping`, `stopped`"
  value       = module.ec2_instances.instance_state
}

output "primary_network_interface_id" {
  description = "The ID of the instance's primary network interface"
  value       = module.ec2_instances.primary_network_interface_id
}

output "private_dns" {
  description = "The private DNS name assigned to the instance. Can only be used inside the Amazon EC2, and only available if you've enabled DNS hostnames for your VPC"
  value       = module.ec2_instances.private_dns
}

output "public_dns" {
  description = "The public DNS name assigned to the instance. For EC2-VPC, this is only available if you've enabled DNS hostnames for your VPC"
  value       = module.ec2_instances.public_dns
}

output "public_ip" {
  description = "The public IP address assigned to the instance, if applicable. NOTE: If you are using an aws_eip with your instance, you should refer to the EIP's address directly and not use `public_ip` as this field will change after the EIP is attached"
  value       = module.ec2_instances.public_ip
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = module.ec2_instances.tags_all
}

output "Security_Group" {
  description = "Security Group assigned to the instance"
  value       = module.security_groups.security_group_id
}