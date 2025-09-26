provider "aws" {
  region = var.region
}

# IAM module
module "iam" {
  source             = "./modules/iam"
  environment        = var.environment
  ssm_parameter_path = var.ssm_parameter_path
}

# Enable GuardDuty
resource "aws_guardduty_detector" "main" {
  enable = true
}

# AWS Config rules
resource "aws_config_config_rule" "sg_no_open" {
  name = "disallow-sg-open-${var.environment}"
  source {
    owner             = "AWS"
    source_identifier = "INCOMING_SSH_DISABLED"
  }
}

resource "aws_config_config_rule" "unencrypted_s3" {
  name = "unencrypted-s3-${var.environment}"
  source {
    owner             = "AWS"
    source_identifier = "S3_BUCKET_SERVER_SIDE_ENCRYPTION_ENABLED"
  }
}

resource "aws_config_config_rule" "unencrypted_rds" {
  name = "unencrypted-rds-${var.environment}"
  source {
    owner             = "AWS"
    source_identifier = "RDS_STORAGE_ENCRYPTED"
  }
}

# Example secrets (DB password & API key) stored in SSM
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
