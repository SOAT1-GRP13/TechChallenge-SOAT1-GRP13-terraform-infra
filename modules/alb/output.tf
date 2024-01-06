
output "egress_all_id" {
  value       = aws_security_group.egress_all.id
}

output "ingress_api_id" {
  value       = aws_security_group.ingress_api.id
}

output "lb_target_group_pedido_arn" {
  description = "arn pedito target group"
  value       = aws_lb_target_group.pedido.arn
}

output "lb_target_group_pagamento_arn" {
  description = "arn pagamento target group"
  value       = aws_lb_target_group.pagamento.arn
}

output "lb_target_group_producao_arn" {
  description = "arn producao target group"
  value       = aws_lb_target_group.producao.arn
}

output "lb_target_group_produto_arn" {
  description = "arn produto target group"
  value       = aws_lb_target_group.produto.arn
}

output "lb_target_group_auth_arn" {
  description = "arn auth target group"
  value       = aws_lb_target_group.auth.arn
}

output "listener_arn" {
  description = "arn of alb listener"
  value = aws_lb_listener.this.arn
}

output "dns_name" {
  description = "The DNS name of the load balancer"
  value       = try(aws_lb.this.dns_name, null)
}