resource "aws_subnet" "public_subnets" {
  for_each = tomap(local.public_subnets)

  vpc_id            = aws_vpc.dev_vpc.id
  cidr_block        = each.value.cidr_block
  availability_zone = each.value.az

  tags = {
    Name = each.value.name
  }
}

resource "aws_subnet" "private_subnets" {
  for_each = tomap(local.private_subnets)

  vpc_id            = aws_vpc.dev_vpc.id
  cidr_block        = each.value.cidr_block
  availability_zone = each.value.az

  map_public_ip_on_launch = false

  tags = {
    Name = each.value.name
  }
}
