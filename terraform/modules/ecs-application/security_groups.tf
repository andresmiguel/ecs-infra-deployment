resource "aws_security_group" "ecs_services" {
  description = "Security group for the ALB"
  name        = "${var.app_name}-ecs-service-sg"
  vpc_id      = var.vpc_id

  egress {
    from_port = 0
    to_port   = 0
    protocol  = -1
    cidr_blocks = [
      "0.0.0.0/0",
    ]
  }

  ingress {
    from_port = 8080
    to_port   = 8080
    protocol  = "tcp"
    security_groups = [var.alb_security_group_id]
  }
}
