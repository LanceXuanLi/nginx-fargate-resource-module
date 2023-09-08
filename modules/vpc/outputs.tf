output "vpc-id" {
  value = aws_vpc.vpc.id
}

output "public-subnets" {
  value = aws_subnet.public.*.id
}

output "private-subnets" {
  value = aws_subnet.private.*.id
}

output "alb-sg" {
  value = aws_security_group.alb.id
}

output "ecs-sg" {
  value = aws_security_group.ecs.id
}