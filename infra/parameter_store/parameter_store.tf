locals {
  parameter_prefix = "/lightsail-wordpress/compose_environment"

  compose_file_secrets = {
    "MYSQL_ROOT_PASSWORD" = var.MYSQL_ROOT_PASSWORD
    "MYSQL_DATABASE" = var.MYSQL_DATABASE
    "MYSQL_PASSWORD" = var.MYSQL_PASSWORD
    "WORDPRESS_DB_USER" = var.WORDPRESS_DB_USER
    "WORDPRESS_DB_PASSWORD" = var.WORDPRESS_DB_PASSWORD
    "WORDPRESS_DB_NAME" = var.WORDPRESS_DB_NAME
  }
}

resource "aws_ssm_parameter" "compose_file_secrets" {
  for_each = local.compose_file_secrets

  name  = "${local.parameter_prefix}/${each.key}"
  description = "The value of ${each.key} to be used in the compose file's environment variables within the Lightsail instance."
  type  = "SecureString"
  value = each.value
}

