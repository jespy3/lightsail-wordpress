resource "aws_lightsail_instance" "wordpress_and_db" {
  name              = "wordpress_and_db"
  availability_zone = "us-west-2d"
  blueprint_id      = "debian_12"
  bundle_id         = "nano_3_0"
  key_pair_name     = local.ls_keypair
  ip_address_type   = "ipv4"

  # Replace the placeholder in user-data.sh with the docker-compose.yaml content
  user_data = replace(
    file("${path.module}/referenced-files/user-data.sh"),
    "DOCKER_COMPOSE_CONTENTS",
    file("${path.module}/referenced-files/compose-file-in-container.yaml")
  )
}

resource "aws_lightsail_key_pair" "ls_kp" {
  name = local.ls_keypair
}

