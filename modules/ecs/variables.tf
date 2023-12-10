variable "task_exec_secret_arns" {
  description = "List of SecretsManager secret ARNs the task execution role will be permitted to get/read"
}

variable "lb_target_group_pedido_arn" {
  description = "The ID of the security group"
}

variable "lb_target_group_pagamento_arn" {
  description = "The ID of the security group"
}

variable "lb_target_group_producao_arn" {
  description = "The ID of the security group"
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
