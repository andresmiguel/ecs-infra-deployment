module "ecs" {
  source = "./ecs"

  vpc_id = module.vpc.vpc.id
}
