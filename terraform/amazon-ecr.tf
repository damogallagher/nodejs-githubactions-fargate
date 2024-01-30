
locals {
  repository_name = "${var.environment}-repository"
}

resource "aws_ecr_repository" "ecr_repository" {
  name         = local.repository_name
  force_delete = true
  image_scanning_configuration {
    scan_on_push = true
  }
}

output "ecr_repository_arn" {
  value = aws_ecr_repository.ecr_repository.arn
}

output "ecr_repository_name" {
  value = local.repository_name
}

