resource "aws_vpc_peering_connection" "ecs_default_pc" {
  count = var.rds_vpc_id != "" ? 1 : 0

  peer_vpc_id = var.rds_vpc_id
  vpc_id      = aws_vpc.dev_vpc.id
  auto_accept = true

  accepter {
    allow_remote_vpc_dns_resolution = true
  }

  requester {
    allow_remote_vpc_dns_resolution = false
  }

  tags = {
    "Name" = "${local.vpc_name}-default-pc"
  }
}
