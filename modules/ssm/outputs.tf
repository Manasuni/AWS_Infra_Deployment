output "db_password" {
  value = aws_ssm_parameter.db_password.id
}

output "api_key" {
  value = aws_ssm_parameter.api_key.id
}
