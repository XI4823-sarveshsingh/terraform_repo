output "security_group_id" {
  value       = aws_security_group.sg.id
  description = "ID of the security group"
}