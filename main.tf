provider "aws" {
  region = var.region
  access_key = var.access_key
  secret_key = var.secret_key
}

resource "aws_key_pair" "aws_key" {
  key_name   = "${var.project_name}-key"
  public_key = var.public_key
}

output "server_private_ip" {
   value = aws_instance.web-server-instance.private_ip
 }

output "public_dns" {
   value = aws_instance.web-server-instance.public_dns
}
output "server_public_ip" {
   value = aws_instance.web-server-instance.public_ip
 }

output "server_id" {
   value = aws_instance.web-server-instance.id
 }