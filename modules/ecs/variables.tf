# variable "task_exec_secret_arns" {
#   description = "List of SecretsManager secret ARNs the task execution role will be permitted to get/read"
# }

variable "dynamo_arn" {
  description = "arn of dynamoDB"
}

variable "dynamo_pedidos_arn" {
  description = "arn of dynamoDB pedidosQR"
}

variable "lb_target_group_pedido_arn" {
  description = "arn pedido target group"
}

variable "lb_target_group_rabbit_management_arn" {
  description = "arn rabbit management target group"
}

variable "lb_target_group_rabbit_arn" {
  description = "arn rabbitmq target group"
}

variable "lb_target_group_pagamento_arn" {
  description = "arn pagamento target group"
}

variable "lb_target_group_producao_arn" {
  description = "arn producao target group"
}

variable "lb_target_group_produto_arn" {
  description = "arn produto target group"
}

variable "lb_target_group_auth_arn" {
  description = "arn auth target group"
}

variable "lb_engress_id" {
  description = "Id of engress sg"
}

variable "lb_ingress_id" {
  description = "Id of ingress sg"
}

variable "privates_subnets_id" {
  description = "Privates subnets"
}

variable "vpc_id" {
  description = "id of vpc"
}
