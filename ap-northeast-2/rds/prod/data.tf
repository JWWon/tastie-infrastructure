data "aws_ssm_parameter" "db-username-backend-main" {
  name = "/apprunner/alpha/backend/DB_USERNAME"
}

data "aws_ssm_parameter" "db-password-backend-main" {
  name = "/apprunner/alpha/backend/DB_PASSWORD"
}
