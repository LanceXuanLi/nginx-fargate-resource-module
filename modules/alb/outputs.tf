output "target_group_arn" {
  value = aws_lb_target_group.tg.arn
}

output "alb-arn" {
  value = aws_lb.alb.arn
}