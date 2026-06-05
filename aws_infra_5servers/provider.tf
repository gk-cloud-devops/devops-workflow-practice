terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Aws connection setup
provider "aws" {
  region = "ap-southeast-2"
}
