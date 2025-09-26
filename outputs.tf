output "ssm_db_password" {
  value = module.ssm.db_password
}

output "ssm_api_key" {
  value = module.ssm.api_key
}

output "iam_role_arn" {
  value = module.iam.provisioner_role_arn
}

output "guardduty_detector_id" {
  value = module.guardduty.guardduty_detector_id
}

output "config_bucket_name" {
  value = module.config.config_bucket_name
}

output "config_recorder_role_arn" {
  value = module.config.config_recorder_role_arn
}
