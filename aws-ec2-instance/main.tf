variable "instance_type" {
  type = string
}

variable "key_name" {
  description = "Name of AWS key pair."
  type        = string
}

variable "user_data" {
    description = "File to run after instance creation."
    type        = string
}

provider "aws" {
  profile = "default"
  region  =  "us-east-1"
}

data "aws_ami" "search" {
  most_recent = true

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
   }
 
  # Use Amazon Linux 2 AMI (HVM) SSD Volume Type
  name_regex = "^amzn2-ami-hvm-.*x86_64-gp2"
  owners     = ["137112412989"] # Amazon
}

# Use default VPC
resource "aws_default_vpc" "default" {}

# Use default subnet
resource "aws_default_subnet" "default" {
  availability_zone = "us-east-1a"

  tags = {
    "Terraform" : "true"
  }
}

resource "aws_security_group" "tf_sg" {
  name        = "tf_sg"
  description = "Allow SSH inbound and all outbound"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # This is NOT safe. Use the IP to SSH from.
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    "Terraform" : "true"  
  }
}

resource "aws_instance" "tf_server" {
  ami             = data.aws_ami.search.id
  instance_type   = var.instance_type

  vpc_security_group_ids = [
    aws_security_group.tf_sg.id
  ]

  key_name        = var.key_name
  user_data       = file(var.user_data)

  tags = {
    "Terraform" : "true"
  }
}
