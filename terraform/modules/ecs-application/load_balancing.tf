resource "aws_alb_target_group" "app_lb_tg" {
  name = substr("${var.env}-ecs-${var.app_name}-tg", 0, 32)

  port              = 80
  protocol          = "HTTP"
  vpc_id            = var.vpc_id
  target_type       = "ip"
  protocol_version  = "HTTP1"
  proxy_protocol_v2 = false
}

resource "aws_alb_listener_rule" "app_rule" {
  listener_arn = var.alb_http_listener_arn
  priority     = var.alb_rule_priority

  action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.app_lb_tg.arn
  }

  condition {
    host_header {
      // the regex is to remove the leading dot from the domain
      values = ["${var.env}-${var.app_name}.${replace(var.domain, "/^\\./", "")}"]
    }
  }

  tags = {
    Name = "${var.env}-${var.app_name}-rule"
  }
}
