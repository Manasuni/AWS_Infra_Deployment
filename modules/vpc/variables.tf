variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}
variable "azs" {
  type    = list(string)
  default = ["ap-south-1a","ap-south-1b"]
}
variable "project_name" { type = string }
variable "environment" { type = string }
