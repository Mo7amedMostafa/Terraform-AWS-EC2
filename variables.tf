# Project
variable "project_name" {
    default = "xyz"
}

# Location
variable "region" {
  default = "us-east-1"
}
variable "availability_zone" {
    default = "us-east-1a"
}

# Auth
variable "access_key" {
    default = "access_key_here"
}
variable "secret_key" {
    default = "secret_key_here"
}

# Key
variable "private_key" {
    default = "./files/SSH_Private_Key"
}
variable "public_key" {
    default = "ssh-rsa public_key_here admin@local.com"
}

# Network
variable "vpc" {
    default = "10.20.20.0/25"
}
variable "private_ip_address" {
  type    = string
  default = "10.20.20.120"
}

variable "private_subnet" {
  type    = string
  default = "10.20.20.0/26"
}
variable "public_subnet" {
  type    = string
  default = "10.20.20.64/26"
}

# EC2
variable "ami" {
    default = "ami-0574da719dca65348"
}
variable "instance_type" {
    default = "t2.micro"
}
variable "volume_size" {
    default = "8"
}

# Script
#variable "user_data" {
#    default = <<-EOF
#                    #!/bin/bash
#                    sudo apt update -y
#                    sudo mkdir /docker
#                    sudo chmod 777 /docker
#                    #sudo apt install apache2 -y
#                    #sudo systemctl start apache2
#                    #sudo bash -c 'echo your very first web server > /var/www/html/index.html'
#                    EOF
#}

#data "template_file" "user_data" {
#        template = file("./files/cloud-init.yml")
#    }
