resource "aws_lightsail_instance" "wordpress_and_db" {
  name              = "wordpress_and_db"
  availability_zone = "us-west-2d"
  blueprint_id      = "debian_12"
  bundle_id         = "nano_3_0"
  key_pair_name     = local.ls_keypair
  ip_address_type   = "ipv4"
  user_data         = file("${path.module}/user-data.sh")
}

resource "aws_lightsail_key_pair" "ls_kp" {
  name = local.ls_keypair
}

