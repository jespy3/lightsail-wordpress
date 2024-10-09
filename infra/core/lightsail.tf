locals {
  az = "us-west-2d"
}

resource "aws_lightsail_instance" "wordpress_and_db" {
  name              = "wordpress_and_db"
  availability_zone = local.az
  blueprint_id      = "debian_12"
  bundle_id         = "micro_3_0"
  key_pair_name     = local.ls_keypair
  ip_address_type   = "ipv4"

  # Replace the placeholder in user-data.sh with the docker-compose.yaml content
  user_data = replace(
    file("${path.module}/referenced-files/user-data.sh"),
    "DOCKER_COMPOSE_CONTENTS",
    file("${path.module}/referenced-files/compose-file-in-container.yaml")
  )
}

resource "aws_lightsail_instance_public_ports" "instance_ports" {
  instance_name = aws_lightsail_instance.wordpress_and_db.name

  port_info {
    protocol  = "tcp"
    from_port = 22
    to_port   = 22
  }

  port_info {
    protocol  = "tcp"
    from_port = 8080
    to_port   = 8080
    cidrs     = ["${local.allowed_ip}/32"]
  }

  lifecycle {
    ignore_changes = [port_info]
  }
}

resource "aws_lightsail_disk" "db_data" {
  name              = "db_data"
  size_in_gb        = 8
  availability_zone = local.az
}

resource "aws_lightsail_disk_attachment" "db_data_attachment" {
  disk_name     = aws_lightsail_disk.db_data.name
  instance_name = aws_lightsail_instance.wordpress_and_db.name
  disk_path     = "/dev/xvdf"
}

