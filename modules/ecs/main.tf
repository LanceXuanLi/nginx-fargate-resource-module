# --------------------- ecs-cluster ---------------------



resource "aws_ecs_cluster" "cluster" {
  name = "${var.ecs-name}-cluster"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
  tags = {
    Name = "${var.ecs-name}-cluster"
    Env  = var.ecs-env
  }
}

# --------------------- ecs-capacity_providers ---------------------


resource "aws_ecs_cluster_capacity_providers" "capacity-provider" {
  cluster_name = aws_ecs_cluster.cluster.name

  capacity_providers = ["FARGATE", "FARGATE_SPOT"]
}

# --------------------- task-definition ---------------------

resource "aws_ecs_task_definition" "task-definition" {
  family                   = "nginx"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 256
  memory                   = 512
  container_definitions    = jsonencode([
    {
      name         = "${var.ecs-name}-container"
      image        = "nginx:latest"
      cpu          = 256
      memory       = 512
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
        }
      ]
    }
  ])

  tags = {
    Name = "${var.ecs-name}-task-definition"
    Env  = var.ecs-env
  }
}

# --------------------- service ---------------------


resource "aws_ecs_service" "service" {
  name            = "${var.ecs-name}-service"
  cluster         = aws_ecs_cluster.cluster.id
  task_definition = aws_ecs_task_definition.task-definition.arn
  desired_count   = var.task-desired-count
  lifecycle {
    ignore_changes = [desired_count]
  }

  network_configuration {
    subnets         = var.ecs-private-subnets-ids
    security_groups = [var.ecs-security-group]
  }

  capacity_provider_strategy {
    capacity_provider = "FARGATE"
    base              = 1
    weight            = 1
  }

  capacity_provider_strategy {
    capacity_provider = "FARGATE_SPOT"
    weight            = 1
  }

  load_balancer {
    target_group_arn = var.alb-target-group-arn
    container_name   = "${var.ecs-name}-container"
    container_port   = 80
  }


  tags = {
    Name = "${var.ecs-name}-service"
    Env  = var.ecs-env
  }
}