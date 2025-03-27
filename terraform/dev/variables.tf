variable "aws_config_profile" {
  default     = "default"
  description = "Name of the AWS SDK/CLI configuration profile"
  type        = string
}

variable "aws_region" {
  description = "The AWS region where resources will be created"
  type        = string
}

variable "enable_nat_gw" {
  default     = true
  description = "Enable NAT Gateway"
  type        = bool
}

variable "enable_lb" {
  default     = true
  description = "Enable Load Balancer"
  type        = bool
}

variable "domain" {
  description = "The domain the ECS services will use"
  type        = string
}

variable "cert_arn" {
  default     = ""
  description = "The ARN of the ACM certificate"
  type        = string
}

variable "enable_app_a" {
  default     = false
  description = "Enable App A"
  type        = bool
}
