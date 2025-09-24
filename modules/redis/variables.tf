variable "project_name" {}
variable "environment" {}
variable "private_subnet_ids" { type = list(string) }
variable "node_type" { default = "cache.t3.small" }
variable "num_nodes" { default = 2 }
variable "auth_token" { type = string }
variable "kms_key_id" { type = string }
