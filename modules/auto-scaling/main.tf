resource "aws_appautoscaling_target" "ecs-auto-scaling-target" {
  max_capacity       = 6
  min_capacity       = 1
  resource_id        = "service/${var.ecs-cluster-name}/${var.ecs-service-name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

resource "aws_appautoscaling_policy" "ecs-auto-scaling-policy-memory" {
  name               = "${var.auto-scaling-name}-memory-policy"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.ecs-auto-scaling-target.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs-auto-scaling-target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs-auto-scaling-target.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      # type can be found in this site: https://docs.aws.amazon.com/autoscaling/plans/APIReference/API_PredefinedScalingMetricSpecification.html
      predefined_metric_type = "ECSServiceAverageMemoryUtilization"
    }
    target_value = 60
  }
}

resource "aws_appautoscaling_policy" "ecs-auto-scaling-policy-cpu" {
  name               = "${var.auto-scaling-name}-cpu-policy"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.ecs-auto-scaling-target.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs-auto-scaling-target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs-auto-scaling-target.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      # type can be found in this site: https://docs.aws.amazon.com/autoscaling/plans/APIReference/API_PredefinedScalingMetricSpecification.html
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }
    target_value = 80
  }
}