import {
  to = aws_ssm_parameter.terraform_vars["allowed_ip"]
  id = "/lightsail-wordpress/terraform-vars/allowed_ip"
}

import {
  to = aws_ssm_parameter.terraform_vars["aws_role"]
  id = "/lightsail-wordpress/terraform-vars/aws_role"
}

import {
  to = aws_ssm_parameter.terraform_vars["ls_keypair"]
  id = "/lightsail-wordpress/terraform-vars/ls_keypair"
}

