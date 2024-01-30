# Create an Application Load Balancer
resource "aws_lb" "fargate_alb" {
  name               = "${var.environment}-fargate-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.fargate_alb_sg.id]
  subnets            = aws_subnet.private_subnet[*].id
}

# Create a security group for the ALB
resource "aws_security_group" "fargate_alb_sg" {
  name        = "${var.environment}-alb-security-group"
  description = "Security group for ALB"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create an ALB target group
resource "aws_lb_target_group" "fargate_target_group" {
  name        = "${var.environment}-fargate-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.vpc.id
  target_type = "alb"
}

# Attach the ALB target group to the ALB listener
resource "aws_lb_listener" "fargate_listener" {
  load_balancer_arn = aws_lb.fargate_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.fargate_target_group.arn
  }
}