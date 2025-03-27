variable "vpc_id" {
  description = "The VPC ID"
  type        = string
}

variable "subnet_ids" {
  description = "Subnet IDs"
  type = list(string)
}

variable "enable_lb" {
  description = "Enable the load balancer"
  type        = bool
  default     = true
}

variable "cert_arn" {
  default     = ""
  description = "The ARN of the ACM certificate"
  type        = string
}
