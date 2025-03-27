variable "vpc_id" {
  description = "The VPC ID"
  type        = string
}

variable "subnet_ids" {
  description = "Subnet IDs"
  type = list(string)
}

variable "alb_security_group_id" {
  description = "The security group ID for the ALB"
  type        = string
}

variable "ecs_cluster_id" {
  description = "The ECS cluster ID"
  type        = string
}

variable "ecs_cluster_name" {
  description = "The ECS cluster name"
  type        = string
}

variable "alb_arn" {
  description = "The ARN of the load balancer"
  type        = string
}

variable "env" {
  description = "The environment"
  type        = string
  default     = "dev"
}

variable "app_name" {
  description = "The application name"
  type        = string
}

variable "port" {
  description = "The port the application is running on"
  type        = number
  default     = 80
}

variable "task_execution_role_arn" {
  description = "The ARN of the task execution role"
  type        = string
}

variable "task_role_arn" {
  description = "The ARN of the task role"
  type        = string
}

variable "cpu" {
  description = "The amount of CPU units to allocate to the task"
  type        = number
  default     = 256
}

variable "memory" {
  description = "The amount of memory to allocate to the task"
  type        = number
  default     = 512
}

variable "task_count" {
  description = "The number of tasks to run"
  type        = number
  default     = 1
}

variable "alb_http_listener_arn" {
  description = "The ARN of the HTTP/HTTPS listener"
  type        = string
}

variable "alb_rule_priority" {
  description = "The priority of the ALB rule"
  type        = number
}

variable "domain" {
  description = "The domain the service will use"
  type        = string
}

variable "additional_ecs_service_sg_ids" {
  description = "Additional security group IDs to attach to the ECS service"
  type = list(string)
  default = []
}

variable "enable_service_connect" {
  description = "Enable service connect as client only"
  type        = bool
  default     = false
}

variable "service_connect_namespace" {
  description = "The namespace for service connect"
  type        = string
  default     = ""

  validation {
    condition     = length(var.service_connect_namespace) > 0 || !var.enable_service_connect
    error_message = "service_connect_namespace must be set if enable_service_connect is true"
  }
}

variable "wait_steady_state" {
  description = "Wait for the service to reach a steady state before completing"
  type        = bool
  default     = false
}

variable "enable_autoscaling" {
  description = "Enable Auto Scaling for the ECS Service"
  type        = bool
  default     = false
}

variable "environment_variables" {
  description = "List of environment variables for the main container"
  type = list(object({
    name  = string
    value = string
  }))
  default = []
}

variable "ecs_default_image" {
  description = "The default image to use for the ECS task when it is first created"
  type        = string
}
