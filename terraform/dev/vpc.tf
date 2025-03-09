module "vpc" {
  source = "./dev-vpc"

  enable_nat_gw = var.enable_nat_gw
}
