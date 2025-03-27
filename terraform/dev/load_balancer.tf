module "load_balancer" {
  source = "./load_balancer"

  vpc_id   = module.vpc.vpc.id
  cert_arn = var.cert_arn

  subnet_ids = [for subnet in module.vpc.public_subnets : subnet.id]

  enable_lb = var.enable_lb
}
