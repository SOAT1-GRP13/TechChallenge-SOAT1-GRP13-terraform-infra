resource "aws_security_group" "http" {
  description = "Permit incoming HTTP traffic"
  name        = "http"
  vpc_id      = var.vpc_id

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 80
    protocol    = "TCP"
    to_port     = 80
  }
}
resource "aws_security_group" "https" {
  description = "Permit incoming HTTPS traffic"
  name        = "https"
  vpc_id      = var.vpc_id

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 443
    protocol    = "TCP"
    to_port     = 443
  }
}
resource "aws_security_group" "egress_all" {
  description = "Permit all outgoing traffic"
  name        = "egress-all"
  vpc_id      = var.vpc_id

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
  }
}

resource "aws_security_group" "ingress_api" {
  description = "Permit some incoming traffic"
  name        = "ingress-esc-service"
  vpc_id      = var.vpc_id

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 80
    protocol    = "TCP"
    to_port     = 80
  }
  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 5672
    protocol    = "TCP"
    to_port     = 5672
  }
    ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 15672
    protocol    = "TCP"
    to_port     = 15672
  }
}

resource "aws_lb" "this" {
  name               = "techchallengeasoat1grp13alb"
  load_balancer_type = "application"
  internal           = true

  security_groups = [
    aws_security_group.egress_all.id,
    aws_security_group.http.id,
    aws_security_group.https.id,
    aws_security_group.ingress_api.id
  ]

  subnets = var.privates_subnets_id
}


################################################################################
# Target Groups
################################################################################

resource "aws_lb_target_group" "notificacao" {
  name        = "notificacao-tg"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc_id

  health_check {
    path = "/health"
  }

  depends_on = [aws_lb.this]
}

resource "aws_lb_target_group" "pedido" {
  name        = "pedido-tg"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc_id

  health_check {
    path = "/health"
  }

  depends_on = [aws_lb.this]
}

resource "aws_lb_target_group" "rabbitmq" {
  name        = "rabbitmq-tg"
  port        = 5672
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc_id

  health_check {
    path = "/rabbitmanagement"
    port = 15672
  }

  depends_on = [aws_lb.this]
}

resource "aws_lb_target_group" "rabbitqmq_management" {
  name        = "rabbitqmq-management-tg"
  port        = 15672
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc_id

  health_check {
    path = "/rabbitmanagement"
  }

  depends_on = [aws_lb.this]
}

resource "aws_lb_target_group" "pagamento" {
  name        = "pagamento-tg"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc_id

  health_check {
    path = "/health"
  }

  depends_on = [aws_lb.this]
}

resource "aws_lb_target_group" "producao" {
  name        = "producao-tg"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc_id

  health_check {
    path = "/health"
  }

  depends_on = [aws_lb.this]
}

resource "aws_lb_target_group" "produto" {
  name        = "produto-tg"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc_id

  health_check {
    path = "/health"
  }

  depends_on = [aws_lb.this]
}

resource "aws_lb_target_group" "auth" {
  name        = "auth-tg"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc_id

  health_check {
    path = "/health"
  }

  depends_on = [aws_lb.this]
}

################################################################################
# Listener
################################################################################

resource "aws_lb_listener" "this" {
  load_balancer_arn = aws_lb.this.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.producao.arn
    type             = "forward"
  }
}

resource "aws_lb_listener" "rabbit" {
  load_balancer_arn = aws_lb.this.arn
  port              = 5672
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.rabbitmq.arn
    type             = "forward"
  }
}

resource "aws_lb_listener_rule" "auth" {
  listener_arn = aws_lb_listener.this.arn

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.auth.arn
  }

  condition {
    path_pattern {
      values = ["/auth/*"]
    }
  }
}

resource "aws_lb_listener_rule" "notificacao" {
  listener_arn = aws_lb_listener.this.arn

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.notificacao.arn
  }

  condition {
    path_pattern {
      values = ["/notificacao/*"]
    }
  }
}

resource "aws_lb_listener_rule" "rabbitqmq_management" {
  listener_arn = aws_lb_listener.this.arn

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.rabbitqmq_management.arn
  }

  condition {
    path_pattern {
      values = ["/rabbitmanagement/*"]
    }
  }
}

resource "aws_lb_listener_rule" "pagamento" {
  listener_arn = aws_lb_listener.this.arn

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.pagamento.arn
  }

  condition {
    path_pattern {
      values = ["/pagamento/*"]
    }
  }
}

resource "aws_lb_listener_rule" "pedido" {
  listener_arn = aws_lb_listener.this.arn

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.pedido.arn
  }

  condition {
    path_pattern {
      values = ["/pedido/*"]
    }
  }
}

resource "aws_lb_listener_rule" "producao" {
  listener_arn = aws_lb_listener.this.arn

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.producao.arn
  }

  condition {
    path_pattern {
      values = ["/producao/*"]
    }
  }
}

resource "aws_lb_listener_rule" "produto" {
  listener_arn = aws_lb_listener.this.arn

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.produto.arn
  }

  condition {
    path_pattern {
      values = ["/produto/*"]
    }
  }
}
