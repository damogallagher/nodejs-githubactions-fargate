provider "aws" {
  region  = "eu-west-1"
  profile = var.aws_profile

  default_tags {
    tags = {
      environment = var.environment_name
      project     = var.company_name
    }
  }
}

terraform {
  backend "s3" {
    bucket = "201532394678-terraform-state"
  }
}