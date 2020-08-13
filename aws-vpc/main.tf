# main.tf

provider "aws" {
  region  = var.aws_region
}

resource "aws_vpc" "default" {
  cidr_block           = var.vpc_CIDR_block
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    "Name" = "tf_vpc"
  }
}

resource "aws_default_network_acl" "default" {
  default_network_acl_id = aws_vpc.default.default_network_acl_id

  ingress {
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  egress {
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  tags = {
    "Name" = "tf_nacl"
  }
}

resource "aws_internet_gateway" "default" {
  vpc_id = aws_vpc.default.id

  tags = {
    "Name" = "tf_igw"
  }
}

resource "aws_default_route_table" "default" {
  default_route_table_id = aws_vpc.default.default_route_table_id

  tags = {
    "Name" = "tf_route_table"
  }
}

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.default.id
  cidr_block              = var.subnet_CIDR_block
  availability_zone       = var.availability_zone
  map_public_ip_on_launch = true

  tags = {
    "Name" = "tf_subnet_public"
  }
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_vpc.default.default_route_table_id
}

resource "aws_route" "public_internet_gateway" {
  route_table_id = aws_default_route_table.default.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.default.id
}

resource "aws_default_security_group" "default" {
  vpc_id = aws_vpc.default.id

  # Allow ingress on port 22
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow egress on all ports
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    "Name" = "tf_sg_public"
  }
}