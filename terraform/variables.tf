
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

variable "company" {
  type        = string
  description = "Company name to tag on resources and for naming resources"
  default     = null
}

variable "environment" {
  type        = string
  description = "Environment name to tag on resources and for naming resources"
  default     = null
}

//Networking
variable "vpc_cidr" {
  description = "The CIDR block of the vpc"
}

variable "public_subnets_cidr" {
  type        = list
  description = "The CIDR block for the public subnet"
}

variable "private_subnets_cidr" {
  type        = list
  description = "The CIDR block for the private subnet"
}