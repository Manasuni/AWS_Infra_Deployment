output "config_bucket_name" {
  value = aws_s3_bucket.config_bucket.id
}

output "config_recorder_role_arn" {
  value = var.role_arn
}
