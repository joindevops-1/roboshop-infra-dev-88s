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

resource "aws_instance" "redis" {
    ami = local.ami_id
    instance_type = "t3.micro"
    vpc_security_group_ids = [local.redis_sg_id]
    subnet_id = local.database_subnet_id

    tags = merge (
        local.common_tags,
        {
            Name = "${var.project}-${var.environment}-redis"
        }
    )
}

resource "terraform_data" "redis" {
  triggers_replace = [
    aws_instance.redis.id
  ]
  
  connection {
    type     = "ssh"
    user     = local.ssh_credentials["ssh_user"]
    password = local.ssh_credentials["ssh_password"]
    host     = aws_instance.redis.private_ip
  }

  # terraform copies this file to redis server
  provisioner "file" {
    source = "bootstrap.sh"
    destination = "/tmp/bootstrap.sh"
  }

  provisioner "remote-exec" {
    inline = [
        "chmod +x /tmp/bootstrap.sh",
        # "sudo sh /tmp/bootstrap.sh"
        "sudo sh /tmp/bootstrap.sh redis dev"
    ]
  }
}

resource "aws_route53_record" "mongodb" {
  zone_id = var.zone_id
  name    = "mongodb-${var.environment}.${var.domain_name}" # mongodb-dev.daws86s.fun
  type    = "A"
  ttl     = 1
  records = [aws_instance.mongodb.private_ip]
  allow_overwrite = true
}

resource "aws_route53_record" "redis" {
  zone_id = var.zone_id
  name    = "redis-${var.environment}.${var.domain_name}" # mongodb-dev.daws86s.fun
  type    = "A"
  ttl     = 1
  records = [aws_instance.redis.private_ip]
  allow_overwrite = true
}