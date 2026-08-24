variable "aws_region" {
  description = "The AWS region to deploy resources into"
  type        = string
  default     = "eu-west-1"
}

variable "enable_ssh_access" {
  type    = bool
  default = false
}

variable "enable_maint_mode" {
  type    = bool
  default = false
}

variable "cloudflare_account_id" {
  description = "The Cloudflare account ID"
  type        = string
}

variable "custom_email" {
  description = "The email address to use for Cloudflare email routing"
  type        = string
}

variable "destination_email" {
  description = "The destination email address to forward emails to"
  type        = string
}