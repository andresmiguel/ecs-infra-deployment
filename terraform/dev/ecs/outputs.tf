output "ecs_cluster" {
  value       = aws_ecs_cluster.cluster
  description = "The ECS cluster"
}

output "ecs_internal_comm_sg_id" {
  value       = aws_security_group.ecs_internal_comm.id
  description = "The security group ID for internal communication within the ECS cluster"
}

output "service_discovery_namespace" {
  value       = aws_service_discovery_http_namespace.ecs_cluster.name
  description = "The service discovery namespace for the ECS cluster"
}
