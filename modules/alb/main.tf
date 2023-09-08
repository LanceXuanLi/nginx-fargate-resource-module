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