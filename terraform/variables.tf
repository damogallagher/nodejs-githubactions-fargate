
variable "aws_account_id" {
  type        = string
  description = "AWS accountId to use"
  default     = null
}

variable "aws_region" {
  type        = string
  description = "AWS region to use"
  default     = "eu-west-1"
}

variable "company_name" {
  type        = string
  description = "Company name to tag on resources and for naming resources"
  default     = null
}

variable "environment_name" {
  type        = string
  description = "Environment name to tag on resources and for naming resources"
  default     = null
}
