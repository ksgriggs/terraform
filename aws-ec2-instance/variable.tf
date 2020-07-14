variable "aws_region" {
    description = "AWS region to launch server."
    default = "us-east-1"
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