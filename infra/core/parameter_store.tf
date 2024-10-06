data "aws_ssm_parameter" "aws_role" {
  name = "/lightsail-wordpress/terraform-vars/aws_role"
}

data "aws_ssm_parameter" "ls_keypair" {
  name = "/lightsail-wordpress/terraform-vars/ls_keypair"
}
