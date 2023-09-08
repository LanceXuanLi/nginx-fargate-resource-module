variable "waf-name" {
  description = "Name of WAF"
  type        = string
}

variable "waf-env" {
  description = "Environment of WAF"
  type        = string
}

variable "waf-description" {
  description = "Description of WAF"
  type        = string
}

variable "aln-arn" {
  description = "ARN of the ALB"
  type        = string
}