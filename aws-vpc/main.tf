# main.tf

provider "aws" {
  region  = var.aws_region
}

resource "aws_vpc" "tf-vpc" {
  cidr_block           = var.vpc_CIDR_block
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    "Name" = "tf-vpc"
  }
}

resource "aws_default_network_acl" "tf-nacl" {
  default_network_acl_id = aws_vpc.tf-vpc.default_network_acl_id

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
    "Name" = "tf-nacl"
  }
}

resource "aws_internet_gateway" "tf-igw" {
  vpc_id = aws_vpc.tf-vpc.id

  tags = {
    "Name" = "tf-igw"
  }
}

resource "aws_default_route_table" "tf-route-table" {
  default_route_table_id = aws_vpc.tf-vpc.default_route_table_id

  tags = {
    "Name" = "tf-route-table"
  }
}

resource "aws_subnet" "tf-subnet-public-az1" {
  vpc_id                  = aws_vpc.tf-vpc.id
  cidr_block              = var.subnet_CIDR_block
  availability_zone       = var.availability_zone
  map_public_ip_on_launch = true

  tags = {
    "Name" = "tf-subnet-public"
  }
}

resource "aws_route_table_association" "tf-subnet-public-az1" {
  subnet_id      = aws_subnet.tf-subnet-public-az1.id
  route_table_id = aws_vpc.tf-vpc.default_route_table_id
}

resource "aws_route" "tf-igw-public" {
  route_table_id = aws_default_route_table.tf-route-table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.tf-igw.id
}

resource "aws_default_security_group" "tf-sg-public" {
  vpc_id = aws_vpc.tf-vpc.id

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
    "Name" = "tf-sg-public"
  }
}