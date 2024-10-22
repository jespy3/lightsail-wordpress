data "aws_ssm_parameter" "aws_role" {
  name = "/lightsail-wordpress/terraform_vars/aws_role"
}

data "aws_ssm_parameter" "ls_keypair" {
  name = "/lightsail-wordpress/terraform_vars/ls_keypair"
}

data "aws_ssm_parameter" "allowed_ip" {
  name = "/lightsail-wordpress/terraform_vars/allowed_ip"
}

data "aws_ssm_parameter" "domain_name" {
  name = "/lightsail-wordpress/terraform_vars/domain_name"
}

