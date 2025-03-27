resource "aws_ecs_service" "api_service" {
  name             = var.app_name
  cluster          = var.ecs_cluster_id
  platform_version = "LATEST"

  task_definition = aws_ecs_task_definition.api_task.arn
  desired_count   = var.task_count

  availability_zone_rebalancing = "ENABLED"
  enable_ecs_managed_tags       = true
  wait_for_steady_state         = var.wait_steady_state

  dynamic "load_balancer" {
    for_each = var.alb_arn != "" ? [aws_alb_target_group.app_lb_tg] : []

    content {
      container_name   = "main"
      container_port   = 8080
      target_group_arn = load_balancer.value.arn
    }
  }

  dynamic "capacity_provider_strategy" {
    for_each = local.capacity_provider_strategy
    content {
      capacity_provider = capacity_provider_strategy.value.capacity_provider
      weight            = capacity_provider_strategy.value.weight
      base = lookup(capacity_provider_strategy.value, "base", null)
    }
  }

  network_configuration {
    assign_public_ip = false
    security_groups = concat(
      [aws_security_group.ecs_services.id],
      var.additional_ecs_service_sg_ids
    )
    subnets = var.subnet_ids
  }

  deployment_circuit_breaker {
    enable   = true
    rollback = true
  }

  deployment_controller {
    type = "ECS"
  }

  force_new_deployment = true

  dynamic service_connect_configuration {
    for_each = var.enable_service_connect ? [1] : []

    content {
      enabled   = true
      namespace = var.service_connect_namespace

      service {
        port_name = local.main_container_port_name
        client_alias {
          dns_name = local.internal_dns_name
          port     = 80
        }
        discovery_name = local.internal_discovery_name
      }
    }
  }
}
