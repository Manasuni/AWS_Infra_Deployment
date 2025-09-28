variable "project_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "private_subnet_ids" {
  type = list(string)
}

variable "cluster_role_arn" {
  type = string
}

variable "node_role_arn" {
  type = string
}

variable "spot_desired" {
  type = number
}

variable "spot_min" {
  type = number
}

variable "spot_max" {
  type = number
}

variable "od_desired" {
  type = number
}

variable "od_min" {
  type = number
}

variable "od_max" {
  type = number
}

variable "node_instance_types" {
  type = list(string)
}
