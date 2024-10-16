locals {
  docker_compose_content = file("${path.module}/referenced-files/compose-file-in-container.yaml")

  # Generate user data script from the template file
  user_data_with_keys = templatefile("${path.module}/referenced-files/user-data-template.sh", {
    aws_access_key_id     = aws_iam_access_key.user_data_script.id
    aws_secret_access_key = aws_iam_access_key.user_data_script.secret
    docker_compose_content = local.docker_compose_content
  })
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

