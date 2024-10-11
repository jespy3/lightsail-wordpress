resource "aws_lightsail_disk" "db_data" {
  name              = var.name
  size_in_gb        = var.size_in_gb
  availability_zone = var.availability_zone

  lifecycle {
    prevent_destroy = true
  }
}

