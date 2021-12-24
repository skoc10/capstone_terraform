provider "aws" {
  region     = "us-east-1"
  #access_key = "xxxxxxxxxxxxxxxxxxxxxxxxx"
  #secret_key = "xxxxxxxxxxxxxxxxxxxxxxxxx"
}

resource "aws_vpc" "app_vpc" {
  cidr_block           = var.cidr_block
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name = "app_vpc"
  }
}
resource "aws_subnet" "public" {
  count = "${var.public_subnet_count}"

  vpc_id     = "${aws_vpc.app_vpc.id}"
  cidr_block = "${cidrsubnet(var.cidr_block, var.subnet_bit_size, count.index)}"

  tags = {
    Name = "app_pub_${count.index+1}"
  }
}

resource "aws_subnet" "private" {
  count = "${var.private_subnet_count}"

  vpc_id     = "${aws_vpc.app_vpc.id}"
  cidr_block = "${cidrsubnet(var.cidr_block, var.subnet_bit_size, var.public_subnet_count + count.index)}"

  tags = {
    Name = "app_pri_${count.index+1}"
  }
}

resource "aws_internet_gateway" "app_igv" {
    vpc_id = aws_vpc.app_vpc.id
    tags = {
      Name = "app_igv"
    }
}

resource "aws_route_table" "app_pub_rt" {
  vpc_id = aws_vpc.app_vpc.id

  tags = {
    Name = "app_pub_rt"
  }
}
resource "aws_default_route_table" "app_pri_rt" {
  default_route_table_id = aws_vpc.app_vpc.default_route_table_id

  tags = {
    "Name" = "app_pri_rt"
  }
}

resource "aws_route" "public_route" {
  route_table_id         = aws_route_table.app_pub_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.app_igv.id
}

/* resource "aws_route" "private_route" {
  route_table_id         = aws_default_route_table.app_pri_rt.id
  destination_cidr_block = "0.0.0.0/0"
  #network_interface_id   = var.network_interface_id
}
 */
resource "aws_route_table_association" "public" {
  count          = var.public_subnet_count
  subnet_id      = aws_subnet.public.*.id
  route_table_id = aws_route_table.app_pub_rt.id[count.index]
}

/* resource "aws_route_table_association" "private" {
  count          = "${var.public_subnet_count}"
  subnet_id      = aws_subnet.private.*.id
  route_table_id = aws_default_route_table.app_pri_rt.id[count.index]
} */

/* resource "aws_vpc_endpoint" "app_vpcendpoint" {
  service_name      = var.service_name
  route_table_ids   = [aws_default_route_table.app_pri_rt.id]
  vpc_endpoint_type = var.service_type
  vpc_id            = aws_vpc.app_vpc.id
}
 */
