output "ecs-cluster-name" {
  value = aws_ecs_cluster.cluster.name
}

output "ecs-service-name" {
  value = aws_ecs_service.service.name
}