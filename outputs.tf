output "vpc-id" {
  value = module.vpc.vpc-id
}

output "alb-arn" {
  value = module.alb.alb-arn
}

output "waf-id" {
  value = module.waf.waf-id
}

output "ecs-cluster-name" {
  value = module.ecs.ecs-cluster-name
}

output "ecs-service-name" {
  value = module.ecs.ecs-service-name
}
