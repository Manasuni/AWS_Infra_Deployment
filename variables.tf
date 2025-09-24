variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "environment" {
  type    = string
  default = "non-prod"
}

variable "project_name" {
  type    = string
  default = "idurar-erp-crm"
}
variable "db_password" { type = string }
variable "redis_auth_token" { type = string }

variable "bucket_name" {
  type        = string
  description = "Name of the S3 bucket"
  default     = "my-static-bucket-example"
}
