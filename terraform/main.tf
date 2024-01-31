provider "aws" {
  region = "eu-west-1"
  profile = "damiensandbox-ergo"

  default_tags {
    tags = {
      environment = var.environment
      project     = var.company
    }
  }
}

terraform {
  backend "s3" {
    bucket = "201532394678-terraform-state"
  }
}