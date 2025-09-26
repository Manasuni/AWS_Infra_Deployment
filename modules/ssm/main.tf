variable "ssm_parameter_path" {
  type    = string
  default = "/my-app/dev/"
}

resource "aws_ssm_parameter" "db_password" {
  name  = "${var.ssm_parameter_path}db_password"
  type  = "SecureString"
  value = "example-db-pass-123"
}

resource "aws_ssm_parameter" "api_key" {
  name  = "${var.ssm_parameter_path}api_key"
  type  = "SecureString"
  value = "example-api-key-abc"
}
