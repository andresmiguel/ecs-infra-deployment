resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.dev_vpc.id

  tags = {
    Name = "${local.vpc_name}-igw"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.dev_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "${local.vpc_name}-public-rt"
  }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.dev_vpc.id

  dynamic "route" {
    for_each = var.enable_nat_gw ? [0] : []

    content {
      cidr_block     = "0.0.0.0/0"
      nat_gateway_id = aws_nat_gateway.nat_gw[0].id
    }
  }

  dynamic "route" {
    for_each = var.rds_vpc_id != "" ? [0] : []

    content {
      cidr_block                = data.aws_vpc.rds_vpc[0].cidr_block
      vpc_peering_connection_id = aws_vpc_peering_connection.ecs_default_pc[0].id
    }
  }

  tags = {
    Name = "${local.vpc_name}-private-rt"
  }
}

resource "aws_route_table_association" "public_subnets" {
  for_each = aws_subnet.public_subnets

  subnet_id      = each.value.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private_subnets" {
  for_each = aws_subnet.private_subnets

  subnet_id      = each.value.id
  route_table_id = aws_route_table.private.id
}

data "aws_vpc" "rds_vpc" {
  count = var.rds_vpc_id != "" ? 1 : 0

  id = var.rds_vpc_id
}
