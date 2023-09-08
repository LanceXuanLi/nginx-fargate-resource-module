# --------------------- alb ---------------------

resource "aws_lb" "alb" {

  name               = var.alb-name
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.alb-sg-id]
  subnets            = var.alb-subnets

  # let terraform to delete ALB, change it to true when in prod env.
  enable_deletion_protection = false

  access_logs {
    bucket  = var.s3-bucket
    # store in the root
    #prefix  = "test-lb"
    enabled = true
  }

  tags = {
    Name = "${var.alb-name}-alb"
    Env = var.alb-env
  }
}

# --------------------- target_group ---------------------


resource "aws_lb_target_group" "tg" {
  name     = "${var.alb-name}-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc-id

  health_check {
    path = "/"
  }
}
# aws_lb_target_group_attachment in ecs module.

# --------------------- lb_listener ---------------------


resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "Fixed response content"
      status_code  = "200"
    }
  }
}

resource "aws_lb_listener_rule" "listener-rule" {
  listener_arn = aws_lb_listener.listener.arn
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }

  condition {
    path_pattern {
      values = ["/nginx/*"]
    }
  }
}
