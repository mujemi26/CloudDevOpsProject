output "app_security_group_id" {
  description = "The ID of the application security group"
  value       = aws_security_group.app_sg.id
}

output "app_security_group_name" {
  description = "The name of the application security group"
  value       = aws_security_group.app_sg.name
}

output "app_security_group_rules" {
  description = "List of security group rules"
  value = {
    ingress = aws_security_group.app_sg.ingress
    egress  = aws_security_group.app_sg.egress
  }
}
