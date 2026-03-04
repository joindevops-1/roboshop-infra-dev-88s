resource "aws_instance" "mongodb" {
    ami = local.ami_id
    instance_type = "t3.micro"
    vpc_security_group_ids = [local.mongodb_sg_id]
    subnet_id = local.database_subnet_id

    tags = merge (
        local.common_tags,
        {
            Name = "${var.project}-${var.environment}-mongodb"
        }
    )
}

resource "terraform_data" "mongodb" {
  triggers_replace = [
    aws_instance.mongodb.id
  ]
  
  connection {
    type     = "ssh"
    user     = local.ssh_credentials["ssh_user"]
    password = local.ssh_credentials["ssh_password"]
    host     = aws_instance.mongodb.private_ip
  }

  # terraform copies this file to mongodb server
  provisioner "file" {
    source = "bootstrap.sh"
    destination = "/tmp/bootstrap.sh"
  }

  provisioner "remote-exec" {
    inline = [
        "chmod +x /tmp/bootstrap.sh",
        # "sudo sh /tmp/bootstrap.sh"
        "sudo sh /tmp/bootstrap.sh mongodb dev"
    ]
  }
}