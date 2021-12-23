variable "vpc_cidr" {
  type = string
}

variable "public_cidrs_1a" {
  type = string
}

variable "public_cidrs_1b" {
  type = string
}

variable "private_cidrs_1a" {
  type = string
}

variable "private_cidrs_1b" {
  type = string
}

variable "network_interface_id" {}

variable "service_name" {}

variable "service_type" {}

variable "access_ip" {
  type = string
}

variable "alb_security_group" {}

variable "ec2_security_group" {}

variable "rds_security_group" {}

variable "natinstance_security_group" {}

variable "db_subnet_group" {
  type = bool
}