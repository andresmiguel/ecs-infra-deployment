# ECS Application module

This module creates an ECS service and a task definition for a given application. It also creates a target group and
a listener rule for the application in an ALB.

### Considerations

- If multiple applications use the same ALB listener, the `alb_rule_priority` must be unique for each application.
- For the `dev` environment, we are using only the `FARGATE_SPOT` capacity provider. For the `prod` environment, we are
  using a mix of `FARGATE` and `FARGATE_SPOT` capacity providers.
- If the `enable_service_connect` variable is set to `true`,
  the [ECS Service Connect](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/service-connect.html)
  will be configured and the application will be available internally using this URL `http://<app-name>.internal:80`
- When the application is first created and there is no ECS Task Definition family for the application, it uses a
  default Docker image. (This is achieved using the `external.main_container_image` datasource)
- The ALB listener rule that is created for the application is based on the HTTP header `Host` and follows the pattern
  `<env>-<app-name>.<domain>`.

## Terraform Docs

This last part is generated using the `terraform-docs` [tool](https://terraform-docs.io). To update it, run the
following command from the project's root folder:

```shell
terraform-docs markdown table --output-file README.md ./terraform/modules/ecs-application
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.9 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 5.0 |
| <a name="provider_external"></a> [external](#provider\_external) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_appautoscaling_policy.ecs_cpu_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appautoscaling_policy) | resource |
| [aws_appautoscaling_policy.ecs_memory_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appautoscaling_policy) | resource |
| [aws_appautoscaling_target.ecs_target](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appautoscaling_target) | resource |
| [aws_ecs_service.api_service](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_service) | resource |
| [aws_ecs_task_definition.api_task](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_task_definition) | resource |
| [aws_lb_listener_rule.app_rule](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener_rule) | resource |
| [aws_lb_target_group.app_lb_tg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group) | resource |
| [aws_security_group.ecs_services](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |
| [external_external.main_container_image](https://registry.terraform.io/providers/hashicorp/external/latest/docs/data-sources/external) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_additional_ecs_service_sg_ids"></a> [additional\_ecs\_service\_sg\_ids](#input\_additional\_ecs\_service\_sg\_ids) | Additional security group IDs to attach to the ECS service | `list(string)` | `[]` | no |
| <a name="input_alb_arn"></a> [alb\_arn](#input\_alb\_arn) | The ARN of the load balancer | `string` | n/a | yes |
| <a name="input_alb_https_listener_arn"></a> [alb\_https\_listener\_arn](#input\_alb\_https\_listener\_arn) | The ARN of the HTTPS listener | `string` | n/a | yes |
| <a name="input_alb_rule_priority"></a> [alb\_rule\_priority](#input\_alb\_rule\_priority) | The priority of the ALB rule | `number` | n/a | yes |
| <a name="input_alb_security_group_id"></a> [alb\_security\_group\_id](#input\_alb\_security\_group\_id) | The security group ID for the ALB | `string` | n/a | yes |
| <a name="input_app_name"></a> [app\_name](#input\_app\_name) | The application name | `string` | n/a | yes |
| <a name="input_cpu"></a> [cpu](#input\_cpu) | The amount of CPU units to allocate to the task | `number` | `256` | no |
| <a name="input_domain"></a> [domain](#input\_domain) | The domain the service will use | `string` | n/a | yes |
| <a name="input_ecs_cluster_id"></a> [ecs\_cluster\_id](#input\_ecs\_cluster\_id) | The ECS cluster ID | `string` | n/a | yes |
| <a name="input_ecs_cluster_name"></a> [ecs\_cluster\_name](#input\_ecs\_cluster\_name) | The ECS cluster name | `string` | n/a | yes |
| <a name="input_enable_autoscaling"></a> [enable\_autoscaling](#input\_enable\_autoscaling) | Enable Auto Scaling for the ECS Service | `bool` | `false` | no |
| <a name="input_enable_service_connect"></a> [enable\_service\_connect](#input\_enable\_service\_connect) | Enable service connect as client only | `bool` | `false` | no |
| <a name="input_env"></a> [env](#input\_env) | The environment | `string` | `"dev"` | no |
| <a name="input_environment_variables"></a> [environment\_variables](#input\_environment\_variables) | List of environment variables for the main container | <pre>list(object({<br>    name  = string<br>    value = string<br>  }))</pre> | `[]` | no |
| <a name="input_memory"></a> [memory](#input\_memory) | The amount of memory to allocate to the task | `number` | `512` | no |
| <a name="input_port"></a> [port](#input\_port) | The port the application is running on | `number` | `80` | no |
| <a name="input_service_connect_namespace"></a> [service\_connect\_namespace](#input\_service\_connect\_namespace) | The namespace for service connect | `string` | `""` | no |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | Subnet IDs | `list(string)` | n/a | yes |
| <a name="input_task_count"></a> [task\_count](#input\_task\_count) | The number of tasks to run | `number` | `1` | no |
| <a name="input_task_execution_role_arn"></a> [task\_execution\_role\_arn](#input\_task\_execution\_role\_arn) | The ARN of the task execution role | `string` | n/a | yes |
| <a name="input_task_role_arn"></a> [task\_role\_arn](#input\_task\_role\_arn) | The ARN of the task role | `string` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | The VPC ID | `string` | n/a | yes |
| <a name="input_wait_steady_state"></a> [wait\_steady\_state](#input\_wait\_steady\_state) | Wait for the service to reach a steady state before completing | `bool` | `false` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
