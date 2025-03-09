resource "aws_nat_gateway" "nat_gw" {
  count = var.enable_nat_gw ? 1 : 0

  allocation_id = aws_eip.natgw_ip[0].id
  subnet_id     = aws_subnet.public_subnets["subnet1"].id

  tags = {
    Name = "${local.vpc_name}-ng"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.igw]
}

resource "aws_eip" "natgw_ip" {
  count = var.enable_nat_gw ? 1 : 0

  domain = "vpc"

  depends_on = [aws_internet_gateway.igw]
}
