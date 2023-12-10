
output "egress_all_id" {
  value       = aws_security_group.egress_all.id
}

output "ingress_api_id" {
  value       = aws_security_group.ingress_api.id
}

output "lb_target_group_pedido_arn" {
  description = "The ID of the security group"
  value       = aws_lb_target_group.pedido.arn
}

output "lb_target_group_pagamento_arn" {
  description = "The ID of the security group"
  value       = aws_lb_target_group.pagamento.arn
}

output "lb_target_group_producao_arn" {
  description = "The ID of the security group"
  value       = aws_lb_target_group.producao.arn
}

output "listener_arn" {
  description = "arn of alb listener"
  value = aws_lb_listener.this.arn
}