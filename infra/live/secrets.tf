resource "aws_ssm_parameter" "db_name" {
  name  = "/prod/backend/dev_portfolio_db_name"
  type  = "SecureString"
  value = "change_me"

  lifecycle {
    ignore_changes = [value]
  }
}

resource "aws_ssm_parameter" "db_username" {
  name  = "/prod/backend/dev_portfolio_db_username"
  type  = "SecureString"
  value = "change_me"

  lifecycle {
    ignore_changes = [value]
  }
}

resource "aws_ssm_parameter" "db_password" {
  name  = "/prod/backend/dev_portfolio_db_password"
  type  = "SecureString"
  value = "change_me"

  lifecycle {
    ignore_changes = [value]
  }
}

resource "aws_ssm_parameter" "pg_user" {
  name  = "/prod/backend/dev_portfolio_pg_user"
  type  = "SecureString"
  value = "change_me"

  lifecycle {
    ignore_changes = [value]
  }
}

resource "aws_ssm_parameter" "pg_password" {
  name  = "/prod/backend/dev_portfolio_pg_password"
  type  = "SecureString"
  value = "change_me"

  lifecycle {
    ignore_changes = [value]
  }
}

resource "aws_ssm_parameter" "db_host" {
  name  = "/prod/backend/dev_portfolio_db_host"
  type  = "String"
  value = "change_me"

  lifecycle {
    ignore_changes = [value]
  }
}

resource "aws_ssm_parameter" "rails_master_key" {
  name  = "/prod/backend/dev_portfolio_rails_master_key"
  type  = "SecureString"
  value = "change_me"

  lifecycle {
    ignore_changes = [value]
  }
}

resource "aws_ssm_parameter" "allowed_origin" {
  name = "/prod/backend/allowed_origin"
  type  = "SecureString"
  value = "change_me"

  lifecycle {
    ignore_changes = [value]
  }
}