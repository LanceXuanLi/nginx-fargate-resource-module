variable "project-name" {
  description = "Name of project"
  type = string
}

variable "project-env" {
  description = "Environment of project"
  type = string
}

variable "alb-log-s3-prefix" {
  description = "Prefix of ALB log in s3"
  type = string
}

variable "waf-description" {
  description = "Description of waf"
  type = string
}

variable "first-n-azs" {
  description = "First n available zones"
  type = number
}