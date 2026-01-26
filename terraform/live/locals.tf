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
}