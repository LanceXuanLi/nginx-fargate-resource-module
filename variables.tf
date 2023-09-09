variable "project-name" {
  description = "Name of project"
  type = string
  default = "sapia"
}

variable "project-env" {
  description = "Environment of project"
  type = string
  default = "prod"
}

variable "alb-log-s3-prefix" {
  description = "Prefix of ALB log in s3"
  type = string
  default = "sapia"
}

variable "waf-description" {
  description = "Description of waf"
  type = string
  default = ""
}

variable "project-region" {
  description = "Region of the project"
  type = string
  default = "ap-southeast-2"
}