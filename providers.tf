terraform {
  required_version = "~> 1.9.7"

  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 3.74.3"
      # version = "~> 4.2.0"
    }
  }

  backend "s3" {
    bucket = "marcbacchidev-terraform"
    key = "prod/terraform.tfstate"
    region = "us-east-1"
  }
}

provider "aws" {
  region = "us-east-1"
}

provider "aws" {
  alias = "acm_provider"
  region = "us-east-1"
}