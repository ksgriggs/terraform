provider "aws" {
    profile = "default"
    region  = var.aws_region
}

data "aws_ami" "search" {
    most_recent = true

    filter {
        name = "virtualization-type"
        values = ["hvm"]
     }
 
    # Use Amazon Linux 2 AMI (HVM) SSD Volume Type
    name_regex = "^amzn2-ami-hvm-.*x86_64-gp2"
    owners = ["137112412989"]
}

resource "aws_instance" "server" {
    ami             = lookup(var.aws_amis, var.aws_region)
    instance_type   = var.aws_instance_type
    key_name        = var.key_name
    security_groups = var.aws_security_group
    user_data = var.user_data

    tags = var.tags
}
