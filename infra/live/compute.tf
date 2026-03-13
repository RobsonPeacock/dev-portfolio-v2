data "aws_ami" "ubuntu_ami" {
  most_recent = true

  filter {
    name = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-arm64-server-*"]
  }

  filter {
    name = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name = "root-device-type"
    values = ["ebs"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "dev_portfolio_web_instance" {
  ami = data.aws_ami.ubuntu_ami.id
  instance_type = "t4g.small"
  iam_instance_profile = aws_iam_instance_profile.ec2_app_profile.id
  subnet_id = aws_subnet.main["public-${var.aws_region}a"].id
  vpc_security_group_ids = [aws_security_group.web.id]

  user_data = templatefile("${path.module}/scripts/web_setup.sh", {
                aws_region = var.aws_region
                account_id = local.account_id
                ruby_version = local.ruby_version
                ecr_base_url = local.ecr_base_url
              })

  tags = {
    Name = "dev-portfolio-web-instance"
  }
}

resource "aws_instance" "dev_portfolio_db_instance" {
  ami = data.aws_ami.ubuntu_ami.id
  instance_type = "t4g.small"
  iam_instance_profile = aws_iam_instance_profile.ec2_app_profile.id
  subnet_id = aws_subnet.main["private-${var.aws_region}a"].id
  vpc_security_group_ids = [aws_security_group.database.id]

  user_data = templatefile("${path.module}/scripts/db_setup.sh", {
                aws_region = var.aws_region
                account_id = local.account_id
                ecr_base_url = local.ecr_base_url
              })

  tags = {
    Name = "dev-portfolio-db-instance"
  }
}

resource "aws_ec2_instance_connect_endpoint" "backend_eic_endpoint" {
  subnet_id = aws_subnet.main["private-${var.aws_region}a"].id
  security_group_ids = [aws_security_group.ssh_access[count.index].id]
  count = var.enable_ssh_access ? 1 : 0
}