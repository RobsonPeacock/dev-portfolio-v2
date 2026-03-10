resource "aws_iam_role" "app_role" {
  name = "dev-portfolio-app-role"
  description = <<-EOT
    Allows EC2 instances to pull container images 
    from ECR and access required AWS services for the 
    application tier.
  EOT
  assume_role_policy = data.aws_iam_policy_document.ec2_trust_policy.json
}

data "aws_iam_policy_document" "ec2_trust_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "attach_app_role_policy" {
  role = aws_iam_role.app_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

resource "aws_iam_instance_profile" "ec2_app_profile" {
  name = "dev-portfolio-ec2-app-profile"
  role = aws_iam_role.app_role.name

  tags = {
    Project = "dev-portfolio"
  }
}

resource "aws_iam_policy" "ssm_policy" {
  name = "ssm-access-policy"
  description = "Provides access to SSM parameters"
  policy = data.aws_iam_policy_document.ssm_policy_document.json
}

data "aws_iam_policy_document" "ssm_policy_document" {
  statement {
    actions = [
      "ssm:GetParameter",
      "ssm:GetParametersByPath"
    ]

    resources = [
      "arn:aws:ssm:${var.aws_region}:${local.account_id}:parameter/prod/backend"
    ]
  }

  statement {
    actions = [
      "ssm:PutParameter"
    ]

    resources = [
      "arn:aws:ssm:${var.aws_region}:${local.account_id}:parameter/prod/backend/*"
    ]
  }
}

resource "aws_iam_role_policy_attachment" "attach_ssm_policy" {
  role = aws_iam_role.app_role.name
  policy_arn = aws_iam_policy.ssm_policy.arn
}