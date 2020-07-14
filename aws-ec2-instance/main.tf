provider "aws" {
    profile = "default"
    region  = var.aws_region
}

resource "aws_instance" "server" {
    ami             = lookup(var.aws_amis, var.aws_region)
    instance_type   = var.aws_instance_type
    key_name        = var.key_name
    security_groups = var.aws_security_group
    user_data = var.user_data

    tags = var.tags
}
