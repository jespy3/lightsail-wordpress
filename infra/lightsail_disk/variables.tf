variable "aws_region" {
  type        = string
  description = "The AWS region the AWS resources are in."
  default     = "us-west-2"
}

variable "availability_zone" {
  default     = "us-west-2d"
  description = "The availability zone for the Lightsail disk."
  type        = string
}

variable "size_in_gb" {
  default     = 8
  description = "The size of the Lightsail disk in GB."
  type        = number
}

variable "name" {
  default     = "db_data"
  description = "The name of the lightsail disk"
  type        = string
}
