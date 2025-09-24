variable "project_name" {}
variable "environment" {}
variable "cluster_role_arn" {}
variable "node_role_arn" {}
variable "private_subnet_ids" {
  type = list(string)
}
variable "node_instance_types" {
  type = list(string)
  default = ["t3.medium"]
}
variable "spot_desired" { 
  type = number
  default = 1 
  }
variable "spot_min"     { 
  type = number
  default = 0 
  }
variable "spot_max"     {
  type = number
  default = 3 
  }
variable "od_desired"   { 
  type = number 
  default = 2 
  }
variable "od_min"       { 
  type = number
  default = 1 
  }
variable "od_max"       { 
  type = number
  default = 4 
  }
