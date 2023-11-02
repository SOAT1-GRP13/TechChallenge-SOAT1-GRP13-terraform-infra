################################################################################
# Cluster
################################################################################

resource "aws_ecs_cluster" "this" {
  name  = "soat1-grp13-tech-challenge"
}

################################################################################
# CloudWatch Log Group
################################################################################

resource "aws_cloudwatch_log_group" "this" {
  name              = "/aws/ecs/${aws_ecs_cluster.this.name}"
  retention_in_days = 30
}

################################################################################
# Cluster Capacity Providers
################################################################################

resource "aws_ecs_cluster_capacity_providers" "this" {
  capacity_providers = ["FARGATE"]
  cluster_name       = aws_ecs_cluster.this.name
}

################################################################################
# Task Execution - IAM Role
# https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task_execution_IAM_role.html
################################################################################

resource "aws_iam_role_policy_attachment" "default" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
  role       = aws_iam_role.task_exec.name
}

data "aws_iam_policy_document" "task_exec_assume" {
  statement {
    sid     = "ECSTaskExecutionAssumeRole"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "task_exec" {
  name = "taskRole"
  assume_role_policy = data.aws_iam_policy_document.task_exec_assume.json

}

# resource "aws_iam_role_policy_attachment" "task_exec_additional" {
#   role       = aws_iam_role.task_exec.name
#   policy_arn = each.value
# }

data "aws_iam_policy_document" "task_exec" {
  # Pulled from AmazonECSTaskExecutionRolePolicy
  statement {
    sid = "Logs"
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]
    resources = ["*"]
  }

  statement {
    sid       = "GetSecrets"
    actions   = ["secretsmanager:GetSecretValue"]
    resources = [var.task_exec_secret_arns]
  }
}

################################################################################
# Task Definition
################################################################################

resource "aws_ecs_task_definition" "this" {
	container_definitions = jsonencode([{
		essential = true,
		image = "christiandmelo/tech-challenge-soat1-grp13:latest",
		name = "soat1-grp13-api",
		portMappings = [{ containerPort = 80 }],
	}])
	cpu = 256
	execution_role_arn = aws_iam_role.task_exec.arn
  task_role_arn = aws_iam_role.task_exec.arn
	family = "soat1-grp13-api"
	memory = 512
	network_mode = "awsvpc"
	requires_compatibilities = ["FARGATE"]
}

################################################################################
# Task Definition
################################################################################

resource "aws_ecs_service" "this" {
	cluster = aws_ecs_cluster.this.id
	desired_count = 1
	launch_type = "FARGATE"
	name = "soat1-grp13-service"
	task_definition = aws_ecs_task_definition.this.arn

	lifecycle {
		ignore_changes = [desired_count, task_definition] # Allow external changes to happen without Terraform conflicts, particularly around auto-scaling.
	}

	load_balancer {
		container_name = "soat1-grp13-api"
		container_port = 80
		target_group_arn = "${var.lb_target_group_arn}"
	}

	network_configuration {
		security_groups = [
      "${var.lb_engress_id}",
      "${var.lb_ingress_id}"
		]
		subnets =  "${var.public_subnets_id}"
    assign_public_ip = true
	}
}
