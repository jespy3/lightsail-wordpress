resource "aws_lightsail_instance" "wordpress_and_db" {
  name              = "wordpress_and_db"
  availability_zone = "us-west-2d"
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
}

resource "aws_lightsail_key_pair" "ls_kp" {
  name = local.ls_keypair
}

output "private_key" {
  value     = aws_lightsail_key_pair.ls_kp.private_key
  sensitive = true
}

