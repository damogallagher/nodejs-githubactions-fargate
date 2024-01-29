
resource "aws_ecr_repository" "ecr_repository" {
  name = "${var.company_name}-repository"  # Replace with your desired repository name

  image_scanning_configuration {
    scan_on_push = true
  }
}

output "ecr_repository_arn" {
  value = aws_ecr_repository.ecr_repository.arn
}

output "ecr_repository_name" {
  value = "${var.company_name}-repository"
}

