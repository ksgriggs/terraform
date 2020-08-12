# variables.tf

variable "aws_region" {
    default = "us-east-1"
    type = string
}

variable "availability_zone" {
    default = "us-east-1a"
    type = string
}

variable "vpc_CIDR_block" {
    default = "10.0.0.0/16"
    type = string
}

variable "subnet_CIDR_block" {
    default = "10.0.0.0/24"
    type = string
}