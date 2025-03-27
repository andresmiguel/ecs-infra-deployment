resource "aws_iam_role" "ecs_deployment_task_execution_role" {
  name        = "${local.env}-ecs-deployment-task-execution-role"
  description = "IAM Role for ECS-Deployment ECS execution task roles."

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy" "ecs_deployment_task_execution_role_inline_policy" {
  name = "${local.env}-ecs-deployment-task-execution-role-inline-policy"
  role = aws_iam_role.ecs_deployment_task_execution_role.name

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Resource = "*",
        Action = [
          "ecr:GetAuthorizationToken",
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:CreateLogGroup",
        ],
      }
    ]
  })
}

resource "aws_iam_role_policies_exclusive" "ecs_deployment_task_execution_role" {
  role_name = aws_iam_role.ecs_deployment_task_execution_role.name
  policy_names = [aws_iam_role_policy.ecs_deployment_task_execution_role_inline_policy.name]
}
