variable "alb-name" {
  description = "Name of ALB"
  type = string
}

variable "alb-sg-id" {
  description = "Id of ALB security group"
  type = string
}

variable "alb-subnets" {
  description = "Id of subnets of the ALB"
  type = list(string)
}

variable "vpc-id" {
  description = "Id of the VPC"
  type = string
}

variable "s3-bucket" {
  description = "Id of S3 bucket"
  type = string
}

variable "s3-prefix" {
  description = "Prefix of S3 bucket"
  type = string
}

variable "alb-env" {
  description = "Env of ALB"
  type = string
}
