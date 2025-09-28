variable "project_name" {}
variable "environment" {}
variable "private_subnet_ids" { type = list(string) }
variable "db_name" { default = "appdb" }
variable "db_username" { default = "appuser" }
variable "db_password" { type = string }
variable "instance_class" { default = "db.t3.medium" }
variable "allocated_storage" { default = 20 }
variable "engine_version" {
  default = "15.14"   # pick a valid RDS Postgres version from your region
}
variable "kms_key_id" {
  type = string
  description = "KMS key ARN or ID"
}
