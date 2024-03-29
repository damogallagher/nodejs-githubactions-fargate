
locals {
  cluster_name         = "${var.environment}-cluster"
  container_name       = "${var.environment}-container"
  service_name         = "${var.environment}-fargate-service"
  task_definition_name = "${var.environment}-fargate-task"
}


resource "aws_ecs_cluster" "fargate_cluster" {
  name = local.cluster_name

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

resource "aws_ecs_task_definition" "fargate_task" {
  family                   = local.task_definition_name
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 1024 # CPU units (1 vCPU = 256 CPU units)
  memory                   = 2048 # Memory in MiB

  execution_role_arn = aws_iam_role.ecs_execution_role.arn

  container_definitions = jsonencode([{
    name  = local.container_name
    image = "nginx:latest"

    portMappings = [{
      containerPort = 3000
      hostPort      = 3000
    }]

    #health_check = {
    #  command      = ["CMD-SHELL", "curl -f http://localhost:3000/ || exit 1"]
    #  interval     = 30 # Health check interval in seconds
    #  timeout      = 5  # Timeout period in seconds
    #  retries      = 3  # Number of retries before considering the container unhealthy
    #  start_period = 60 # Time period in seconds to ignore the health check results after task startup
    #}


  }])
}

resource "aws_iam_role" "ecs_execution_role" {
  name = "ecs_fargate_execution_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = {
        Service = "ecs-tasks.amazonaws.com"
      }
      }
    ]
  })
  inline_policy {
    name = "ecs_execution_role_inline_policy"
    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Action = [
            "ecr:GetAuthorizationToken",
            "ecr:BatchCheckLayerAvailability",
            "ecr:GetDownloadUrlForLayer",
            "ecr:BatchGetImage",
            "logs:CreateLogStream",
            "logs:PutLogEvents",
            "*"
          ]
          Effect   = "Allow"
          Resource = "*"
        },
      ]
    })
  }
}

resource "aws_ecs_service" "fargate_service" {
  name            = local.service_name
  cluster         = aws_ecs_cluster.fargate_cluster.id
  task_definition = aws_ecs_task_definition.fargate_task.arn
  launch_type     = "FARGATE"
  desired_count   = 2

  network_configuration {
    subnets         = aws_subnet.private_subnet[*].id
    security_groups = [aws_security_group.fargate_alb_sg.id, aws_security_group.interface_endpoints.id]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.fargate_target_group.arn
    container_name   = local.container_name
    container_port   = 3000
  }
}

output "ecs_cluster_name" {
  value = local.cluster_name
}

output "ecs_service_name" {
  value = local.service_name
}

output "ecs_task_definition_name" {
  value = local.task_definition_name
}

output "ecs_task_container_name" {
  value = local.container_name
}

