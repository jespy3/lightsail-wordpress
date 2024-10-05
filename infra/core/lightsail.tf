resource "aws_lightsail_instance" "wordpress_and_db" {
  name              = "wordpress_and_db"
  availability_zone = "us-west-2d"
  blueprint_id      = "debian_12"
  bundle_id         = "nano_3_0"
  key_pair_name     = var.old_kp
  ip_address_type    = "ipv4"
}

# Create a new Lightsail Key Pair
resource "aws_lightsail_key_pair" "ls_keypair" {
  name = local.ls_keypair
}

