variable "task_exec_secret_arns" {
  description = "List of SecretsManager secret ARNs the task execution role will be permitted to get/read"
}

variable "lb_target_group_arn" {
  description = "target group of the lb"
}

variable "lb_engress_id" {
  description = "Id of engress sg"
}

variable "lb_ingress_id" {
  description = "Id of ingress sg"
}

variable "public_subnets_id" {
  description = "Public subnets"
}
