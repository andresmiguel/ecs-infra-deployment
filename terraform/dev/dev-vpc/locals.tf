locals {
  vpc_name       = "ecs-deployment-dev"
  vpc_cidr_block = "10.32.0.0/16"

  az_1 = data.aws_availability_zones.available.names[0]
  az_2 = data.aws_availability_zones.available.names[1]
  az_3 = data.aws_availability_zones.available.names[2]

  public_subnets = {
    "subnet1" = { cidr_block = "10.32.0.0/24", az = local.az_1, name = "${local.vpc_name}-public-subnet-1" },
    "subnet2" = { cidr_block = "10.32.1.0/24", az = local.az_2, name = "${local.vpc_name}-public-subnet-2" },
    "subnet3" = { cidr_block = "10.32.2.0/24", az = local.az_3, name = "${local.vpc_name}-public-subnet-3" },
  }

  private_subnets = {
    "subnet1" = { cidr_block = "10.32.10.0/24", az = local.az_1, name = "${local.vpc_name}-private-subnet-1" },
    "subnet2" = { cidr_block = "10.32.11.0/24", az = local.az_2, name = "${local.vpc_name}-private-subnet-2" },
    "subnet3" = { cidr_block = "10.32.12.0/24", az = local.az_3, name = "${local.vpc_name}-private-subnet-3" },
  }
}
