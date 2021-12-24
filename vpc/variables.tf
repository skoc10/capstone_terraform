variable "cidr_block" {
  type        = string
  description = "The CIDR block for the VPC."
}

variable "public_subnet_count" {
  type        = number
  description = "The number of public subnets to create in the VPC."
}

variable "private_subnet_count" {
  type        = number
  description = "The number of private subnets to create in the VPC."
}

variable "subnet_bit_size" {
  type        = number
  description = "The number size (in bits) to dedicate to each subnet. For example, a value of 8 would allow for 256 hosts in each subnet."
}


/* variable "network_interface_id" {}

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
} */