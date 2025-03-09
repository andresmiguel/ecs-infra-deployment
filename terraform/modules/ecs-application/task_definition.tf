resource "aws_ecs_task_definition" "api_task" {
  family       = var.app_name
  network_mode = "awsvpc"
  cpu          = var.cpu
  memory       = var.memory

  requires_compatibilities = ["FARGATE"]

  container_definitions = jsonencode([
    {
      name      = local.main_container_name
      image     = local.main_container_image != "" ? local.main_container_image : local.default_image
      essential = true

      portMappings = [
        {
          containerPort = var.port
          hostPort      = var.port
          name          = local.main_container_port_name
          protocol      = "tcp"
          appProtocol   = "http"
        }
      ]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-create-group  = "true"
          awslogs-group         = "/ecs/${var.env}-${var.app_name}"
          awslogs-region        = data.aws_region.current.name
          awslogs-stream-prefix = "ecs"
          max-buffer-size       = "25m"
          mode                  = "non-blocking"
        }
        secretOptions = []
      }

      environment = var.environment_variables

      environmentFiles = []
      mountPoints = []
      systemControls = []
      ulimits = []
      volumesFrom = []
    }
  ])

  runtime_platform {
    cpu_architecture        = "X86_64"
    operating_system_family = "LINUX"
  }

  execution_role_arn = var.task_execution_role_arn
  task_role_arn      = var.task_role_arn
}

data "external" "main_container_image" {
  program = ["bash", "${path.module}/fetch_container_image.sh"]

  query = {
    task_definition = var.app_name
    region          = data.aws_region.current.name
    container_name  = local.main_container_name
  }
}
