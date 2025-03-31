#tfsec:ignore:aws-elb-alb-not-public
resource "aws_lb" "alb" {
  count = var.enable_lb ? 1 : 0

  name               = "ecs-deployment-alb"
  internal           = false
  load_balancer_type = "application"
  subnets            = var.subnet_ids

  security_groups = [aws_security_group.alb.id]

  drop_invalid_header_fields = true

  enable_deletion_protection = false
}

resource "aws_lb_listener" "alb_redirect_listener_http" {
  count = var.enable_lb && var.cert_arn != "" ? 1 : 0

  load_balancer_arn = aws_lb.alb[0].arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb_listener" "alb_listener_https" {
  count = var.enable_lb && var.cert_arn != "" ? 1 : 0

  load_balancer_arn = aws_lb.alb[0].arn
  port              = "443"
  protocol          = "HTTPS"
  certificate_arn   = var.cert_arn

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      status_code  = "404"
    }
  }
}

#tfsec:ignore:aws-elb-http-not-used
resource "aws_lb_listener" "alb_listener_http" {
  count = var.enable_lb && var.cert_arn == "" ? 1 : 0

  load_balancer_arn = aws_lb.alb[0].arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      status_code  = "404"
    }
  }
}
