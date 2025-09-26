output "ssm_db_password" {
  value = module.ssm.db_password
}

output "ssm_api_key" {
  value = module.ssm.api_key
}

output "iam_role_arn" {
  value = module.iam.provisioner_role_arn
}

# output in root module
output "guardduty_detector_id" {
  value = module.guardduty.guardduty_detector_id
}