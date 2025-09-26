resource "aws_ssm_parameter" "db_password" {
  name  = "/my-app/dev/db_password"
  type  = "SecureString"
  value = "example-db-pass-123"
}

resource "aws_ssm_parameter" "api_key" {
  name  = "/my-app/dev/api_key"
  type  = "SecureString"
  value = "example-api-key-abc"
}
