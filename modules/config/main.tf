# Generate random suffix for unique names
resource "random_id" "suffix" {
  byte_length = 4
}

# S3 bucket for Config delivery channel
resource "aws_s3_bucket" "config_bucket" {
  bucket = "my-config-bucket-${random_id.suffix.hex}"
}

# ACL for S3 bucket
resource "aws_s3_bucket_acl" "config_bucket_acl" {
  bucket = aws_s3_bucket.config_bucket.id
  acl    = "private"
}

# IAM Role input from IAM module
# Expecting root to pass module.iam.provisioner_role_arn
variable "role_arn" {
  type = string
}

# Config recorder
resource "aws_config_configuration_recorder" "recorder" {
  name     = "default"
  role_arn = var.role_arn
  recording_group {
    all_supported = true
  }
}

# Delivery channel
resource "aws_config_delivery_channel" "channel" {
  name           = "default"
  s3_bucket_name = aws_s3_bucket.config_bucket.bucket
}

# Config rules
resource "aws_config_config_rule" "sg_no_open" {
  name = "disallow-sg-open-${random_id.suffix.hex}"
  source {
    owner             = "AWS"
    source_identifier = "INCOMING_SSH_DISABLED"
  }
}

resource "aws_config_config_rule" "unencrypted_s3" {
  name = "unencrypted-s3-${random_id.suffix.hex}"
  source {
    owner             = "AWS"
    source_identifier = "S3_BUCKET_SERVER_SIDE_ENCRYPTION_ENABLED"
  }
}

resource "aws_config_config_rule" "unencrypted_rds" {
  name = "unencrypted-rds-${random_id.suffix.hex}"
  source {
    owner             = "AWS"
    source_identifier = "RDS_STORAGE_ENCRYPTED"
  }
}
