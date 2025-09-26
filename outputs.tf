output "provisioner_role_arn" {
  value = module.iam.provisioner_role_arn
}

output "scan_runner_role_arn" {
  value = module.iam.scan_runner_role_arn
}
