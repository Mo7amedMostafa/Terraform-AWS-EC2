resource "aws_vpc" "this" {
  cidr_block = var.vpc
  enable_dns_hostnames = true
  tags = {
    "Name" = "${var.project_name}-pvc"
  }
}
#resource "aws_subnet" "private" {
#  vpc_id            = aws_vpc.this.id
#  cidr_block        = var.private_subnet
#  availability_zone = var.availability_zone
#  tags = {
#    "Name" = "${var.project_name}-private"
#  }
#}
resource "aws_subnet" "public" {
  vpc_id            = aws_vpc.this.id
  cidr_block        = var.public_subnet
  availability_zone = var.availability_zone
  tags = {
    "Name" = "${var.project_name}-public"
  }
}
resource "aws_route_table" "this-rt" {
  vpc_id = aws_vpc.this.id
  tags = {
    "Name" = "${var.project_name}-route-table"
  }
}
resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.this-rt.id
}
#resource "aws_route_table_association" "private" {
#  subnet_id      = aws_subnet.private.id
#  route_table_id = aws_route_table.this-rt.id
#}
resource "aws_internet_gateway" "this-igw" {
  vpc_id = aws_vpc.this.id
  tags = {
    "Name" = "${var.project_name}-igateway"
  }
}
resource "aws_route" "internet-route" {
  destination_cidr_block = "0.0.0.0/0"
  route_table_id         = aws_route_table.this-rt.id
  gateway_id             = aws_internet_gateway.this-igw.id
}
resource "aws_network_interface" "this-nic" {
  subnet_id       = aws_subnet.public.id
  #private_ips     = [var.private_ip_address]
  security_groups = [aws_security_group.allow_ports.id]
  tags = {
    "Name" = "${var.project_name}-nic"
  }
}
resource "aws_eip" "ip-one" {
  vpc                       = true
  network_interface         = aws_network_interface.this-nic.id
  tags = {
    "Name" = "${var.project_name}-eip"
  }
}

resource "aws_security_group" "allow_ports" {
   name        = "allow_web_traffic_${var.project_name}"
   description = "Allow Web inbound traffic"
   vpc_id      = aws_vpc.this.id

   ingress {
     description = "HTTPS"
     from_port   = 443
     to_port     = 443
     protocol    = "tcp"
     cidr_blocks = ["0.0.0.0/0"]
   }
   ingress {
     description = "HTTP"
     from_port   = 80
     to_port     = 80
     protocol    = "tcp"
     cidr_blocks = ["0.0.0.0/0"]
   }
   ingress {
     description = "SSH"
     from_port   = 22
     to_port     = 22
     protocol    = "tcp"
     cidr_blocks = ["0.0.0.0/0"]
   }

   egress {
     from_port   = 0
     to_port     = 0
     protocol    = "-1"
     cidr_blocks = ["0.0.0.0/0"]
   }

   tags = {
     Name = "allow_ports_${var.project_name}"
   }
 }