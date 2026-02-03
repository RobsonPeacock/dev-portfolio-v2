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

  tags = {
    Name = "dev-portfolio-web-instance"
  }
}