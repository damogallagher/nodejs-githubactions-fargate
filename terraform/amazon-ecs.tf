resource "aws_ecs_cluster" "ecs_cluster" {
name = "${var.company_name}-cluster"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

output "ecs_cluster_arn" {
  value = aws_ecs_cluster.ecs_cluster.arn
}

output "ecs_cluster_name" {
  value = "${var.company_name}-cluster"
}

