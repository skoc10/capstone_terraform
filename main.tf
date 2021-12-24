provider "aws" {
  region     = "us-east-1"
  #access_key = "xxxxxxxxxxxxxxxxxxxxxxxxx"
  #secret_key = "xxxxxxxxxxxxxxxxxxxxxxxxx"
}

module "vpc" {
  source                     = "./vpc"
  cidr_block                 = "80.80.0.0/16"
  public_subnet_count        = "2"
  private_subnet_count       = "2"
  subnet_bit_size            = "8"
  access_ip                  = var.access_ip
  alb_security_group         = var.alb_security_group
  ec2_security_group         = var.ec2_security_group
  rds_security_group         = var.rds_security_group
  natinstance_security_group = var.natinstance_security_group
  service_name               = "com.amazonaws.us-east-1.s3"
  service_type               = "Gateway"
  db_subnet_group            = true
  network_interface_id       = module.ec2.network_interface_id

}

module "ec2" {
  source         = "./ec2"
  natinstance_sg = module.vpc.natinstance_sg
  public_subnets = module.vpc.public_subnets[0]
  instance_type = "t2.micro"
  key_name      = "key"
}