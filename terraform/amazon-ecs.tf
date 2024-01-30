resource "aws_ecs_cluster" "fargate_cluster" {
  name = "${var.company}-cluster"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

resource "aws_ecs_task_definition" "fargate_task" {
  family                   = "${var.company}-fargate-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 1024 # CPU units (1 vCPU = 256 CPU units)
  memory                   = 2048 # Memory in MiB

  execution_role_arn = aws_iam_role.ecs_execution_role.arn

  container_definitions = jsonencode([{
    name  = "${var.company}-container"
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
  name            = "${var.company}-fargate-service"
  cluster         = aws_ecs_cluster.fargate_cluster.id
  task_definition = aws_ecs_task_definition.fargate_task.arn
  launch_type     = "FARGATE"
  desired_count   = 2
  network_configuration {
    subnets         = aws_subnet.private_subnet[*].id
    security_groups = []
  }
}

output "ecs_cluster_arn" {
  value = aws_ecs_cluster.fargate_cluster.arn
}

output "ecs_cluster_name" {
  value = "${var.company}-cluster"
}

output "ecs_service_name" {
  value = "${var.company}-fargate-service"
}

output "ecs_task_definition_name" {
  value = "${var.company}-fargate-task"
}

output "ecs_task_container_name" {
  value = "${var.company}-container"
}

