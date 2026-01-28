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

resource "aws_internet_gateway" "internet_gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "main-portfolio-igw"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gw.id
  }

  tags = {
    Name = "portfolio-public-route-table"
  }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "portfolio-private-route-table"
  }
}

resource "aws_route_table_association" "public" {
  for_each = tomap(local.public_subnets)

  subnet_id = each.value
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private" {
  for_each = tomap(local.private_subnets)

  subnet_id = each.value
  route_table_id = aws_route_table.private.id
}