resource "aws_route53_record" "api_service" {
  count = var.create_dns_record ? 1 : 0

  zone_id = data.aws_route53_zone.selected.zone_id
  name    = local.hostname
  type    = "A"

  alias {
    name                   = data.aws_alb.main.dns_name
    zone_id                = data.aws_alb.main.zone_id
    evaluate_target_health = false
  }
}

data "aws_alb" "main" {
  arn = var.alb_arn
}

data "aws_route53_zone" "selected" {
  name = var.domain
}
