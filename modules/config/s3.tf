# S3 Bucket for AWS Config
resource "aws_s3_bucket" "config_bucket" {
  bucket = "my-config-bucket-${random_id.suffix.hex}"
}

# S3 Bucket Policy
resource "aws_s3_bucket_policy" "config_bucket_policy" {
  bucket = aws_s3_bucket.config_bucket.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid = "AWSConfigPermissions"
        Effect = "Allow"
        Principal = { Service = "config.amazonaws.com" }
        Action = "s3:PutObject"
        Resource = "${aws_s3_bucket.config_bucket.arn}/AWSLogs/*"
        Condition = {
          StringEquals = { "s3:x-amz-acl" = "bucket-owner-full-control" }
        }
      },
      {
        Sid = "AWSConfigBucketList"
        Effect = "Allow"
        Principal = { Service = "config.amazonaws.com" }
        Action   = "s3:GetBucketAcl"
        Resource = aws_s3_bucket.config_bucket.arn
      }
    ]
  })
}
