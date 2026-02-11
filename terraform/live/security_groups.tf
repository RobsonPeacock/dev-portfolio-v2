resource "aws_security_group" "web" {
  name = "Web SG"
  description = "Security group for public-facing internet traffic (HTTP/HTTPS)"
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "web-sg"
  }
}

resource "aws_security_group" "database" {
  name = "Database SG"
  description = "Isolated security group for backend database tier"
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "database-sg"
  }
}

resource "aws_security_group" "ssh_access" {
  name = "SSH Access SG"
  description = "Provides SSH access to backend tier"
  count = var.enable_ssh_access ? 1 : 0
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "ssh-access-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "service_rules" {
  for_each = local.service_ports
  security_group_id = aws_security_group.web.id

  from_port = each.key
  to_port = each.key
  ip_protocol = "tcp"
  description = each.value
  cidr_ipv4 = "0.0.0.0/0"
}

resource "aws_vpc_security_group_ingress_rule" "web_ssh_rule" {
  security_group_id = aws_security_group.web.id
  count = var.enable_ssh_access ? 1 : 0

  from_port = 22
  to_port = 22
  ip_protocol = "tcp"
  description = "SSH"
  referenced_security_group_id = aws_security_group.ssh_access[count.index].id
}

resource "aws_vpc_security_group_ingress_rule" "database_rules" {
  security_group_id = aws_security_group.database.id

  from_port = 5432
  to_port = 5432
  ip_protocol = "tcp"
  referenced_security_group_id = aws_security_group.database.id
}

resource "aws_vpc_security_group_ingress_rule" "db_ssh_ingress_rule" {
  security_group_id = aws_security_group.database.id
  count = var.enable_ssh_access ? 1 : 0

  from_port = 22
  to_port = 22
  ip_protocol = "tcp"
  referenced_security_group_id = aws_security_group.ssh_access[count.index].id
}

resource "aws_vpc_security_group_egress_rule" "allow_all_outbound" {
  security_group_id = aws_security_group.web.id

  ip_protocol = "-1"
  cidr_ipv4 = "0.0.0.0/0"
}

resource "aws_vpc_security_group_egress_rule" "web_ssh_egress_rule" {
  security_group_id = aws_security_group.ssh_access[count.index].id
  count = var.enable_ssh_access ? 1 : 0

  from_port = 22
  to_port = 22
  ip_protocol = "tcp"
  cidr_ipv4 = aws_subnet.main["public-${var.aws_region}a"].cidr_block
}

resource "aws_vpc_security_group_egress_rule" "db_ssh_egress_rule" {
  security_group_id = aws_security_group.ssh_access[count.index].id
  count = var.enable_ssh_access ? 1 : 0

  from_port = 22
  to_port = 22
  ip_protocol = "tcp"
  cidr_ipv4 = aws_subnet.main["private-${var.aws_region}a"].cidr_block
}