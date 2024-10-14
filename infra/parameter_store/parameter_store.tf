locals {
  parameter_prefix = "/lightsail-wordpress/compose_environment"
}

resource "aws_ssm_parameter" "MYSQL_ROOT_PASSWORD" {
  name  = "${local.parameter_prefix}/MYSQL_ROOT_PASSWORD"
  description = "To be used in the compose file's environment variables within the Lightsail instance."
  type  = "SecureString"
  value = var.MYSQL_ROOT_PASSWORD
}

