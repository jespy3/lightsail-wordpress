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

# Variables imported from .env file

variable "MYSQL_ROOT_PASSWORD" {
  description = "To be used in the compose file's environment variables within the Lightsail instance."
  type        = string
  sensitive = true
}

variable "MYSQL_DATABASE" {
  description = "To be used in the compose file's environment variables within the Lightsail instance."
  type        = string
  sensitive = true
}

variable "MYSQL_PASSWORD" {
  description = "To be used in the compose file's environment variables within the Lightsail instance."
  type        = string
  sensitive = true
}

variable "WORDPRESS_DB_USER" {
  description = "To be used in the compose file's environment variables within the Lightsail instance."
  type        = string
  sensitive = true
}

variable "WORDPRESS_DB_PASSWORD" {
  description = "To be used in the compose file's environment variables within the Lightsail instance."
  type        = string
  sensitive = true
}

variable "WORDPRESS_DB_NAME" {
  description = "To be used in the compose file's environment variables within the Lightsail instance."
  type        = string
  sensitive = true
}

