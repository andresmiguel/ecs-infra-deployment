variable "enable_nat_gw" {
  default     = true
  description = "Enable the creation of a NAT Gateway"
  type        = bool
}

variable "rds_vpc_id" {
  default     = ""
  description = "The VPC ID where the RDS instance is in"
  type        = string
}
