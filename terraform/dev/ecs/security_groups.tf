#tfsec:ignore:aws-ec2-no-public-egress-sgr
resource "aws_security_group" "ecs_internal_comm" {
  description = "Allows ECS cluster services internal communication"
  name        = "${local.ecs_cluster_name}-ecs-internal-comm-sg"
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
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    self        = true
    description = "Self reference"
  }
}
