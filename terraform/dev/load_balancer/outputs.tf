output "alb_security_group" {
  value       = aws_security_group.alb
  description = "The security group of the ALB"
}

output "alb_arn" {
  value       = length(aws_lb.alb) > 0 ? aws_lb.alb[0].arn : ""
  description = "The ARN of the ALB"
}

output "alb_dns" {
  value       = length(aws_lb.alb) > 0 ? aws_lb.alb[0].dns_name : ""
  description = "The DNS name of the ALB"
}

output "alb_https_listener_arn" {
  value       = length(aws_lb_listener.alb_listener_https) > 0 ? aws_lb_listener.alb_listener_https[0].arn : ""
  description = "The ARN of the HTTPS listener"
}

output "alb_http_listener_arn" {
  value       = length(aws_lb_listener.alb_listener_http) > 0 ? aws_lb_listener.alb_listener_http[0].arn : ""
  description = "The ARN of the HTTP listener"
}
