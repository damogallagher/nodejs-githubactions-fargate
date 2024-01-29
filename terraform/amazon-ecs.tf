resource "aws_ecs_cluster" "ecs_cluster" {
name = "${var.company_name}-cluster"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

resource "aws_ecs_task_definition" "fargate_task" {
  family                   = "${var.company_name}-fargate-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"  # CPU units (1 vCPU = 256 CPU units)
  memory                   = "512"  # Memory in MiB

  execution_role_arn = aws_iam_role.ecs_execution_role.arn

  container_definitions = jsonencode([{
    name  = "${var.company_name}-container"
    image = "nginx:latest"
    portMappings = [{
      containerPort = 3000
      hostPort      = 3000
    }]
  }])
}

resource "aws_iam_role" "ecs_execution_role" {
  name = "ecs_execution_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = {
        Service = "ecs-tasks.amazonaws.com"
      }
    }]
  })
}

resource "aws_ecs_service" "fargate_service" {
  name            = "${var.company_name}-fargate-service"
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.fargate_task.arn
  launch_type     = "FARGATE"
  desired_count   = 2
  network_configuration {
    subnets = aws_subnet.fargate_subnet[*].id
    security_groups = []
  }
}

output "ecs_cluster_arn" {
  value = aws_ecs_cluster.ecs_cluster.arn
}

output "ecs_cluster_name" {
  value = "${var.company_name}-cluster"
}

output "ecs_service_name" {
  value = "${var.company_name}-fargate-service"
}

output "ecs_task_definition_arn" {
    value = aws_ecs_task_definition.fargate_task.arn
}
output "ecs_task_definition_name" {
    value = "${var.company_name}-fargate-task"
}
