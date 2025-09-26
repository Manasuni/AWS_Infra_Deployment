variable "region" {
  type    = string
  default = "ap-south-1"
}

variable "environment" {
  type    = string
  default = "dev"
}

variable "ssm_parameter_path" {
  type        = string
  description = "Path prefix for SSM parameters (e.g., /my-app/dev/)"
  default     = "/my-app/dev/"
}
