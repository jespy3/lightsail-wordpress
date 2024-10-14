locals {
  parameter_prefix = "/lightsail-wordpress/compose_environment"
}

resource "aws_ssm_parameter" "MYSQL_ROOT_PASSWORD" {
  name  = "${local.parameter_prefix}/MYSQL_ROOT_PASSWORD"
  type  = "String"
  value = var.MYSQL_ROOT_PASSWORD
}

