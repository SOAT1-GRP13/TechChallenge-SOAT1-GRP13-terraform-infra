
output "egress_all_id" {
  value       = aws_security_group.egress_all.id
}

output "ingress_api_id" {
  value       = aws_security_group.ingress_api.id
}

output "lb_target_group_arn" {
  description = "The ID of the security group"
  value       = aws_lb_target_group.this.arn
}