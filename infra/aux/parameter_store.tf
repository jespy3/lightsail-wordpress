locals {
  compose_file_secrets_prefix = "/lightsail-wordpress/compose_environment"
  terraform_vars_prefix       = "/lightsail-wordpress/terraform_vars"

  compose_file_secrets = {
    "MYSQL_ROOT_PASSWORD"   = var.MYSQL_ROOT_PASSWORD
    "MYSQL_DATABASE"        = var.MYSQL_DATABASE
    "MYSQL_PASSWORD"        = var.MYSQL_PASSWORD
    "WORDPRESS_DB_USER"     = var.WORDPRESS_DB_USER
    "WORDPRESS_DB_PASSWORD" = var.WORDPRESS_DB_PASSWORD
    "WORDPRESS_DB_NAME"     = var.WORDPRESS_DB_NAME
  }

  terraform_vars = {
    "allowed_ip" = var.allowed_ip
    "aws_role"   = var.aws_role
    "ls_keypair" = var.ls_keypair
  }
}

resource "aws_ssm_parameter" "compose_file_secrets" {
  for_each = local.compose_file_secrets

  name        = "${local.compose_file_secrets_prefix}/${each.key}"
  description = "The value of ${each.key} to be used in the compose file's environment variables within the Lightsail instance."
  type        = "SecureString"
  value       = each.value
}

resource "aws_ssm_parameter" "terraform_vars" {
  for_each = local.terraform_vars

  name        = "${local.terraform_vars_prefix}/${each.key}"
  description = "The ${each.key} variable of the terraform for the lightsail-wordpress repo"
  type        = "SecureString"
  value       = each.value
}

