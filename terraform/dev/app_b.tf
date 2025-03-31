module "app_b" {
  source = "../modules/ecs-application"

  count = var.enable_app_b ? 1 : 0

  app_name                = "app-b"
  alb_arn                 = module.load_balancer.alb_arn
  alb_security_group_id   = module.load_balancer.alb_security_group.id
  ecs_cluster_id          = module.ecs.ecs_cluster.id
  ecs_cluster_name        = module.ecs.ecs_cluster.name
  vpc_id                  = module.vpc.vpc.id
  task_execution_role_arn = aws_iam_role.ecs_deployment_task_execution_role.arn
  task_role_arn           = aws_iam_role.app_b_task_role.arn
  port                    = 8080
  alb_http_listener_arn   = module.load_balancer.alb_https_listener_arn
  alb_rule_priority       = 200

  enable_service_connect    = true
  service_connect_namespace = module.ecs.service_discovery_namespace

  subnet_ids = [for subnet in module.vpc.private_subnets : subnet.id]

  additional_ecs_service_sg_ids = [module.ecs.ecs_internal_comm_sg_id]

  enable_autoscaling = false
  domain             = var.domain
  create_dns_record  = true
  ecs_default_image  = local.ecs_default_image
}

resource "aws_iam_role" "app_b_task_role" {
  name        = "${local.env}-app-b-task-role"
  description = "IAM Role for AppA ECS tasks."

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })
}

#tfsec:ignore:aws-iam-no-policy-wildcards
resource "aws_iam_role_policy" "app_b_task_role_inline_policy" {
  name = "${local.env}-app-b-task-role-inline-policy"
  role = aws_iam_role.app_b_task_role.name

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Resource = "*",
        Action = [
          "ssm:GetParameters",
          "ssm:GetParameter",
          "ssm:GetParametersByPath",
        ],
      }
    ]
  })
}

resource "aws_iam_role_policies_exclusive" "app_b_task_role" {
  role_name = aws_iam_role.app_b_task_role.name
  policy_names = [aws_iam_role_policy.app_b_task_role_inline_policy.name]
}

#tfsec:ignore:aws-ecr-enforce-immutable-repository
resource "aws_ecr_repository" "app_b" {
  name                 = "${local.env}-app-b"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}
