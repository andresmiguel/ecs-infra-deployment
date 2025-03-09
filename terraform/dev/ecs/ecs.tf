resource "aws_ecs_cluster" "cluster" {
  name = local.ecs_cluster_name

  service_connect_defaults {
    namespace = aws_service_discovery_http_namespace.ecs_cluster.arn
  }
}

resource "aws_service_discovery_http_namespace" "ecs_cluster" {
  name        = local.ecs_cluster_name
  description = "${local.ecs_cluster_name} ECS Cluster Service Discovery"
}
