locals {
  main_container_name      = "main"
  main_container_image     = data.external.main_container_image.result.container_image
  main_container_port_name = "${local.main_container_name}-${var.port}-tcp"
  internal_discovery_name  = "${var.app_name}-internal"
  internal_dns_name = "${var.app_name}.internal"
  // the regex is to remove the leading dot from the domain
  hostname                 = "${var.env}-${var.app_name}.${replace(var.domain, "/^\\./", "")}"

  capacity_provider_strategy = var.env == "dev" ? [
    {
      capacity_provider = "FARGATE_SPOT"
      weight            = 100
    }
  ] : [
    {
      capacity_provider = "FARGATE_SPOT"
      weight            = 50
    },
    {
      capacity_provider = "FARGATE"
      weight            = 50
      base              = 1
    }
  ]
}
