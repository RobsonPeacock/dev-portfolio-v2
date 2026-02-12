resource "aws_ssm_parameter" "db_name" {
  name = "/prod/backend/dev-portfolio-db-name"
  type = "SecureString"
  value = "change_me"

  lifecycle {
    ignore_changes = [value]
  }
}

resource "aws_ssm_parameter" "db_username" {
  name = "/prod/backend/dev-portfolio-db-username"
  type = "SecureString"
  value = "change_me"

  lifecycle {
    ignore_changes = [value]
  }
}

resource "aws_ssm_parameter" "db_password" {
  name = "/prod/backend/dev-portfolio-db-password"
  type = "SecureString"
  value = "change_me"

  lifecycle {
    ignore_changes = [value]
  }
}