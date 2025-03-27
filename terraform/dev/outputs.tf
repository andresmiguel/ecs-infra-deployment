output "alb_endpoint" {
  value       = module.load_balancer.alb_dns
  description = "The DNS name of the ALB"
}
