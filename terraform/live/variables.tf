variable "aws_region" {
  description = "The AWS region to deploy resources into"
  type        = string
  default     = "eu-west-1"
}

variable "enable_ssh_access" {
  type = bool
  default = false
}