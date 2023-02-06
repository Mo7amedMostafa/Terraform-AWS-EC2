# 9. Create Ubuntu server and install/enable apache2

resource "aws_instance" "web-server-instance" {
    ami               = var.ami
    instance_type     = var.instance_type
    availability_zone = var.availability_zone
    subnet_id         = aws_subnet.public.id
    # count = 2 # create 2 instance with the same specs
    #private_ip        = var.private_ip_address
    associate_public_ip_address = true
    security_groups = [aws_security_group.allow_ports.id]
    key_name = "${var.project_name}-key"
    ebs_block_device {
        device_name = "/dev/sda1"
        volume_type = "gp2"
        volume_size = var.volume_size
        tags = { Name = "volume-${var.project_name}" }
    }
    #network_interface {
    # device_index         = 0
    # network_interface_id = aws_network_interface.web-server-nic.id
    #}

    
    #user_data = var.user_data
    #user_data = data.template_file.user_data.rendered
    
    provisioner "file" {
    source      = "./docker"
    destination = "/tmp"

        connection {
            type     = "ssh"
            user     = "ubuntu"
            #password = "${var.root_password}"
            host     = aws_instance.web-server-instance.public_ip
            private_key = file(var.private_key)
        }
    }

    provisioner "remote-exec" {
    
        inline = [
        "sudo mkdir /docker/ ; sudo chmod 777 /docker/ -R",
        "sudo mv /tmp/docker/* /docker/",
        "sudo chmod +x /docker/build.sh",
        "sudo /docker/build.sh",
        ]

        connection {
            type     = "ssh"
            user     = "ubuntu"
            #password = "${var.root_password}"
            host     = aws_instance.web-server-instance.public_ip
            private_key = file(var.private_key)
        }
    }



    tags = {
        Name = "web-server-${var.project_name}"
    }
}

 output "server_private_ip" {
   value = aws_instance.web-server-instance.private_ip
 }

 output "server_public_ip" {
   value = aws_eip.one.public_ip
 }

 output "server_id" {
   value = aws_instance.web-server-instance.id
 }
