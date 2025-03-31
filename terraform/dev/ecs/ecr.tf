#tfsec:ignore:aws-ecr-enforce-immutable-repository
resource "aws_ecr_repository" "ecs_service_init_setup" {
  name                 = "ecs-deployment-service-init-setup"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}
