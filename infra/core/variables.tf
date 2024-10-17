variable "aws_region" {
  type        = string
  description = "The AWS region the AWS resources are in."
  default     = "us-west-2"
}

variable "availability_zone" {
  type        = string
  description = "The AWS availability zone the resources are in."
  default     = "us-west-2d"
}

variable "disk_name" {
  type        = string
  description = "The AWS availability zone the resources are in."
  default     = "db_data"
}

variable "injected_key_status" {
  type        = string
  description = "Determines whether temporary access key for user data script is active or not"
}

locals {
  ls_keypair = data.aws_ssm_parameter.ls_keypair.value
  allowed_ip = data.aws_ssm_parameter.allowed_ip.value
}
