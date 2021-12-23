provider "aws" {
  region     = "us-east-1"
  #access_key = "xxxxxxxxxxxxxxxxxxxxxxxxx"
  #secret_key = "xxxxxxxxxxxxxxxxxxxxxxxxx"
}

resource "aws_vpc" "app-vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name = "app-vpc"
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_subnet" "app-pub-1a" {
  vpc_id = aws_vpc.app-vpc.id
  cidr_block = var.public_cidrs_1a
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "app-pub-1a"
  } 
}
resource "aws_subnet" "app-pub-1b" {
    vpc_id = aws_vpc.app-vpc.id
    cidr_block = var.public_cidrs_1b
    availability_zone = "us-east-1b"
    map_public_ip_on_launch = true
    tags = {
    Name = "app-pub-1b"
  }
}
resource "aws_subnet" "app-pri-1a" {
    vpc_id = aws_vpc.app-vpc.id
    cidr_block = var.private_cidrs_1a
    availability_zone = "us-east-1a"
    map_public_ip_on_launch = false
    tags = {
    Name = "app-pri-1a"
  }
}
resource "aws_subnet" "app-pri-1b" {
    vpc_id = aws_vpc.app-vpc.id
    cidr_block = var.private_cidrs_1b
    availability_zone = "us-east-1b"
    map_public_ip_on_launch = false
    tags = {
    Name = "app-pri-1b"
  }
}

resource "aws_internet_gateway" "app-igv" {
    vpc_id = aws_vpc.app-vpc.id
    tags = {
    Name = "app-igv"
  }
}

resource "aws_route_table" "app-pub-rt" {
  vpc_id = aws_vpc.app-vpc.id

  tags = {
    Name = "app-pub-rt"
  }
}
resource "aws_default_route_table" "app-pri-rt" {
  default_route_table_id = aws_vpc.app-vpc.default_route_table_id

  tags = {
    "Name" = "aws_capstone_private"
  }
}

resource "aws_route" "public_route" {
  route_table_id         = aws_route_table.app-pub-rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.app-igv.id
}

resource "aws_route" "private_route" {
  route_table_id         = aws_default_route_table.app-pri-rt.id
  destination_cidr_block = "0.0.0.0/0"
  #network_interface_id   = var.network_interface_id
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.app-pub.*.id[count.index]
  route_table_id = aws_route_table.app-pub-rt.id
}

resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.app-pri.*.id[count.index]
  route_table_id = aws_default_route_table.app-pri-rt.id
}

/* resource "aws_vpc_endpoint" "app-vpcendpoint" {
  service_name      = var.service_name
  route_table_ids   = [aws_default_route_table.app-pri-rt.id]
  vpc_endpoint_type = var.service_type
  vpc_id            = aws_vpc.app-vpc.id
} */

