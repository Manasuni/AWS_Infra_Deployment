variable "role_arn" {
  type = string
}

# 1️⃣ Configuration Recorder
resource "aws_config_configuration_recorder" "recorder" {
  name     = "default"
  role_arn = var.role_arn

  recording_group {
    all_supported = true
  }
}

# 2️⃣ Enable Configuration Recorder
resource "aws_config_configuration_recorder_status" "recorder_status" {
  name       = aws_config_configuration_recorder.recorder.name
  is_enabled = true
}

# 3️⃣ Wait for recorder to become ACTIVE
resource "null_resource" "wait_recorder" {
  provisioner "local-exec" {
    command = <<EOT
echo "Waiting for AWS Config recorder to become ACTIVE..."
for i in {1..12}; do
  STATUS=$(aws configservice describe-configuration-recorders --query 'ConfigurationRecorders[0].recording' --output text)
  if [ "$STATUS" == "True" ]; then
    echo "Recorder is ACTIVE"
    exit 0
  fi
  sleep 10
done
echo "Recorder did not become ACTIVE in time"
exit 1
EOT
  }

  depends_on = [aws_config_configuration_recorder_status.recorder_status]
}

# 5️⃣ Delivery Channel - depends on recorder being ACTIVE
resource "aws_config_delivery_channel" "channel" {
  name           = "default"
  s3_bucket_name = aws_s3_bucket.config_bucket.bucket

  depends_on = [null_resource.wait_recorder, aws_s3_bucket.config_bucket]
}

# 6️⃣ Random suffix for Config Rule names
resource "random_id" "suffix" {
  byte_length = 4
}

# 7️⃣ Config Rules
resource "aws_config_config_rule" "sg_no_open" {
  name = "disallow-sg-open-${random_id.suffix.hex}"
  source {
    owner             = "AWS"
    source_identifier = "INCOMING_SSH_DISABLED"
  }
  depends_on = [aws_config_delivery_channel.channel]
}

resource "aws_config_config_rule" "unencrypted_s3" {
  name = "unencrypted-s3-${random_id.suffix.hex}"
  source {
    owner             = "AWS"
    source_identifier = "S3_BUCKET_SERVER_SIDE_ENCRYPTION_ENABLED"
  }
  depends_on = [aws_config_delivery_channel.channel]
}

resource "aws_config_config_rule" "unencrypted_rds" {
  name = "unencrypted-rds-${random_id.suffix.hex}"
  source {
    owner             = "AWS"
    source_identifier = "RDS_STORAGE_ENCRYPTED"
  }
  depends_on = [aws_config_delivery_channel.channel]
}
