# ECS Deployment

This approach sets up infrastructure for deploying applications to AWS ECS (Elastic Container Service). It uses
Terraform to manage the infrastructure and GitHub Actions to deploy the applications. The goal is to make it easy to add
new applications by following a clearly defined process.

It is organized as follows:

- [GitHb Actions Workflows](./.github/workflows): This folder contains the GitHub Actions workflows for deploying the
  applications.
- [SRC](./src): This folder contains the source code for the applications. It is organized by application.
    - [app-a](./src/app-a): This folder contains the source code for the app-a application.
    - [app-b](./src/app-b): This folder contains the source code for the app-b application.
    - [ecs-deployment-service-init-setup](./src/ecs-deployment-service-init-setup): This folder contains the source code
      for the image that is used when first creating an ECS application.
- [Terraform](./terraform): This folder contains the Terraform code for creating the infrastructure. It is organized by
  environment and modules
    - [DEV](./terraform/dev): This folder contains the infrastructure code for the DEV environment.
    - [Modules](./terraform/modules): This folder contains the modules used by the environments.
- [tfsec.yml](./tfsec.yml): This file contains the configuration for tfsec, a static analysis tool for Terraform code.

## GitHub Actions Workflows

### ECS deployment

We have a GitHub Actions reusable workflow to deploy the applications to ECS. For each application we have a workflow
that uses the reusable workflow to deploy the application. The reusable workflow is defined in the
[.github/workflows/deploy-to-ecs.yml](./.github/workflows/deploy-to-ecs.yml) file. You need to pass the parameters and
the secrets to the reusable workflow. The only secret needed is `AWS_ROLE`. The role needs to be able to connect to
GitHub Actions (see
this [link](https://aws.amazon.com/blogs/security/use-iam-roles-to-connect-github-actions-to-actions-in-aws/)). The
permissions needed are:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ecs:RegisterTaskDefinition",
        "ecs:DeregisterTaskDefinition",
        "ecs:DescribeTaskDefinition",
        "ecs:ListTaskDefinitions",
        "ecs:UpdateService",
        "ecs:DescribeServices",
        "ecs:DescribeClusters",
        "ecs:CreateService",
        "ecs:DeleteService",
        "ecs:ListServices",
        "ecs:ListClusters",
        "ecs:RunTask",
        "ecs:StopTask",
        "ecs:DescribeTasks"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "iam:PassRole"
      ],
      "Resource": [
        "arn:aws:iam::<AWS_ACCOUNT_ID>:role/<TASK_EXECUTION_ROLE>",
        "arn:aws:iam::<AWS_ACCOUNT_ID>:role/<TASK_ROLE>"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "ecr:GetAuthorizationToken",
        "ecr:BatchCheckLayerAvailability",
        "ecr:GetDownloadUrlForLayer",
        "ecr:BatchGetImage",
        "ecr:PutImage",
        "ecr:InitiateLayerUpload",
        "ecr:UploadLayerPart",
        "ecr:CompleteLayerUpload",
        "ecr:DescribeRepositories",
        "ecr:CreateRepository"
      ],
      "Resource": "*"
    }
  ]
}
```

### TFSec scan

We also have a GitHub Actions workflow to run TFSec on the Terraform code. This workflow is defined in the
[.github/workflows/tfsec.yml](./.github/workflows/tfsec.yml) file.
