data "aws_caller_identity" "current" {}

locals {
  selected_azs = slice(data.aws_availability_zones.available.names, 0, 2)

  subnet_config = merge(

    { for i, az in local.selected_azs : "public-${az}" => {
        cidr = cidrsubnet(var.vpc_cidr, 8, i + 1)
        az = az
        public = true
    }},

    { for i, az in local.selected_azs : "private-${az}" => {
      cidr = cidrsubnet(var.vpc_cidr, 8, i + 10)
      az = az
      public = false
    }}
  )

  public_subnets = { 
    for key, subnet in aws_subnet.main : key => subnet.id
    if subnet.tags.Tier == "public"
  }

  private_subnets = { 
    for key, subnet in aws_subnet.main : key => subnet.id
    if subnet.tags.Tier == "private"
  }

  service_ports = {
    "80" = "HTTP",
    "443" = "HTTPS"
  }

  db_maint_ports = {
    "HTTP" = {
      "port" = "80"
      "protocol" = "TCP"
    }

    "HTTPS" = {
      "port" = "443"
      "protocol" = "TCP"
    }

    "DNS" = {
      "port" = "53"
      "protocol" = "UDP"
    }
  }

  account_id = data.aws_caller_identity.current.account_id
}