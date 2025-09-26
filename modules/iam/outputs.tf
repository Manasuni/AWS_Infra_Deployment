output "provisioner_role_arn" {
  value = aws_iam_role.provisioner.arn
}

output "scan_runner_role_arn" {
  value = aws_iam_role.scan_runner.arn
}
