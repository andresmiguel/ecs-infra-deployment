#tfsec:ignore:aws-ec2-no-public-ingress-sgr
resource "aws_security_group" "alb" {
  description = "Security group for the ALB"
  name        = "ecs-deployment-dev-alb-sg"
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
    from_port = 80
    to_port   = 80
    protocol  = "tcp"
    cidr_blocks = [
      "0.0.0.0/0",
    ]
  }

  ingress {
    from_port = 443
    to_port   = 443
    protocol  = "tcp"
    cidr_blocks = [
      "0.0.0.0/0",
    ]
  }
}
