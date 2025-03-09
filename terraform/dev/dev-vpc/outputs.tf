output "vpc" {
  description = "The dev VPC"
  value       = aws_vpc.dev_vpc
}

output "public_subnets" {
  description = "The public subnets of the VPC"
  value       = aws_subnet.public_subnets
}

output "private_subnets" {
  description = "The private subnets of the VPC"
  value       = aws_subnet.private_subnets
}
