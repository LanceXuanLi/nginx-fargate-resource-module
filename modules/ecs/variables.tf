variable "ecs-name" {
  description = "Name of ecs"
  type = string
}

variable "ecs-env" {
  description = "Env of ecs"
  type = string
}

variable "alb-target-group-arn" {
  description = "ARN of the Load Balancer target group"
  type = string
}

variable "ecs-private-subnets-ids" {
  description = "List of id of ecs subnets"
  type = list(string)
}

variable "ecs-security-group" {
  description = "Security group of ecs task"
  type = string
}

variable "task-desired-count" {
  description = "Number of task desired"
  type = number
}