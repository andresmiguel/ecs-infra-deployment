terraform {
  required_version = "~> 1.9"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.66"
    }
  }
}

data "aws_caller_identity" "current" {}

data "aws_region" "current" {}
