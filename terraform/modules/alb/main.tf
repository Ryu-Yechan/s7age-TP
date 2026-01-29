# Application Load Balancer
resource "aws_lb" "stage_alb" {
  name                       = "${var.env_name}stageALB"
  internal                   = false
  load_balancer_type         = "application"
  security_groups            = [var.alb_sg_id]
  subnets                    = [var.public_subnet_a_id, var.public_subnet_b_id]
  idle_timeout               = 300
  enable_deletion_protection = false
}

# Target Group for k3s Ingress
resource "aws_lb_target_group" "k3s_ingress" {
  name     = "${var.env_name}tg-k3s-ingress"
  port     = 30080
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    enabled             = true
    healthy_threshold   = 5
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 30
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200-499"
  }
}

# HTTP Listener
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.stage_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.k3s_ingress.arn
  }
}

# HTTPS Listener
resource "aws_lb_listener" "https" {
  count             = var.certificate_arn != "" ? 1 : 0
  load_balancer_arn = aws_lb.stage_alb.arn
  port              = 443
  protocol          = "HTTPS"

  ssl_policy      = "ELBSecurityPolicy-TLS13-1-2-Res-PQ-2025-09"
  certificate_arn = var.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.k3s_ingress.arn
  }
}
# Target Group Attachments
resource "aws_lb_target_group_attachment" "master" {
  target_group_arn = aws_lb_target_group.k3s_ingress.arn
  target_id        = var.master_instance_id
  port             = 30080
}

resource "aws_lb_target_group_attachment" "worker" {
  for_each         = var.worker_instances != null ? var.worker_instances : {}  # null 체크 추가
  target_group_arn = aws_lb_target_group.k3s_ingress.arn
  target_id        = each.value
  port             = 30080
}