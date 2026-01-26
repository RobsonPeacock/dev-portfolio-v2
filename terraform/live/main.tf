resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true

  tags = {
    Name = "main-portfolio-vpc"
  }
}

variable "vpc_cidr" {
  type = string
  default = "10.0.0.0/16"
}

data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_subnet" "main" {
  for_each = local.subnet_config

  vpc_id = aws_vpc.main.id
  cidr_block = each.value.cidr
  availability_zone = each.value.az
  map_public_ip_on_launch = each.value.public

  tags = {
    Name = "portfolio-${each.key}"
    Tier = each.value.public ? "public" : "private"
  }
}