# ECS Deployment DEV infrastructure

This folder contains the infrastructure code for the ECS Deployment DEV environment.
It is organized using the following modules:

- [VPC](./dev-vpc): This module creates the VPC and needed resources like subnets, route tables, IGW, NATGW, etc.
- [ECS Cluster](./ecs): This module creates the ECS cluster.
- [LOAD BALANCER](./load_balancer): This module creates the ALB.
- [app_a](./app_a.tf): This file creates the app_a application that will be deployed to ECS. It uses the
  module [ecs-application](../modules/ecs-application).
- [app_b](./app_b.tf): This file creates the app_b application that will be deployed to ECS. It uses the
  module [ecs-application](../modules/ecs-application).

## How to add a new Application

- Add a new variable in the `dev/variables.tf` and `dev/services/variables.tf` files to enable/disable the application.
    - Follow the naming convention: `enable_<app_name>`, changing `-` for `_`.
- Add the value of the variable in the `dev/terraform.tfvars` file.
- Create a new file under the `dev` folder with the name `<app_name>.tf`, changing `-` for `_`.
- Add the resources needed for the application in the `<app_name>.tf` file.
    - Create a resource using the module `ecs-application`.
    - Use the `enable_<app_name>` variable to enable the application, using `count`.
    - Create an IAM Role for the application.
    - Create an ECR repository for the application.
    - You can copy the content from the `app_a.tf` file as a template and make the required modifications.
- After the new application is added, you need to run the following commands (or run it on the pipeline once it is set
  up):
    - `terraform init` to install the modules.
    - `terraform plan` to see the changes that will be applied.
    - `terraform apply` to apply the changes.
- Once the application is deployed (it will be using the start Docker image), you need to run the corresponding
  application pipeline to deploy the actual application to the ECS cluster.

## Terraform Docs

This last part is generated using the `terraform-docs` [tool](https://terraform-docs.io). To update it, run the
following command from the project's root folder:

```shell
terraform-docs markdown table --output-file README.md ./dev
```

<!-- BEGIN_TF_DOCS -->

## Requirements

| Name                                                                      | Version |
|---------------------------------------------------------------------------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.9  |
| <a name="requirement_aws"></a> [aws](#requirement\_aws)                   | ~> 5.66 |

## Providers

| Name                                              | Version |
|---------------------------------------------------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.90.0  |

## Modules

| Name                                                                          | Source                     | Version |
|-------------------------------------------------------------------------------|----------------------------|---------|
| <a name="module_app_a"></a> [app\_a](#module\_app\_a)                         | ../modules/ecs-application | n/a     |
| <a name="module_app_b"></a> [app\_b](#module\_app\_b)                         | ../modules/ecs-application | n/a     |
| <a name="module_ecs"></a> [ecs](#module\_ecs)                                 | ./ecs                      | n/a     |
| <a name="module_load_balancer"></a> [load\_balancer](#module\_load\_balancer) | ./load_balancer            | n/a     |
| <a name="module_vpc"></a> [vpc](#module\_vpc)                                 | ./dev-vpc                  | n/a     |

## Resources

| Name                                                                                                                                                                          | Type        |
|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-------------|
| [aws_ecr_repository.app_a](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_repository)                                                        | resource    |
| [aws_ecr_repository.app_b](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_repository)                                                        | resource    |
| [aws_iam_role.app_a_task_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role)                                                          | resource    |
| [aws_iam_role.app_b_task_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role)                                                          | resource    |
| [aws_iam_role.ecs_deployment_task_execution_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role)                                       | resource    |
| [aws_iam_role_policies_exclusive.app_a_task_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policies_exclusive)                    | resource    |
| [aws_iam_role_policies_exclusive.app_b_task_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policies_exclusive)                    | resource    |
| [aws_iam_role_policies_exclusive.ecs_deployment_task_execution_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policies_exclusive) | resource    |
| [aws_iam_role_policy.app_a_task_role_inline_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy)                              | resource    |
| [aws_iam_role_policy.app_b_task_role_inline_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy)                              | resource    |
| [aws_iam_role_policy.ecs_deployment_task_execution_role_inline_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy)           | resource    |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity)                                                 | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region)                                                                   | data source |

## Inputs

| Name                                                                                         | Description                                    | Type     | Default     | Required |
|----------------------------------------------------------------------------------------------|------------------------------------------------|----------|-------------|:--------:|
| <a name="input_aws_config_profile"></a> [aws\_config\_profile](#input\_aws\_config\_profile) | Name of the AWS SDK/CLI configuration profile  | `string` | `"default"` |    no    |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region)                           | The AWS region where resources will be created | `string` | n/a         |   yes    |
| <a name="input_cert_arn"></a> [cert\_arn](#input\_cert\_arn)                                 | The ARN of the ACM certificate                 | `string` | `""`        |    no    |
| <a name="input_domain"></a> [domain](#input\_domain)                                         | The domain the ECS services will use           | `string` | n/a         |   yes    |
| <a name="input_enable_app_a"></a> [enable\_app\_a](#input\_enable\_app\_a)                   | Enable App A                                   | `bool`   | `false`     |    no    |
| <a name="input_enable_app_b"></a> [enable\_app\_b](#input\_enable\_app\_b)                   | Enable App B                                   | `bool`   | `false`     |    no    |
| <a name="input_enable_lb"></a> [enable\_lb](#input\_enable\_lb)                              | Enable Load Balancer                           | `bool`   | `true`      |    no    |
| <a name="input_enable_nat_gw"></a> [enable\_nat\_gw](#input\_enable\_nat\_gw)                | Enable NAT Gateway                             | `bool`   | `true`      |    no    |

## Outputs

| Name                                                                       | Description             |
|----------------------------------------------------------------------------|-------------------------|
| <a name="output_alb_endpoint"></a> [alb\_endpoint](#output\_alb\_endpoint) | The DNS name of the ALB |

<!-- END_TF_DOCS -->
