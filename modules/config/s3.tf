# S3 Bucket (if not already created)
resource "aws_s3_bucket" "config_bucket" {
  bucket = "my-config-bucket-${random_id.suffix.hex}"
  # no need for acl here if using bucket policy
}

# Random suffix for bucket uniqueness
resource "random_id" "suffix" {
  byte_length = 4
}

# S3 Bucket Policy for AWS Config
resource "aws_s3_bucket_policy" "config_bucket_policy" {
  bucket = aws_s3_bucket.config_bucket.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid = "AWSConfigPermissions"
        Effect = "Allow"
        Principal = {
          Service = "config.amazonaws.com"
        }
        Action = "s3:PutObject"
        Resource = "${aws_s3_bucket.config_bucket.arn}/*"
        Condition = {
          StringEquals = {
            "s3:x-amz-acl" = "bucket-owner-full-control"
          }
        }
      },
      {
        Sid = "AWSConfigBucketList"
        Effect = "Allow"
        Principal = {
          Service = "config.amazonaws.com"
        }
        Action   = "s3:GetBucketAcl"
        Resource = aws_s3_bucket.config_bucket.arn
      }
    ]
  })
}
