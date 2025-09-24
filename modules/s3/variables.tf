variable "bucket_name" {
  type        = string
  description = "Name of the S3 bucket"
  default     = "my-example-bucket"
}

variable "environment" {
  type        = string
  description = "Environment tag (e.g., dev, prod)"
}

variable "enable_versioning" {
  type    = bool
  default = true
}

variable "kms_key_id" {
  type        = string
  description = "KMS Key ID for S3 encryption (use alias/aws/s3 if not specified)"
  default     = "alias/aws/s3"
}
