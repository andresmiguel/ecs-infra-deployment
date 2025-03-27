locals {
  env = "dev"

  ecs_default_image = "${data.aws_caller_identity.current.account_id}.dkr.ecr.us-east-1.amazonaws.com/ecs-deployment-service-init-setup:latest"
}
