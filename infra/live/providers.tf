terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.28.0"
    }

    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 5.23.0"
    }
  }

  required_version = "~> 1.14.0"
}

provider "aws" {
  region = var.aws_region
}

provider "cloudflare" {}