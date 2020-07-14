variable "aws_region" {
    description = "AWS region to launch server."
    default = "us-east-1"
}

variable "aws_amis" {
    description = "Add regions and AMI as needed."
    default = {
        us-east-1 = "ami-08f3d892de259504d"
#        us-east-2 = "ami-#"
#        us-west-1 = "ami-#"
#        us-west-2 = "ami-#"
    }
}

variable "aws_security_group" {
    default = ["Web-DMZ"]
}

variable "aws_instance_type" {
    default = "t2.micro"
}

variable "key_name" {
    description = "Name of AWS key pair."
    default = "MyEC2KP"
}

variable "user_data" {
    description = "File to run after instance creation."
    default = "user_data.sh"
}

variable "tags" {
    default = {
        Name = "TF-EC2"
    }
}