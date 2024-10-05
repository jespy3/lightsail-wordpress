variable aws_region {
  type        = string
  description = "The AWS region the AWS resources are in."
  default     = "us-west-2"
}

locals {
  ls_keypair = data.aws_ssm_parameter.ls_keypair.value
}
