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

resource "aws_vpc_security_group_ingress_rule" "service_rules" {
  for_each = local.service_ports
  security_group_id = aws_security_group.web.id

  from_port = each.key
  to_port = each.key
  ip_protocol = "tcp"
  description = each.value
  cidr_ipv4 = "0.0.0.0/0"
}

resource "aws_vpc_security_group_ingress_rule" "database_rules" {
  security_group_id = aws_security_group.database.id

  from_port = 5432
  to_port = 5432
  ip_protocol = "tcp"
  referenced_security_group_id = aws_security_group.database.id
}

resource "aws_vpc_security_group_egress_rule" "allow_all_outbound" {
  security_group_id = aws_security_group.web.id

  ip_protocol = "-1"
  cidr_ipv4 = "0.0.0.0/0"
}