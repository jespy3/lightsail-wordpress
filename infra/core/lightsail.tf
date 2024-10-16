locals {
  docker_compose_content = file("${path.module}/referenced-files/compose-file-in-container.yaml")

  # Replace placeholder in the user-data script with Docker Compose content
  base_user_data = replace(
    file("${path.module}/referenced-files/user-data.sh"),
    "DOCKER_COMPOSE_CONTENTS",
    local.docker_compose_content
  )

  # Inject access key
  user_data_with_first_key = replace(
    local.base_user_data,
    "AWS_ACCESS_KEY_ID_PLACEHOLDER",
    aws_iam_access_key.user_data_script.id
  )

  # Inject secret key
  user_data_with_keys = replace(
    local.user_data_with_first_key,
    "AWS_SECRET_ACCESS_KEY_PLACEHOLDER",
    aws_iam_access_key.user_data_script.secret
  )
}

resource "aws_lightsail_instance" "wordpress_and_db" {
  name              = "wordpress_and_db"
  availability_zone = var.availability_zone
  blueprint_id      = "debian_12"
  bundle_id         = "micro_3_0"
  key_pair_name     = local.ls_keypair
  ip_address_type   = "ipv4"

  user_data = local.user_data_with_keys
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

resource "aws_lightsail_disk_attachment" "db_data_attachment" {
  disk_name     = var.disk_name
  instance_name = aws_lightsail_instance.wordpress_and_db.name
  disk_path     = "/dev/xvdf"

  depends_on = [aws_lightsail_instance.wordpress_and_db]
}

