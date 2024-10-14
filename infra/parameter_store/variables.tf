variable "aws_region" {
  type        = string
  description = "The AWS region the AWS resources are in."
  default     = "us-west-2"
}

variable "availability_zone" {
  default = "us-west-2d"
  description = "The availability zone for the Lightsail disk."
  type        = string
}
