resource "aws_security_group" "http" {
	description = "Permit incoming HTTP traffic"
	name = "http"
	vpc_id = "${var.vpc_id}"

	ingress {
		cidr_blocks = ["0.0.0.0/0"]
		from_port = 80
		protocol = "TCP"
		to_port = 80
	}
}
resource "aws_security_group" "https" {
	description = "Permit incoming HTTPS traffic"
	name = "https"
	vpc_id = "${var.vpc_id}"

	ingress {
		cidr_blocks = ["0.0.0.0/0"]
		from_port = 443
		protocol = "TCP"
		to_port = 443
	}
}
resource "aws_security_group" "egress_all" {
	description = "Permit all outgoing traffic"
	name = "egress-all"
	vpc_id = "${var.vpc_id}"

	egress {
		cidr_blocks = ["0.0.0.0/0"]
		from_port = 0
		protocol = "-1"
		to_port = 0
	}
}

resource "aws_security_group" "ingress_api" {
	description = "Permit some incoming traffic"
	name = "ingress-esc-service"
	vpc_id = "${var.vpc_id}"

	ingress {
		cidr_blocks = ["0.0.0.0/0"]
		from_port = 80
		protocol = "TCP"
		to_port = 80
	}
}

resource "aws_lb" "this" {
	load_balancer_type = "application"

	security_groups = [
		aws_security_group.egress_all.id,
		aws_security_group.http.id,
		aws_security_group.https.id,
	]

	subnets = "${var.public_subnets_id}"
}
resource "aws_lb_target_group" "this" {
	port = 80
	protocol = "HTTP"
	target_type = "ip"
	vpc_id = "${var.vpc_id}"

	depends_on = [aws_lb.this]
}
resource "aws_lb_listener" "this" {
	load_balancer_arn = aws_lb.this.arn
	port = 80
	protocol = "HTTP"

	default_action {
		target_group_arn = aws_lb_target_group.this.arn
		type = "forward"
	}
}